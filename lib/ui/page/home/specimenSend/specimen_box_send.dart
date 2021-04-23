import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/site_model.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/specimenSend/specimen_boxes.dart';
import 'package:huayin_logistics/ui/widget/bottomSheet.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, showMsgToast, simpleRecordInput;
import 'package:huayin_logistics/ui/widget/datePicker/flutter_cupertino_date_picker.dart';
import 'package:huayin_logistics/ui/widget/datePicker/src/date_picker.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/specimen_box_send_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class SpecimenBoxSend extends StatefulWidget {
  @override
  _SpecimenBoxSend createState() => _SpecimenBoxSend();
}

class _SpecimenBoxSend extends State<SpecimenBoxSend> {
  List _imageList = new List<FileUploadItem>();

  List<SiteModel> _sites = [];

  SiteModel _site;
  WayModelItem _line;
  TextEditingController _lineCon = TextEditingController();
  TextEditingController _arriveCon = TextEditingController();
  TextEditingController _arriveDateCon = TextEditingController();
  TextEditingController _sendCon = TextEditingController();
  TextEditingController _sendDateCon = TextEditingController();
  TextEditingController _sendLocationCon = TextEditingController();
  TextEditingController _licenseCon = TextEditingController();
  TextEditingController _transportNoCon = TextEditingController();
  List<SpecimenBoxItem> boxPicked;

  List<SpecimenBoxItem> boxList = [];
  WayModel _wayList;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  getData() async {
    var userInfo = Provider.of<MineModel>(context, listen: false).user?.user;
    String labId = '82858490362716212';
    String userId = userInfo.id;
    KumiPopupWindow pop = PopUtils.showLoading();
    try {
      boxList = await Repository.fetchSendBoxes(labId: labId, userId: userId);
      _sites = await Repository.fetchArriveSiteList(labId: labId);
      _wayList = await Repository.fetchSpecimenSendSelectWay(userId);
    } catch (e) {
      print("getSendBoxes err $e");
      showToast(e.toString());
      pop.dismiss(context);
      return null;
    }
    pop.dismiss(context);
    setState(() {});
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
            child: new Column(
              children: <Widget>[
                SpecimenBoxes(
                  list: boxList,
                  confirm: (items) {
                    boxPicked = items;
                  },
                ),
                pickLine(),
                _baseInfo(),
                UploadImgage(submit: (data) {
                  _imageList = data;
                  submit();
                }),
              ],
            )),
      ),
    );
  }

  Widget pickLine() {
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
            opacity: 0.5,
            animated: false,
            child: BottomSheetList(
              title: '路线选择',
              nameList: _wayList.list.map((l) => l.lineName).toList(),
              pickedName: _line?.lineName,
              confirm: (index) {
                _lineCon.text = _wayList.list[index].lineName;
                _line = _wayList.list[index];
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
                onController: _arriveCon, onTap: () {
              PopUtils.showPop(
                  opacity: 0.5,
                  animated: false,
                  child: BottomSheetList(
                    title: '选择站点',
                    nameList: _sites.map((s) => s.siteName).toList(),
                    pickedName: _site?.siteName,
                    confirm: (index) {
                      _arriveCon.text = _sites[index].siteName;
                      _site = _sites[index];
                    },
                  ));
            }),
            simpleRecordInput(context,
                preText: '预计到时',
                hintText: '(必填)请选择预计到达时间',
                enbleInput: false,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: _arriveDateCon, onTap: () {
              DatePicker.showDatePicker(context,
                  title: '选择到达时间',
                  locale: DateTimePickerLocale.zh_cn,
                  pickerMode: DateTimePickerMode.datetime,
                  dateFormat: 'MMdd HH:mm',
                  pickerTheme: DateTimePickerTheme(
                      itemTextStyle: TextStyle(
                          color: DiyColors.heavy_blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  onConfirm: (DateTime dateTime, List<int> days) async {
                _arriveDateCon.text =
                    DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd HH:mm');
              });
            }),
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
                onController: _sendDateCon, onTap: () {
              DatePicker.showDatePicker(context,
                  title: '选择出发时间',
                  locale: DateTimePickerLocale.zh_cn,
                  pickerMode: DateTimePickerMode.datetime,
                  dateFormat: 'MMdd HH:mm',
                  pickerTheme: DateTimePickerTheme(
                      itemTextStyle: TextStyle(
                          color: DiyColors.heavy_blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  onConfirm: (DateTime dateTime, List<int> days) async {
                _sendDateCon.text =
                    DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd HH:mm');
              });
            }),
            simpleRecordInput(context,
                preText: '车牌号',
                hintText: '(必填)请选择预计到达站点',
                onController: _licenseCon,
                onTap: () {}),
            simpleRecordInput(context,
                preText: '运单号',
                hintText: '(必填)请选择预计到达站点',
                onController: _transportNoCon,
                onTap: () {}),
          ],
        ));
  }

  //校验输入
  bool _checkLoginInput() {
    if (_line == null) {
      showMsgToast('请选择线路！');
      return false;
    }
    return true;
  }

  submit() async {
    if (!_checkLoginInput()) return;
    List<Map<String, String>> tempList = [];

    for (var x in _imageList) {
      Map<String, String> tempMap = {};
      // tempMap['name']=x.fileName;
      // tempMap['url']=x.innerUrl;
      tempMap['fileID'] = x.id;
      tempList.add(tempMap);
    }
    tempList = [
      {'fileID': '12321332423'}
    ];
    var userInfo = Provider.of<MineModel>(context, listen: false).user?.user;
    List boxInfo = boxPicked
        .map((e) => {'boxNo': e.boxNo, 'hasIce': e.ice, 'joinIds': e.joinIds})
        .toList();
    KumiPopupWindow pop = PopUtils.showLoading();

    try {
      await Repository.fetchSpecimenSendSubmit(data: {
        "boxInfoList": boxInfo,
        "carNumber": _licenseCon.text,
        "estimateArriveAt": _arriveDateCon.text + ':00.000',
        "estimateArriveSiteId": _site.id,
        "estimateArriveSiteName": _site.siteName,
        "lineId": _line.id,
        "lineName": _line.lineName,
        "imageIds": _imageList.map((e) => e.id).toList(),
        "sendSiteName": _sendCon.text,
        "senderAt": _sendDateCon.text + ':00.000',
        "senderId": userInfo.id,
        "senderName": userInfo.name,
        "transportNo": _transportNoCon.text
      }, labId: '123456789789');
    } catch (e) {
      showToast(e.toString());
      pop.dismiss(context);
      return;
    }
    pop.dismiss(context);
    Future.microtask(() {
      var yyDialog;
      yyDialog = yyNoticeDialog(text: '提交成功');
      Future.delayed(Duration(milliseconds: 1500), () {
        dialogDismiss(yyDialog);
        _imageList.clear();
        setState(() {
          _imageList = _imageList;
        });
      });
    });
  }
}
