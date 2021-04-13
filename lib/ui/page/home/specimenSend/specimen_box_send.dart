import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/page/home/specimenSend/specimen_boxes.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, showMsgToast, simpleRecordInput;
import 'package:huayin_logistics/ui/widget/dialog/custom_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/specimen_box_send_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

import '../../../widget/select_items.dart';

class SpecimenBoxSend extends StatefulWidget {
  @override
  _SpecimenBoxSend createState() => _SpecimenBoxSend();
}

class _SpecimenBoxSend extends State<SpecimenBoxSend> {
  List _imageList = new List<FileUploadItem>();

  String _logisticsLine = '';

  TextEditingController _lineCon = TextEditingController();
  TextEditingController _arriveCon = TextEditingController();
  TextEditingController _arriveDateCon = TextEditingController();
  TextEditingController _sendCon = TextEditingController();
  TextEditingController _sendDateCon = TextEditingController();
  TextEditingController _sendLocationCon = TextEditingController();
  TextEditingController _licenseCon = TextEditingController();
  TextEditingController _billCon = TextEditingController();

  WayModel _wayList;

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
        appBar: appBarWithName(context, '标本箱发出', '外勤:', withName: true),
        body: new SingleChildScrollView(
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(60)),
            child: ProviderWidget<SpecimenBoxSendModel>(
                model: SpecimenBoxSendModel(context),
                onModelReady: (model) {
                  var userInfo =
                      Provider.of<MineModel>(context, listen: false).user?.user;
                  model.specimenSendSelectWayData(userInfo.id).then((res) {
                    if (res != null) {
                      setState(() {
                        _wayList = res;
                      });
                    }
                  });
                },
                builder: (cContext, model, child) {
                  return new Column(
                    children: <Widget>[
                      SpecimenBoxes(),
                      pickLine(),
                      _baseInfo(),
                      UploadImgage(submit: (data) {
                        _imageList = data;
                        submit(model);
                      }),
                    ],
                  );
                })),
      ),
    );
  }

  Widget pickLine() {
    var tempYYDialog;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(40)),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
      child: simpleRecordInput(context,
          preText: '路线',
          hintText: '(必填)请选择路线',
          enbleInput: false,
          rightWidget: new Image.asset(
            ImageHelper.wrapAssets('mine_rarrow.png'),
            width: ScreenUtil().setHeight(40),
            height: ScreenUtil().setHeight(40),
          ),
          onController: _lineCon, onTap: () {
        PopUtils.showPop(
            context: context,
            opacity: 0.5,
            child: SelectItems(
              title: '路线选择',
              nameList: _wayList.list.map((l) => l.lineName).toList(),
              pickedName: _logisticsLine,
              confirm: (index) {
                _lineCon.text = _wayList.list[index].lineName;
                _logisticsLine = _wayList.list[index].lineName;
              },
            ));
      }),
    );
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
                preText: '预计到站',
                hintText: '(必填)请选择预计到达站点',
                enbleInput: false,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: _arriveCon,
                onTap: () {}),
            simpleRecordInput(context,
                preText: '预计到时',
                hintText: '(必填)请选择预计到达时间',
                enbleInput: false,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: _arriveDateCon,
                onTap: () {}),
            simpleRecordInput(context,
                preText: '发出站点',
                hintText: '(必填)请输入出发站点',
                onController: _sendCon,
                onTap: () {}),
            simpleRecordInput(context,
                preText: '发出时间',
                hintText: '(必填)请选择出发时间',
                enbleInput: false,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: _sendDateCon,
                onTap: () {}),
            simpleRecordInput(context,
                preText: '车牌号',
                hintText: '(必填)请选择预计到达站点',
                onController: _licenseCon,
                onTap: () {}),
            simpleRecordInput(context,
                preText: '运单号',
                hintText: '(必填)请选择预计到达站点',
                onController: _billCon,
                onTap: () {}),
          ],
        ));
  }

  //校验输入
  bool _checkLoginInput() {
    if (_logisticsLine.isEmpty) {
      showMsgToast('请选择线路！');
      return false;
    }
    return true;
  }

  submit(model) {
    if (!_checkLoginInput()) return;
    List<Map<String, String>> tempList = [];

    for (var x in _imageList) {
      Map<String, String> tempMap = {};
      // tempMap['name']=x.fileName;
      // tempMap['url']=x.innerUrl;
      tempMap['fileID'] = x.id;
      tempList.add(tempMap);
    }
    var userInfo = Provider.of<MineModel>(context, listen: false).user?.user;
    model
        .specimenSendSubmitData('0123123124', '2', tempList, _logisticsLine,
            userInfo.name, userInfo.id)
        .then((val) {
      if (val) {
        Future.microtask(() {
          var yyDialog;
          yyDialog = yyNoticeDialog(text: '提交成功');
          Future.delayed(Duration(milliseconds: 1500), () {
            dialogDismiss(yyDialog);
            _logisticsLine = '';
            _imageList.clear();
            setState(() {
              _imageList = _imageList;
            });
          });
        });
      }
    });
  }
}
