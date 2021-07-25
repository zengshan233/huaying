import 'package:aesCipher/aesCipher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/storage_manager.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, showMsgToast;
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/utils/events_utils.dart';
import 'package:huayin_logistics/view_model/home/recrod_model.dart';

import 'record_info.dart';
import 'apply_project.dart';

class EasyRecord extends StatefulWidget {
  @override
  _EasyRecord createState() => _EasyRecord();
}

class _EasyRecord extends State<EasyRecord> {
  List<SelectProjectItem> _selectedItems = []; //已选择的项目

  TextEditingController _barCodeControll = TextEditingController(); //条码号

  TextEditingController _recordNameControll = TextEditingController(); //姓名

  Map<String, dynamic> submitData = {};
  FocusNode _barNode = FocusNode();
  FocusNode _boxNode = FocusNode();

  @override
  void initState() {
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
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '简易录单', '外勤:', withName: true),
        body: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ProviderWidget<RecrodModel>(
                model: RecrodModel(context),
                builder: (cContext, model, child) {
                  return Column(
                    children: <Widget>[
                      RecordInfo(
                        barCodeControll: _barCodeControll,
                        recordNameControll: _recordNameControll,
                        barNode: _barNode,
                        boxNode: _boxNode,
                        updateInfo: (info) {
                          submitData['main'] = info;
                        },
                      ),
                      ApplyProject(
                        updateProject: (items) {
                          _selectedItems = items;
                        },
                      ),
                      UploadImgage(
                        updateImages: (list) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        submit: (data) async {
                          if (_boxNode.hasFocus) {
                            _boxNode.unfocus();
                            EventBus.instance.commit(EventKeys.updateBoxDetail,
                                {"updateBoxDetail": true});
                            return;
                          }
                          submit(model, data);
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                    ],
                  );
                })),
      ),
    );
  }

  //校验输入
  bool _checkLoginInput(List<FileUploadItem> _imageList) {
    if (submitData.keys.isEmpty) {
      showMsgToast('请输入标本箱号！');
      return false;
    }
    if (!isRequire(submitData['main']['boxNo'])) {
      showMsgToast('请输入标本箱号！');
      return false;
    }
    if (!isRequire(submitData['main']['inspectionUnitName'])) {
      showMsgToast('请选择送检单位！');
      return false;
    }
    if (!isRequire(submitData['main']['barCode'])) {
      showMsgToast('请输入条码编号！');
      return false;
    }
    if (submitData['main']['barCode'].length != 12) {
      showMsgToast('条码号长度必须为12位！', context: context);
      return false;
    }
    if (_selectedItems.isEmpty) {
      showMsgToast('请添加申请项目!', context: context);
      return false;
    }
    // if(_barCodeControll.text.substring(10,12)!='00'){
    // 	showMsgToast(
    // 		'条码号必须以00结尾！',
    // 		context: context
    // 	);
    // 	return false;
    // }
    if (_imageList.length <= 0) {
      showMsgToast('请上传照片！');
      return false;
    }
    return true;
  }

  submit(RecrodModel model, List<FileUploadItem> _imageList) async {
    if (!_checkLoginInput(_imageList)) return;
    submitData['imageIds'] = _imageList.map((e) => e.id).toList();
    List<SelectProjectItem> _selectedItemsSingle =
        _selectedItems.where((s) => s.type != 3).toList();
    List<SelectProjectItem> _selectedItemsMulti =
        _selectedItems.where((s) => s.type == 3).toList();
    List<Map<String, dynamic>> _itemsMutil = [];
    submitData['items'] =
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
    submitData['items'].addAll(_itemsMutil);
    print(' submitData ${submitData['items']}');
    List<Map<String, dynamic>> list = [submitData];
    model.recordSavaSubmitData(list).then((val) {
      if (val) {
        EventBus.instance
            .commit(EventKeys.updateBoxDetail, {"updateBoxDetail": false});
        EventBus.instance.commit(EventKeys.clearProjects, {});
        Future.microtask(() async {
          var yyDialog;
          yyDialog = yyNoticeDialog(text: '提交成功');
          await Future.delayed(Duration(milliseconds: 1500));
          dialogDismiss(yyDialog);
          _barCodeControll.text = '';
          _recordNameControll.text = '';
          submitData['main']['barCode'] = '';
          _selectedItems.clear();
          _imageList.clear();
          setState(() {
            _imageList = _imageList;
          });
          await Future.delayed(Duration(milliseconds: 300));
          FocusScope.of(context).requestFocus(_barNode);
        });
      }
    });
  }
}
