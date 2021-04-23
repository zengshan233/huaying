import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:huayin_logistics/view_model/home/recrod_model.dart';

import 'record_info.dart';
import 'apply_project.dart';

class EasyRecord extends StatefulWidget {
  @override
  _EasyRecord createState() => _EasyRecord();
}

class _EasyRecord extends State<EasyRecord> {
  List<Map<String, String>> _projectItemArray = [];

  List<SelectItemRightListItem> _hasSelectItem = []; //已选择的项目

  TextEditingController _barCodeControll = TextEditingController(); //条码号

  TextEditingController _recordNameControll = TextEditingController(); //姓名

  Map<String, dynamic> submitData = {};

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
                        updateInfo: (info) {
                          submitData['main'] = info;
                        },
                      ),
                      ApplyProject(
                        updateProject: (items) {
                          _projectItemArray = items;
                        },
                      ),
                      UploadImgage(
                        submit: (data) async {
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
    if (!isRequire(submitData['main']['inspectionUnitName'])) {
      showMsgToast('请选择送检单位！');
      return false;
    }
    if (!isRequire(submitData['main']['barCode'])) {
      showMsgToast('条码号必填项，请维护！');
      return false;
    }
    if (submitData['main']['barCode'].length != 12) {
      showMsgToast('条码号长度必须为12位！', context: context);
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

  submit(RecrodModel model, List<FileUploadItem> _imageList) {
    if (!_checkLoginInput(_imageList)) return;
    String labId = '82858490362716212';
    submitData['imageIds'] = _imageList.map((e) => e.id).toList();
    submitData['items'] = _projectItemArray;
    print('submitData $submitData');
    List<Map<String, dynamic>> list = [submitData];
    model.recordSavaSubmitData(list, labId).then((val) {
      if (val) {
        Future.microtask(() {
          var yyDialog;
          yyDialog = yyNoticeDialog(text: '提交成功');
          Future.delayed(Duration(milliseconds: 1500), () {
            dialogDismiss(yyDialog);
            _barCodeControll.text = '';
            _recordNameControll.text = '';
            _projectItemArray.clear();
            _hasSelectItem.clear();
            _imageList.clear();
            setState(() {
              _projectItemArray = _projectItemArray;
              _imageList = _imageList;
            });
          });
        });
      }
    });
  }
}
