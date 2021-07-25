import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, radiusButton, showMsgToast, simpleRecordInput;
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/utils/device_utils.dart';
import 'package:huayin_logistics/utils/popUtils.dart';

class MutilUpload extends StatefulWidget {
  final List<String> barCodes;
  final Function(List) addImgs;
  MutilUpload({this.barCodes, this.addImgs});
  @override
  _MutilUpload createState() => _MutilUpload();
}

class _MutilUpload extends State<MutilUpload> {
  TextEditingController _barCodeControll = TextEditingController(); //条码号

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '批量上传图片', ''),
        body: Column(
          children: <Widget>[
            Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(40)),
                child: new Column(
                  children: <Widget>[
                    simpleRecordInput(
                      context,
                      preText: '条码编号',
                      hintText: '(必填)请扫描或输入条码号',
                      keyType: TextInputType.visiblePassword,
                      onController: _barCodeControll,
                      maxLength: 12,
                      rightWidget: InkWell(
                          onTap: () async {
                            String code = await DeviceUtils.scanBarcode();
                            if (code != null) {
                              _barCodeControll.text = code;
                            }
                          },
                          child: radiusButton(text: '扫码', img: "scan.png")),
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              alignment: Alignment.centerLeft,
              child: Text(
                '注：请输入已录数据的条码号',
                style: TextStyle(
                    color: DiyColors.heavy_blue,
                    fontSize: ScreenUtil().setSp(38)),
              ),
            ),
            UploadImgage(submit: (data) {
              String barCode = _barCodeControll.text;
              if (barCode.isEmpty) {
                showMsgToast('请输入条码号！', context: context);
                return;
              }
              if (barCode.length != 12) {
                showMsgToast('条码号须为12位', context: context);
                return;
              }
              if (!widget.barCodes.contains(barCode)) {
                showMsgToast('该条码号不在已录数据里！', context: context);
                return;
              }
              if (!widget.barCodes.contains(barCode)) {
                showMsgToast('该条码号不在已录数据里！', context: context);
                return;
              }
              if (barCode.isEmpty) {
                showMsgToast('条码编号必填！', context: context);
                return;
              }
              print('data $data');
              if (data == null || data.isEmpty) {
                showMsgToast('请选择需要上传的图片', context: context);
                return;
              }
              PopUtils.showNotice(onPop: () {
                widget.addImgs([barCode, data]);
                data.clear();
                _barCodeControll.clear();
                setState(() {});
              });
            })
          ],
        ));
  }
}
