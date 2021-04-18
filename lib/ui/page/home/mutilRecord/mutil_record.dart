import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/model/speciment_box_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/easyRecord/record_info.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/ui/widget/select_items.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/utils/events_utils.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/recrod_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import './mutil_upload.dart';
import './mutil_projects.dart';

class MutilRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MutilRecordPage(context: context);
  }
}

class MutilRecordPage extends StatefulWidget {
  BuildContext context;
  MutilRecordPage({this.context});

  @override
  _MutilRecordPageState createState() => _MutilRecordPageState();
}

class _MutilRecordPageState extends State<MutilRecordPage> {
  TextEditingController _barCodeControll = TextEditingController(); //条码号

  List<Map<String, dynamic>> _submitData = [];

  List<String> _hasExistNum = []; //已存在的条码号

  bool hasSubmit = false;

  int mulPicCount = 0;

  List<String> picId = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                    RecordInfo(
                      barCodeControll: _barCodeControll,
                      onBarcodeSubmit: (info) {
                        _addSubmitItem(context, info, model);
                      },
                    ),
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
                            picId = data.map((e) => e.id).toList();
                            _submitData.forEach((d) {
                              d['imageIds'] = picId;
                            });
                          } else {
                            picId = [];
                            _submitData.forEach((d) {
                              d['imageIds'] = [];
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
                      if (picId.length > 0 || _submitData.isEmpty) {
                        return;
                      }
                      Navigator.push(context,
                              MaterialPageRoute(builder: (_) => MutilUpload()))
                          .then((value) {
                        if (value != null) {
                          int idx = _submitData.indexWhere(
                              (d) => d['main']['barCode'] == value.first);
                          if (idx > -1) {
                            List<String> ids =
                                List<String>.from(value.last.map((e) => e.id));
                            _submitData[idx]['imageIds'] = ids;
                            mulPicCount = ids.length;
                            setState(() {});
                          }
                        }
                      });
                    },
                    child: AnimatedOpacity(
                        opacity: (picId.length == 0 && _submitData.isNotEmpty)
                            ? 1
                            : 0.3,
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
            _submitData.indexWhere((d) => d['main']['barCode'] == barCode);
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
        _submitData.indexWhere((e) => (e['main']['barCode'] == barCode));
    _submitData.removeAt(curIndex);
    setState(() {
      mulPicCount = _submitData
          .where((s) {
            List pics = s['imageIds'];
            return pics.isNotEmpty;
          })
          .toList()
          .length;
      _submitData = _submitData;
    });
  }

  Future _addSubmitItem(
      BuildContext context, Map info, RecrodModel model) async {
    KumiPopupWindow pop = PopUtils.showLoading();
    List<dynamic> response =
        await Repository.fetchJudgeSpecimenCodeExist(info['barCode']);
    pop.dismiss(context);
    if (response != null && response.contains(info['barCode'])) {
      showMsgToast('该条码已被使用过，请重新输入！', context: context);
      return;
    }
    if (info['barCode'].length != 12) {
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
        .indexWhere((e) => (e['main']['barCode'] == info['barCode']));
    if (curIndex >= 0) {
      showMsgToast('列表已存在该条码，请重新输入！', context: context);
      return;
    }

    Map<String, dynamic> tempObj = {
      "main": info,
      "imageIds": picId,
      "items": []
    };
    _submitData.insert(0, tempObj);

    setState(() {
      _submitData = _submitData;
    });
  }

  //校验输入
  bool _checkLoginInput() {
    bool check = true;

    if (_submitData.length <= 0) {
      showMsgToast('请添加录单信息！');
      check = false;
      return null;
    }

    if (!isRequire(_submitData.first['main']['inspectionUnitName'])) {
      showMsgToast('请选择送检单位！');
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
      if (item['imageIds'].length <= 0) {
        showMsgToast('第 ${i + 1} 条录单数据未上传图片！');
        check = false;
        break;
      }
    }
    return check;
  }

  submit(RecrodModel model) {
    setState(() {
      hasSubmit = true;
    });
    if (!_checkLoginInput()) return;
    String barCodeStrs = '';
    for (var x in _submitData) {
      barCodeStrs += (',' + x['main']['barCode']);
    }

    String labId = '82858490362716212';
    model.recordSavaSubmitData(_submitData, labId).then((val) {
      if (val) {
        Future.microtask(() {
          var yyDialog;
          yyDialog = yyNoticeDialog(text: '提交成功');
          Future.delayed(Duration(milliseconds: 1500), () {
            dialogDismiss(yyDialog);
            _submitData.clear();
            _barCodeControll.text = '';
            GlobalEvents().clearImages.add(null);
            setState(() {
              picId.length = 0;
              mulPicCount = 0;
              _submitData = _submitData;
              hasSubmit = false;
            });
          });
        });
      }
    });

    // model.judgeSpecimenCodeExistData(barCodeStrs.substring(1)).then((list) {
    //   if (list == null) return;
    //   _hasExistNum.clear();
    //   if (list.length > 0) {
    //     list.forEach((val) {
    //       _hasExistNum.add(val.toString());
    //     });
    //     setState(() {
    //       _hasExistNum = _hasExistNum;
    //     });
    //     showMsgToast('存在已经被使用的条码号，请先删除！');
    //   } else {
    //     String labId = '82858490362716212';
    //     model.recordSavaSubmitData(_submitData, labId).then((val) {
    //       if (val) {
    //         Future.microtask(() {
    //           var yyDialog;
    //           yyDialog = yyNoticeDialog(text: '提交成功');
    //           Future.delayed(Duration(milliseconds: 1500), () {
    //             dialogDismiss(yyDialog);
    //             _submitData.clear();
    //             _barCodeControll.text = '';
    //             mulPicCount = 0;
    //             picId.length = 0;
    //             setState(() {
    //               _submitData = _submitData;
    //               hasSubmit = false;
    //             });
    //           });
    //         });
    //       }
    //     });
    //   }
    // });
  }
}
