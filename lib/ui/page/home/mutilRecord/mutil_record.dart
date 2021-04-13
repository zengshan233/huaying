import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/view_model/home/recrod_model.dart';
import './mutil_upload.dart';
import './mutil_projects.dart';

class MutilRecord extends StatefulWidget {
  MutilRecord({Key key}) : super(key: key);

  @override
  _MutilRecordState createState() => _MutilRecordState();
}

class _MutilRecordState extends State<MutilRecord> {
  TextEditingController _barCodeControll = TextEditingController(); //条码号

  String _companyId = ''; //单位名称id

  TextEditingController _companyNameControll = TextEditingController(); //单位名称

  List<Map<String, dynamic>> _submitData = [];

  List<String> _hasExistNum = []; //已存在的条码号

  bool hasSubmit = false;

  int mulPicCount = 0;
  int picCount = 0;

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: appBarWithName(context, '批量录单', '外勤:', withName: true),
          body: ProviderWidget<RecrodModel>(
              model: RecrodModel(context),
              builder: (cContext, model, child) {
                return Column(
                  children: <Widget>[
                    _boxNum(),
                    _baseInfo(),
                    buildProjectHead(),
                    MutilProjects(
                      submitData: _submitData,
                      addProject: (code) => addProject(barCode: code),
                      delete: (code) => _removeSubmitItem(code),
                    ),
                    UploadImgage(
                        enable: mulPicCount == 0,
                        updateImages: (data) {
                          if (data != null && data.isNotEmpty) {
                            List<Map<String, String>> tempList = [];
                            for (var x in data) {
                              Map<String, String> tempMap = {};
                              tempMap['fileId'] = x.id;
                              tempList.add(tempMap);
                            }
                            _submitData.forEach((d) {
                              d['imageItems'] = tempList;
                            });
                            picCount = tempList.length;
                          } else {
                            picCount = 0;
                            _submitData.forEach((d) {
                              d['imageItems'] = [];
                            });
                          }
                          setState(() {});
                        },
                        submit: (data) {
                          submit(model);
                        })
                  ],
                );
              })),
    );
  }

  Widget _boxNum() {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil().setHeight(140),
      color: Colors.white,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _leftText('标本箱号'),
          _leftText('0123123123'), // 先写死
          new SizedBox(width: ScreenUtil().setWidth(140)),
          new Image(
              color: Colors.black,
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              image: new AssetImage(ImageHelper.wrapAssets("right_more.png")),
              fit: BoxFit.fill),
          radiusButton(text: '交接单', img: "transfer_ticket.png")
        ],
      ),
    );
  }

  Widget _leftText(String title) {
    return Container(
      child: Text(title,
          style: TextStyle(
              color: DiyColors.normal_black, fontSize: ScreenUtil().setSp(40))),
    );
  }

  Widget buildProjectHead() {
    return Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
      height: ScreenUtil().setHeight(140),
      color: Colors.white,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: Text('已录数据',
                      style: TextStyle(
                          color: DiyColors.normal_black,
                          fontSize: ScreenUtil().setSp(40))),
                ),
                Text('已录入${_submitData.length}条数据',
                    style: TextStyle(
                        color: Color.fromRGBO(93, 164, 255, 1),
                        fontSize: ScreenUtil().setSp(30)))
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                InkWell(
                    onTap: () async {
                      if (picCount > 0 || _submitData.isEmpty) {
                        return;
                      }
                      Navigator.push(context,
                              MaterialPageRoute(builder: (_) => MutilUpload()))
                          .then((value) {
                        if (value != null) {
                          int idx = _submitData.indexWhere(
                              (d) => d['apply']['barCode'] == value.first);
                          if (idx > -1) {
                            List<Map<String, String>> tempList = [];
                            for (var x in value.last) {
                              Map<String, String> tempMap = {};
                              tempMap['fileId'] = x.id;
                              tempList.add(tempMap);
                            }
                            _submitData[idx]['imageItems'] = tempList;
                            mulPicCount = tempList.length;
                            setState(() {});
                          }
                        }
                      });
                    },
                    child: AnimatedOpacity(
                        opacity:
                            (picCount == 0 && _submitData.isNotEmpty) ? 1 : 0.3,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(40)),
                            child: Image(
                                width: ScreenUtil().setWidth(200),
                                image: new AssetImage(
                                    ImageHelper.wrapAssets("mulAddPic.png")),
                                fit: BoxFit.fill)))),
                InkWell(
                    onTap: () {
                      if (_submitData.isEmpty) {
                        return;
                      }
                      addProject();
                    },
                    child: AnimatedOpacity(
                        opacity: _submitData.isNotEmpty ? 1 : 0.3,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                            child: Image(
                                width: ScreenUtil().setWidth(250),
                                image: new AssetImage(ImageHelper.wrapAssets(
                                    "mulAddProject.png")),
                                fit: BoxFit.fill)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addProject({String barCode}) {
    Navigator.pushNamed(
      context,
      RouteName.selectItem,
    ).then((value) {
      //print('接收到的项目返回值：'+value.toString());
      List<Map<String, String>> _projectItemArray = [];
      for (var x in jsonDecode(value.toString())) {
        if (_projectItemArray.any((e) => e['itemId'] == x['id'])) continue;
        Map<String, String> tempObj = {};
        tempObj['barCode'] = x['barCode'];
        tempObj['enShortName'] = x['enShortName'];
        tempObj['itemId'] = x['id'];
        tempObj['itemName'] = x['itemName'];
        tempObj['itemType'] = x['type'].toString();
        tempObj['itemTypeName'] = x['typeName'];
        tempObj['labId'] = x['labDeptId'];
        tempObj['labName'] = x['labDeptName'];
        tempObj['professionalGroupId'] = x['disciplineId'];
        tempObj['professionalGroupName'] = x['disciplineName'];
        tempObj['specimenType'] = x['specimenTypeId'];
        tempObj['specimenTypeName'] = x['specimenTypeName'];
        tempObj['sortOrder'] = x['sortOrder'].toString();
        _projectItemArray.add(tempObj);
      }
      if (barCode == null) {
        _submitData.forEach((d) {
          d['items'] = _projectItemArray;
        });
      } else {
        int idx =
            _submitData.indexWhere((d) => d['apply']['barCode'] == barCode);
        if (idx > -1) {
          _submitData[idx]['items'] = _projectItemArray;
        }
      }
      print('_submitData $_submitData');
      setState(() {});
    });
  }

  void _removeSubmitItem(String barCode) {
    var curIndex =
        _submitData.indexWhere((e) => (e['apply']['barCode'] == barCode));
    _submitData.removeAt(curIndex);
    setState(() {
      _submitData = _submitData;
    });
  }

  void _addSubmitItem(BuildContext context) {
    if (_barCodeControll.text.length != 12) {
      showMsgToast('条码号长度必须为12位！', context: context);
      return;
    }
    // if(_barCodeControll.text.substring(10,12)!='00'){
    // 	showMsgToast(
    // 		'条码号必须以00结尾！',
    // 		context: context
    // 	);
    // 	return;
    // }
    if (_submitData.length >= 20) {
      showMsgToast('录单列表数据最多为20条！', context: context);
      return;
    }
    var curIndex = _submitData
        .indexWhere((e) => (e['apply']['barCode'] == _barCodeControll.text));
    print(curIndex);
    if (curIndex >= 0) {
      showMsgToast('列表已存在该条码，请重新输入！', context: context);
      return;
    }
    List<FileUploadItem> imageItems = [];
    Map<String, dynamic> tempObj = {
      "apply": {
        "inspectionUnitName": _companyNameControll.text,
        "inspectionUnitId": _companyId,
        "barCode": _barCodeControll.text,
      },
      "imageItems": imageItems,
      "items": []
    };
    _submitData.insert(0, tempObj);

    setState(() {
      _submitData = _submitData;
    });
  }

  // 基本信息
  Widget _baseInfo() {
    return new Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
        child: new Column(
          children: <Widget>[
            simpleRecordInput(context,
                preText: '送检单位',
                hintText: '(必填)请选择送检单位',
                enbleInput: false,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: _companyNameControll, onTap: () {
              Navigator.pushNamed(context, RouteName.selectCompany)
                  .then((value) {
                //print('接收到的单位返回值：'+value.toString());
                if (value == null) return;
                var tempMap = jsonDecode(value.toString());
                _companyId = tempMap['custId'];
                _companyNameControll.text = tempMap['custName'];
              });
            }),
            simpleRecordInput(context,
                preText: '条码号',
                hintText: '请扫描或输入条码号',
                keyType: TextInputType.visiblePassword,
                onController: _barCodeControll,
                maxLength: 12,
                rightWidget: InkWell(
                    onTap: () {
                      var p = new BarcodeScanner(success: (String code) {
                        //print('条形码'+code);
                        if (code == '-1') return;
                        _barCodeControll.text = code;
                        _addSubmitItem(context);
                      });
                      p.scanBarcodeNormal();
                    },
                    child: radiusButton(text: '扫码', img: "scan.png")),
                onSubmitted: (v) {
              if (v.toString().isEmpty) return;
              _addSubmitItem(context);
            }),
          ],
        ));
  }

  //校验输入
  bool _checkLoginInput() {
    bool check = true;
    if (!isRequire(_companyNameControll.text)) {
      showMsgToast('请选择送检单位！');
      check = false;
      return null;
    }
    if (_submitData.length <= 0) {
      showMsgToast('请添加录单信息！');
      check = false;
      return null;
    }
    for (var i = 0, len = _submitData.length; i < len; i++) {
      var item = _submitData[i];
      // if(item['items'].length<=0){
      // 	showMsgToast('第 ${i+1} 条录单数据未选择项目！');
      // 	check=false;
      // 	break;
      // }
      if (item['imageItems'].length <= 0) {
        showMsgToast('第 ${i + 1} 条录单数据未上传图片！');
        check = false;
        break;
      }
    }
    return check;
  }

  submit(model) {
    setState(() {
      hasSubmit = true;
    });
    if (!_checkLoginInput()) return;
    String barCodeStrs = '';
    for (var x in _submitData) {
      barCodeStrs += (',' + x['apply']['barCode']);
    }
    model.judgeSpecimenCodeExistData(barCodeStrs.substring(1)).then((list) {
      if (list == null) return;
      _hasExistNum.clear();
      if (list.length > 0) {
        list.forEach((val) {
          _hasExistNum.add(val.toString());
        });
        setState(() {
          _hasExistNum = _hasExistNum;
        });
        showMsgToast('存在已经被使用的条码号，请先删除！');
      } else {
        model.recordSavaSubmitData(_submitData).then((val) {
          if (val) {
            Future.microtask(() {
              var yyDialog;
              yyDialog = yyNoticeDialog(text: '提交成功');
              Future.delayed(Duration(milliseconds: 1500), () {
                dialogDismiss(yyDialog);
                _submitData.clear();
                _barCodeControll.text = '';
                setState(() {
                  _submitData = _submitData;
                  hasSubmit = false;
                });
              });
            });
          }
        });
      }
    });
  }
}
