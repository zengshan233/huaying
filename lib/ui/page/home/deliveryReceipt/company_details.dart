import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/datePicker/src/date_picker.dart';
import 'package:huayin_logistics/ui/widget/datePicker/src/date_picker_theme.dart';
import 'package:huayin_logistics/ui/widget/datePicker/src/i18n/date_picker_i18n.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/ui/widget/switch.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class CompanyDetails extends StatefulWidget {
  final Items item;
  final DeliveryDetailModel detail;
  final Function() updateStatus;
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
  TextEditingController fluidSampleCon = TextEditingController();
  TextEditingController slideConsultationCon = TextEditingController();
  TextEditingController slideJointlyCon = TextEditingController();
  TextEditingController waxConsultationCon = TextEditingController();
  TextEditingController waxJointlyCon = TextEditingController();
  TextEditingController qfcCon = TextEditingController();
  TextEditingController pathologyOtherCon = TextEditingController();

  bool showDetail = false;

  @override
  void initState() {
    super.initState();
    initValue();
  }

  initValue() {
    barCodeCon.text = widget.item.barcodeTotal.toString();
    dateCon.text = widget.item.createAt?.substring?.call(0, 16) ?? '';
    if (widget.item.temperature != null) {
      temperatureCon.text =
          double.parse(widget.item.temperature).toStringAsFixed(1);
    }
    bloodCon.text = widget.item.routineSecretion ?? '';
    iceCon.text = widget.item.routineIce ?? '';
    sliceNormalCon.text = widget.item.routineSmear ?? '';
    microCon.text = widget.item.routineMic ?? '';
    othersCon.text = widget.item.routineOther ?? '';
    sampleCountCon.text = widget.item.pathologyTissueSample ?? '';
    applyCon.text = widget.item.pathologyTissueOrder ?? '';
    tctCon.text = widget.item.pathologyTissueTct ?? '';
    sliceCon.text = widget.item.pathologySmear ?? '';
    fluidSampleCon.text = widget.item.pathologyLiquidSpecimen ?? '';
    slideConsultationCon.text =
        widget.item.pathologySlideGlassConsultation ?? '';
    slideJointlyCon.text = widget.item.pathologySlideGlassCooperate ?? '';
    waxConsultationCon.text = widget.item.pathologyWaxBlockConsultation ?? '';
    waxJointlyCon.text = widget.item.pathologyWaxBlockCooperate ?? '';
    qfcCon.text = widget.item.pathologyQfc ?? '';
    pathologyOtherCon.text = widget.item.pathologyOther ?? '';
  }

  @override
  Widget build(BuildContext context) {
    bool signed = widget.detail.signForStatus == 1;
    bool confirmed = widget.item.status == 1;
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
                        preText: '????????????',
                        maxLength: 50,
                        onController: barCodeCon,
                        enbleInput: !confirmed && !signed,
                        keyType: TextInputType.number,
                        needBorder: true),
                    simpleRecordInput(context,
                        preText: '??????',
                        hintText: '???????????????',
                        enbleInput: false,
                        onController: dateCon,
                        rightWidget: new Image.asset(
                          ImageHelper.wrapAssets('mine_rarrow.png'),
                          width: ScreenUtil().setHeight(40),
                          height: ScreenUtil().setHeight(40),
                        ), onTap: () {
                      if (widget.item.status == 1) {
                        return;
                      }
                      DatePicker.showDatePicker(context,
                          title: '????????????',
                          locale: DateTimePickerLocale.zh_cn,
                          pickerMode: DateTimePickerMode.datetime,
                          dateFormat: 'MMdd HH:mm',
                          pickerTheme: DateTimePickerTheme(
                              itemTextStyle: TextStyle(
                                  color: DiyColors.heavy_blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          onConfirm: (DateTime dateTime, List<int> days) async {
                        dateCon.text = DateUtil.formatDate(dateTime,
                            format: 'yyyy-MM-dd HH:mm');
                      });
                    }),
                    simpleRecordInput(
                      context,
                      preText: '??????(???)',
                      hintText: '(??????)???????????????',
                      maxLength: 4,
                      isRquire: true,
                      onController: temperatureCon,
                      keyType: TextInputType.number,
                      enbleInput: !confirmed && !signed,
                    ),
                    buildTab('??????'),
                    simpleRecordInput(
                      context,
                      preText: '???/?????????',
                      hintText: '????????????/?????????',
                      onController: bloodCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '??????',
                      hintText: '???????????????',
                      onController: iceCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '??????',
                      hintText: '???????????????',
                      onController: sliceNormalCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '?????????',
                      hintText: '??????????????????',
                      onController: microCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '??????',
                      hintText: '???????????????',
                      onController: othersCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    buildTab('??????'),
                    simpleRecordInput(
                      context,
                      preText: '???????????????',
                      hintText: '????????????????????????',
                      onController: sampleCountCon,
                      keyType: TextInputType.number,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '???????????????',
                      hintText: '????????????????????????',
                      onController: applyCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: 'TCT',
                      hintText: '?????????TCT',
                      onController: tctCon,
                      width: ScreenUtil().setWidth(120),
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '??????',
                      hintText: '???????????????',
                      onController: sliceCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '????????????',
                      hintText: '?????????????????????',
                      onController: fluidSampleCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '????????????',
                      hintText: '?????????????????????',
                      onController: slideConsultationCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '????????????',
                      hintText: '?????????????????????',
                      onController: slideJointlyCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '????????????',
                      hintText: '?????????????????????',
                      onController: waxConsultationCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '????????????',
                      hintText: '?????????????????????',
                      onController: waxJointlyCon,
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: 'QFC',
                      hintText: '?????????QFC',
                      onController: qfcCon,
                      width: ScreenUtil().setWidth(120),
                      enbleInput: !confirmed && !signed,
                    ),
                    simpleRecordInput(
                      context,
                      preText: '??????',
                      hintText: '???????????????',
                      onController: pathologyOtherCon,
                      enbleInput: !confirmed && !signed,
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
          onTap: () async {
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
            inactiveText: '?????????',
            activeText: '?????????',
            onToggle: (val) {
              if (widget.detail.signForStatus != 1) {
                submit(confirm: widget.item.status != 1);
              }
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

  bool checkData() {
    String temperature = temperatureCon.text;
    int dotIdx = temperature.indexOf('.');
    int dotCount = 0;
    temperature.split('').forEach((t) {
      if (t == '.') {
        dotCount += 1;
      }
    });
    bool flag = dotIdx == 0 || dotIdx == temperature.length - 1 || dotCount > 1;
    double temValue;
    try {
      temValue = double.parse(temperature);
    } catch (e) {
      flag = true;
    }
    if (temperature.isEmpty) {
      showMsgToast('??????????????????');
      return false;
    }
    if (flag) {
      showMsgToast('?????????????????????');
      return false;
    }
    if (temValue < -100 || temValue > 100) {
      showMsgToast('??????????????????-100???100??????');
      return false;
    }
    return true;
  }

  submit({bool confirm = true}) async {
    if (!checkData()) return;
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    KumiPopupWindow pop = PopUtils.showLoading();
    try {
      if (confirm) {
        await Repository.fetchAddDelivery(
            labId: labId,
            id: widget.item.id,
            data: {
              "dcId": widget.item.dcId,
              "id": widget.item.id,
              "barcodeTotal": barCodeCon.text.isEmpty ? 0 : barCodeCon.text,
              "inspectionUnitId": widget.item.inspectionUnitId,
              "inspectionUnitName": widget.item.inspectionUnitName,
              "joinId": widget.item.joinId,
              "pathologyLiquidSpecimen": fluidSampleCon.text,
              "pathologyOther": pathologyOtherCon.text,
              "pathologyQfc": qfcCon.text,
              "pathologySlideGlassConsultation": slideConsultationCon.text,
              "pathologySlideGlassCooperate": slideJointlyCon.text,
              "pathologySmear": sliceCon.text,
              "pathologyTissueOrder": applyCon.text,
              "pathologyTissueSample": sampleCountCon.text,
              "pathologyTissueTct": tctCon.text,
              "pathologyWaxBlockConsultation": waxConsultationCon.text,
              "pathologyWaxBlockCooperate": waxJointlyCon.text,
              "routineIce": iceCon.text,
              "routineMic": microCon.text,
              "routineOther": othersCon.text,
              "routineSecretion": bloodCon.text,
              "routineSmear": sliceNormalCon.text,
              "temperature": temperatureCon.text,
              "createAt": dateCon.text + ':00.000',
              "updateAt": dateCon.text + ':00.000',
              "status": widget.item.status,
            });
      }
      await Repository.fetchConfirmDeliveryItem(
          widget.item.id, confirm ? '1' : '0');
    } catch (e, s) {
      PopUtils.showError(e, s);
      pop.dismiss(context);
      return;
    }
    await widget.updateStatus?.call();
    pop.dismiss(context, onFinish: (_p) {
      var yyDialog;
      yyDialog = yyNoticeDialog(text: '${confirm ? '' : '??????'}????????????');
      Future.delayed(Duration(milliseconds: 1500), () {
        dialogDismiss(yyDialog);
      });
    });
  }
}
