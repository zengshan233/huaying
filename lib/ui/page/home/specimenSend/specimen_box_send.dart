import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/specimenSend/specimen_boxes.dart';
import 'package:huayin_logistics/ui/widget/bottomSheet.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, simpleRecordInput;
import 'package:huayin_logistics/ui/widget/datePicker/flutter_cupertino_date_picker.dart';
import 'package:huayin_logistics/ui/widget/datePicker/src/date_picker.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/specimen_send_model.dart';

class SpecimenBoxSend extends StatefulWidget {
  @override
  _SpecimenBoxSend createState() => _SpecimenBoxSend();
}

class _SpecimenBoxSend extends State<SpecimenBoxSend> {
  DateTime sendTime;
  DateTime arriveTime;
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
        body: ProviderWidget<SpecimenSendModel>(
            model: SpecimenSendModel(context),
            onBuildReady: (SpecimenSendModel model) {
              model.getData();
            },
            builder: (context, model, child) => SingleChildScrollView(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(60)),
                child: new Column(
                  children: <Widget>[
                    SpecimenBoxes(updateBox: () {
                      model.getBoxes(update: true);
                    }),
                    pickLine(model),
                    baseInfo(model),
                    UploadImgage(
                        tips: '注：需上传一张带锁的图片和一张全貌图',
                        submit: (data) {
                          model.submit(data);
                        }),
                  ],
                ))),
      ),
    );
  }

  Widget pickLine(SpecimenSendModel model) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(40)),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
      child: simpleRecordInput(context,
          preText: '路线',
          hintText: '(必填)请选择路线',
          enbleInput: false,
          isRquire: true,
          rightWidget: new Image.asset(
            ImageHelper.wrapAssets('mine_rarrow.png'),
            width: ScreenUtil().setHeight(40),
            height: ScreenUtil().setHeight(40),
          ),
          onController: model.lineCon, onTap: () {
        PopUtils.showPop(
            opacity: 0.5,
            animated: false,
            child: BottomSheetList(
              title: '路线选择',
              nameList: model.wayList.list.map((l) => l.lineName).toList(),
              pickedName: model.line?.lineName,
              confirm: (index) {
                model.lineCon.text = model.wayList.list[index].lineName;
                model.line = model.wayList.list[index];
              },
            ));
      }),
    );
  }

  // 基本信息
  Widget baseInfo(SpecimenSendModel model) {
    return new Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
        child: new Column(
          children: <Widget>[
            simpleRecordInput(context,
                preText: '发出站点',
                isRquire: true,
                hintText: '(必填)请输入出发站点',
                onController: model.sendCon,
                onTap: () {}),
            simpleRecordInput(context,
                preText: '发出时间',
                isRquire: true,
                hintText: '(必填)请选择发出时间',
                enbleInput: false,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: model.sendDateCon, onTap: () {
              DatePicker.showDatePicker(context,
                  title: '选择发出时间',
                  locale: DateTimePickerLocale.zh_cn,
                  pickerMode: DateTimePickerMode.datetime,
                  minDateTime: DateTime.now(),
                  maxDateTime: arriveTime,
                  dateFormat: 'MMdd HH:mm',
                  pickerTheme: DateTimePickerTheme(
                      itemTextStyle: TextStyle(
                          color: DiyColors.heavy_blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  onConfirm: (DateTime dateTime, List<int> days) async {
                sendTime = dateTime;
                model.sendDateCon.text =
                    DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd HH:mm');
              });
            }),
            simpleRecordInput(context,
                preText: '预计到站',
                hintText: '(必填)请选择预计到达站点',
                enbleInput: false,
                isRquire: true,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: model.arriveCon, onTap: () {
              PopUtils.showPop(
                  opacity: 0.5,
                  animated: false,
                  child: BottomSheetList(
                    title: '选择站点',
                    nameList: model.sites.map((s) => s.siteName).toList(),
                    pickedName: model.site?.siteName,
                    confirm: (index) {
                      model.arriveCon.text = model.sites[index].siteName;
                      model.site = model.sites[index];
                    },
                  ));
            }),
            simpleRecordInput(context,
                preText: '预计到时',
                hintText: '(必填)请选择预计到达时间',
                enbleInput: false,
                isRquire: true,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: model.arriveDateCon, onTap: () {
              DatePicker.showDatePicker(context,
                  title: '选择到达时间',
                  locale: DateTimePickerLocale.zh_cn,
                  pickerMode: DateTimePickerMode.datetime,
                  minDateTime: sendTime ?? DateTime.now(),
                  dateFormat: 'MMdd HH:mm',
                  pickerTheme: DateTimePickerTheme(
                      itemTextStyle: TextStyle(
                          color: DiyColors.heavy_blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  onConfirm: (DateTime dateTime, List<int> days) async {
                arriveTime = dateTime;
                model.arriveDateCon.text =
                    DateUtil.formatDate(dateTime, format: 'yyyy-MM-dd HH:mm');
              });
            }),
            simpleRecordInput(
              context,
              preText: '车牌号',
              hintText: '请输入车牌号',
              onController: model.licenseCon,
            ),
            simpleRecordInput(
              context,
              preText: '运单号',
              hintText: '请输入运单号',
              onController: model.transportNoCon,
            ),
          ],
        ));
  }
}
