import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/easyRecord/record_info.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/utils/events_utils.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/recrod_model.dart';
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

  FocusNode _barNode = FocusNode();
  FocusNode _boxNode = FocusNode();

  bool hasSubmit = false;

  int mulPicCount = 0;

  List<String> picId = [];

  Map<String, List<SelectProjectItem>> projectsMap = {};
  List<SelectProjectItem> multiProjects = [];
  bool _useDeviceScan = true;

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
        if (_boxNode.hasFocus) {
          EventBus.instance
              .commit(EventKeys.updateBoxDetail, {"updateBoxDetail": true});
        }
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: appBarWithName(context, '批量录单', '外勤:', withName: true),
          body: ProviderWidget<RecrodModel>(
              model: RecrodModel(context),
              builder: (cContext, model, child) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(100)),
                  child: Column(
                    children: <Widget>[
                      RecordInfo(
                        boxNode: _boxNode,
                        barNode: _barNode,
                        barCodeControll: _barCodeControll,
                        clearData: clearData,
                        onScan: (value) {
                          _useDeviceScan = value;
                        },
                        onBarcodeSubmit: (info, add) async {
                          if (add) {
                            await _addSubmitItem(context, info, model);
                          } else {
                            _submitData.forEach((e) {
                              e['main']['inspectionUnitName'] =
                                  info['inspectionUnitName'];
                              e['main']['inspectionUnitId'] =
                                  info['inspectionUnitId'];
                              e['main']['boxNo'] = info['boxNo'];
                              e['main']['boxId'] = info['boxId'];
                              e['main']['joinId'] = info['joinId'];
                            });
                          }
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
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {});
                          },
                          submit: (data) {
                            submit(model);
                          })
                    ],
                  ),
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
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: '已录数据',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(40),
                          color: DiyColors.normal_black,
                        )),
                    TextSpan(
                        text: " *",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(46),
                            color: Color.fromRGBO(234, 44, 67, 1))),
                  ])),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MutilUpload(
                                    barCodes: List<String>.from(_submitData
                                        .map((e) => e['main']['barCode'])),
                                    addImgs: (value) {
                                      if (value != null) {
                                        int idx = _submitData.indexWhere((d) =>
                                            d['main']['barCode'] ==
                                            value.first);
                                        if (idx > -1) {
                                          List<String> ids = List<String>.from(
                                              value.last.map((e) => e.id));
                                          _submitData[idx]['imageIds'] = ids;
                                          mulPicCount = ids.length;
                                          setState(() {});
                                        }
                                      }
                                    },
                                  ))).then((value) {});
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
    Navigator.pushNamed(context, RouteName.selectProject, arguments: {
      'hasSelectItem': barCode == null ? multiProjects : projectsMap[barCode]
    }).then((value) {
      if (value == null) {
        return;
      }
      List<Map<String, dynamic>> _projectItemArray = [];
      List<SelectProjectItem> _selectedItems = value;
      List<SelectProjectItem> _selectedItemsSingle =
          _selectedItems.where((s) => s.type != 3).toList();
      List<SelectProjectItem> _selectedItemsMulti =
          _selectedItems.where((s) => s.type == 3).toList();
      List<Map<String, dynamic>> _itemsMutil = [];
      _projectItemArray =
          _selectedItemsSingle.map((e) => e.toItemJson()).toList();
      _selectedItemsMulti.forEach((m) {
        m.detailList.forEach((d) {
          Map<String, dynamic> _json = d.toItemJson();
          _json['barCode'] = m.barCode;
          _json["packageId"] = m.id;
          _json["packageIndex"] = m.detailList.indexOf(d);
          _itemsMutil.add(_json);
        });
      });
      _projectItemArray.addAll(_itemsMutil);
      if (barCode == null) {
        _submitData.forEach((d) {
          d['items'] = _projectItemArray;
          projectsMap[d['main']['barCode']] = value;
        });
        multiProjects = value;
      } else {
        projectsMap[barCode] = value ?? [];
        int idx =
            _submitData.indexWhere((d) => d['main']['barCode'] == barCode);
        if (idx > -1) {
          _submitData[idx]['items'] = _projectItemArray;
        }
      }
      setState(() {});
    });
  }

  void _removeSubmitItem(String barCode) {
    projectsMap[barCode] = [];
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
      multiProjects = _submitData.isEmpty ? [] : multiProjects;
    });
  }

  Future _addSubmitItem(
      BuildContext context, Map info, RecrodModel model) async {
    PopUtils.showLoading();
    List<dynamic> response;
    try {
      response = await Repository.fetchJudgeSpecimenCodeExist(info['barCode']);
    } catch (e, s) {
      PopUtils.dismiss();
      PopUtils.showError(e, s);
      return;
    }
    PopUtils.dismiss();
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

    PopUtils.toast('添加成功');
    _barCodeControll.clear();
    if (_useDeviceScan) {
      FocusScope.of(context).requestFocus(_barNode);
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
    if (!isRequire(_submitData.first['main']['boxNo'])) {
      showMsgToast('请输入标本箱号！');
      check = false;
      return null;
    }
    if (!isRequire(_submitData.first['main']['inspectionUnitName'])) {
      showMsgToast('请选择送检单位！');
      check = false;
      return null;
    }
    if (_submitData.length <= 0) {
      showMsgToast('请添加录单信息！');
      check = false;
      return null;
    }
    List<int> unSelectProjects = [];
    List<int> unAddImgs = [];
    for (var i = 0, len = _submitData.length; i < len; i++) {
      var item = _submitData[i];
      if (item['items'].length <= 0) {
        unSelectProjects.add(_submitData.length - i);
        check = false;
      }
      if (item['imageIds'].length <= 0) {
        unAddImgs.add(_submitData.length - i);
        check = false;
      }
    }
    if (unSelectProjects.isNotEmpty) {
      showMsgToast('第 ${unSelectProjects.join(',')} 条录单数据未选择项目！');
    } else if (unAddImgs.isNotEmpty) {
      showMsgToast('第 ${unAddImgs.join(',')} 条录单数据未上传图片！');
    }
    return check;
  }

  submit(RecrodModel model) {
    setState(() {
      hasSubmit = true;
    });
    if (!_checkLoginInput()) return;
    model.recordSavaSubmitData(_submitData).then((val) {
      if (val) {
        EventBus.instance
            .commit(EventKeys.updateBoxDetail, {"updateBoxDetail": false});
        Future.microtask(() async {
          var yyDialog;
          yyDialog = yyNoticeDialog(text: '提交成功', context: context);
          await Future.delayed(Duration(milliseconds: 1500));
          dialogDismiss(yyDialog);
          clearData();
          await Future.delayed(Duration(milliseconds: 300));
          FocusScope.of(context).requestFocus(_barNode);
        });
      }
    });
  }

  clearData() {
    _submitData.clear();
    _barCodeControll.text = '';
    EventBus.instance.commit(EventKeys.clearImages, {});
    setState(() {
      picId.length = 0;
      mulPicCount = 0;
      _submitData = _submitData;
      multiProjects = [];
      projectsMap = {};
      hasSubmit = false;
    });
  }
}
