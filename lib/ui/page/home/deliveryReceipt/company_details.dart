import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/datePicker/src/date_picker.dart';
import 'package:huayin_logistics/ui/widget/datePicker/src/i18n/date_picker_i18n.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/ui/widget/switch.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

class CompanyDetails extends StatefulWidget {
  Items item;
  DeliveryDetailModel detail;
  Function() updateStatus;
  CompanyDetails({this.item, this.detail, this.updateStatus});

  @override
  _CompanyDetails createState() => _CompanyDetails();
}

class _CompanyDetails extends State<CompanyDetails> {
  TextEditingController barCodeCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  TextEditingController temperatureCon = TextEditingController();
  TextEditingController bloodCon = TextEditingController();
  TextEditingController iceCon = TextEditingController();
  TextEditingController sliceNormalCon = TextEditingController();
  TextEditingController microCon = TextEditingController();
  TextEditingController othersCon = TextEditingController();
  TextEditingController sampleCountCon = TextEditingController();
  TextEditingController applyCon = TextEditingController();
  TextEditingController tctCon = TextEditingController();
  TextEditingController sliceCon = TextEditingController();

  bool showDetail = false;

  @override
  void initState() {
    super.initState();
    initValue();
  }

  initValue() {
    barCodeCon.text = widget.item.barcodeTotal.toString();
    dateCon.text = widget.item.temperatures?.first?.recordAt;
    temperatureCon.text =
        widget.item.temperatures?.first?.temperature?.toString() ?? '';
    bloodCon.text = widget.item.routineSecretion;
    iceCon.text = widget.item.routineIce;
    sliceNormalCon.text = widget.item.routineSmear;
    microCon.text = widget.item.routineMic;
    othersCon.text = widget.item.routineOther;
    sampleCountCon.text = widget.item.pathologyTissueSample;
    applyCon.text = widget.item.pathologyTissueOrder;
    tctCon.text = widget.item.pathologyTissueTct;
    sliceCon.text = widget.item.pathologySmear;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(50)),
      padding: EdgeInsets.only(
          left: ScreenUtil().setHeight(50), right: ScreenUtil().setHeight(30)),
      child: Column(
        children: <Widget>[
          buildHead(context),
          showDetail
              ? Column(
                  children: <Widget>[
                    simpleRecordInput(context,
                        preText: '条码总数',
                        maxLength: 50,
                        onController: barCodeCon,
                        enbleInput: widget.item.status != 1,
                        needBorder: true),
                    simpleRecordInput(context,
                        preText: '时间',
                        hintText: '请选择时间',
                        enbleInput: false,
                        onController: dateCon,
                        rightWidget: new Image.asset(
                          ImageHelper.wrapAssets('mine_rarrow.png'),
                          width: ScreenUtil().setHeight(40),
                          height: ScreenUtil().setHeight(40),
                        ), onTap: () {
                      DatePicker.showDatePicker(context,
                          locale: DateTimePickerLocale.zh_cn,
                          pickerMode: DateTimePickerMode.datetime,
                          onConfirm: (DateTime dateTime, List<int> days) async {
                        dateCon.text = dateTime.toString().split('.').first;
                      });
                    }),
                    simpleRecordInput(
                      context,
                      preText: '温度(℃)',
                      hintText: '(必填)请输入温度',
                      onController: temperatureCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    buildTab('常规'),
                    simpleRecordInput(
                      context,
                      preText: '血/分泌物',
                      hintText: '请输入血/分泌物',
                      onController: bloodCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '冰敷',
                      hintText: '请输入冰敷',
                      onController: iceCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '涂片',
                      hintText: '请输入涂片',
                      onController: sliceNormalCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '微生物',
                      hintText: '请输入微生物',
                      onController: microCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '其他',
                      hintText: '请输入其他',
                      onController: othersCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    buildTab('病理'),
                    simpleRecordInput(
                      context,
                      preText: '组织标本数',
                      hintText: '请输入组织标本数',
                      onController: sampleCountCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '组织申请单',
                      hintText: '请输入组织申请单',
                      onController: applyCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    simpleRecordInput(
                      context,
                      preText: 'TCT',
                      hintText: '请输入TCT',
                      onController: tctCon,
                      enbleInput: widget.item.status != 1,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '涂片',
                      hintText: '请输入涂片',
                      onController: sliceCon,
                      enbleInput: widget.item.status != 1,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget buildHead(context) {
    return Container(
      width: ScreenUtil.screenWidth,
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xFFf0f0f0)))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showDetail = !showDetail;
            });
          },
          child: Container(
              child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setHeight(30)),
                color: DiyColors.heavy_blue,
                width: ScreenUtil().setWidth(4),
                height: ScreenUtil().setWidth(50),
              ),
              Container(
                constraints:
                    BoxConstraints(maxWidth: ScreenUtil().setWidth(700)),
                child: Text(
                  widget.item.inspectionUnitName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(40)),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(60),
                    bottom: ScreenUtil().setWidth(showDetail ? 15 : 0),
                    top: ScreenUtil().setWidth(showDetail ? 0 : 20)),
                child: Transform.rotate(
                  angle: (showDetail ? 1 : -1) * pi / 2,
                  child: Image.asset(
                    ImageHelper.wrapAssets('right_more.png'),
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setWidth(60),
                  ),
                ),
              )
            ],
          )),
        ),
        Container(
          child: SwitchButton(
            width: ScreenUtil().setWidth(185),
            height: ScreenUtil().setWidth(70),
            valueFontSize: ScreenUtil().setSp(26),
            toggleWidth: ScreenUtil().setWidth(70),
            toggleHeight: ScreenUtil().setWidth(56),
            toggleRadius: 3,
            value: widget.item.status == 1,
            borderRadius: 4,
            padding: widget.item.status != 1
                ? EdgeInsets.only(left: ScreenUtil().setWidth(8))
                : EdgeInsets.only(right: ScreenUtil().setWidth(8)),
            showOnOff: true,
            inactiveText: '未确认',
            activeText: '已确认',
            onToggle: (val) {
              submit();
            },
          ),
        )
      ]),
    );
  }

  Widget buildTab(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Color(0xFFf0f0f0)))),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(40)),
      ),
    );
  }

  changeT() {
    String labId = '82858490362716212';
    Repository.fetchChangeDeliveryTemperature(
        labId: labId,
        id: widget.item.id,
        data: {
          "createAt": widget.item.createAt,
          "updateAt": widget.item.updateAt,
          "dcId": widget.item.dcId,
          "id": widget.item.id,
          "joinItemId": widget.item.joinId,
          "orgId": widget.item.orgId,
          "temperature": '35',
        });
  }

  submit() async {
    // if (!_checkLoginInput(_imageList)) return;
    String labId = '82858490362716212';
    DateTime now = DateTime.now();
    KumiPopupWindow pop = PopUtils.showLoading();
    DeliveryDetailModel detailResponse;
    try {
      detailResponse = await Repository.fetchAddDelivery(
          labId: labId,
          id: widget.item.id,
          data: {
            "dcId": widget.item.dcId,
            "id": widget.item.id,
            "barcodeTotal": widget.item.barcodeTotal.toString(),
            "inspectionUnitId": widget.item.inspectionUnitId,
            "inspectionUnitName": widget.item.inspectionUnitName,
            "joinId": widget.item.joinId,
            "pathologyLiquidSpecimen": "",
            "pathologyOther": "",
            "pathologyQfc": "",
            "pathologySlideGlassConsultation": "",
            "pathologySlideGlassCooperate": "",
            "pathologySmear": sliceCon.text,
            "pathologyTissueOrder": applyCon.text,
            "pathologyTissueSample": sampleCountCon.text,
            "pathologyTissueTct": tctCon.text,
            "pathologyWaxBlockConsultation": "",
            "pathologyWaxBlockCooperate": "",
            "routineIce": iceCon.text,
            "routineMic": microCon.text,
            "routineOther": othersCon.text,
            "routineSecretion": bloodCon.text,
            "routineSmear": sliceNormalCon.text,
            "temperatureList": [
              {
                "createAt": widget.item.createAt,
                "updateAt": now.toString(),
                "dcId": widget.item.dcId,
                "id": widget.item.id,
                "joinItemId": widget.item.joinId,
                "orgId": widget.item.orgId,
                "temperature": temperatureCon.text,
              }
            ],
            "createAt": widget.item.createAt,
            "updateAt": now.toString(),
            "stas": widget.item.status,
          });
      await Repository.fetchConfirmDelivery(widget.detail.id);
    } catch (e) {
      print('submit error $e');
      showToast(e.toString());
      pop.dismiss(context);
      return;
    }
    await widget.updateStatus?.call();
    pop.dismiss(context, onFinish: (_p) {
      var yyDialog;
      yyDialog = yyNoticeDialog(text: '确认成功');
      Future.delayed(Duration(milliseconds: 1500), () {
        dialogDismiss(yyDialog);
      });
    });
  }
}
