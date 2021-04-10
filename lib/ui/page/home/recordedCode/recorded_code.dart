import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, radiusButton, simpleRecordInput;
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/ui/widget/datePicker/flutter_cupertino_date_picker.dart';
import 'code_detail.dart';

class RecordedCode extends StatefulWidget {
  @override
  _RecordedCode createState() => _RecordedCode();
}

class _RecordedCode extends State<RecordedCode> {
  TextEditingController _dateControll = TextEditingController(); //日期
  TextEditingController _barCodeControll = TextEditingController(); //条码号
  List<CodeItem> data = [];

  String date = '';

  bool loading = false;

  int status = 0;

  List taps = [
    {'name': '未发出', 'status': 0},
    {'name': '已发出', 'status': 1},
    {'name': '已签收', 'status': 2}
  ];

  @override
  void initState() {
    super.initState();
    getData(0);
  }

  Future getData(int _status) async {
    loading = true;
    setState(() {
      status = _status;
    });
    await Future.delayed(Duration(seconds: 1));
    String codeStatus = status == 0 ? '未发出' : status == 1 ? '已发出' : '已签收';

    setState(() {
      data = [
        CodeItem(
            date: '2021-02-13',
            billno: '02号标本箱',
            number: '21030901',
            status: codeStatus),
        CodeItem(
            date: '2021-02-13',
            billno: '03号标本箱',
            number: '21030901',
            status: codeStatus),
        CodeItem(
            date: '2021-02-13',
            billno: '04号标本箱',
            number: '21030901',
            status: codeStatus),
        CodeItem(
            date: '2021-02-13',
            billno: '05号标本箱',
            number: '21030901',
            status: codeStatus),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '已录条码', '外勤:张三'),
        body: Column(
          children: <Widget>[
            _baseInfo(),
            buildTaps(),
            Expanded(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (c, index) {
                      return buildItem(data[index]);
                    }))
          ],
        ));
  }

  // 基本信息
  Widget _baseInfo() {
    return new Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
        child: new Column(
          children: <Widget>[
            simpleRecordInput(context,
                preText: '日    期',
                hintText: '请选择日期',
                enbleInput: false,
                onController: _dateControll,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ), onTap: () {
              DatePicker.showDatePicker(context,
                  // pickerTheme: DateTimePickerTheme(
                  //   confirmTextStyle: TextStyle(color: Color(0xFF0377D1)),
                  //   cancelTextStyle: TextStyle(color: Color(0xFF0377D1)),
                  //   itemTextStyle: TextStyle(
                  //       color: Color(0xFF303133), fontWeight: FontWeight.bold),
                  // ),
                  // maxDateTime: DateTime.now(),
                  locale: DateTimePickerLocale.zh_cn,
                  onConfirm: (DateTime dateTime, List<int> days) async {
                _dateControll.text = dateTime.toString().split(' ').first;
              });
            }),
            simpleRecordInput(
              context,
              preText: '条码号',
              hintText: '请扫描或输入条码号',
              keyType: TextInputType.visiblePassword,
              onController: _barCodeControll,
              maxLength: 12,
              rightWidget: InkWell(
                  onTap: () {
                    var p = new BarcodeScanner(success: (String code) {
                      //print('条形码'+code);
                      if (code == '-1') return;
                      _barCodeControll.text = code;
                    });
                    p.scanBarcodeNormal();
                  },
                  child: radiusButton(text: '扫码', img: "scan.png")),
            ),
          ],
        ));
  }

  Widget buildTaps() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: taps.map((e) {
          bool isPicked = e['status'] == status;
          return InkWell(
              onTap: () => getData(e['status']),
              child: Container(
                child: Column(children: [
                  Text(
                    e['name'],
                    style: TextStyle(
                        color: isPicked
                            ? DiyColors.heavy_blue
                            : Color(0xFFcccccc)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                    height: 2,
                    width: ScreenUtil().setWidth(100),
                    color: isPicked ? DiyColors.heavy_blue : Colors.transparent,
                  )
                ]),
              ));
        }).toList(),
      ),
    );
  }

  Widget buildItem(CodeItem item) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => CodeDetail()));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(item.date),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                      child: Text(item.billno),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        item.number,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(40),
                          right: ScreenUtil().setWidth(40)),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                          vertical: ScreenUtil().setWidth(15)),
                      alignment: Alignment.center,
                      child: Text(item.status),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
