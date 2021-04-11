import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;

class SpecimentBoxCombine extends StatefulWidget {
  @override
  _SpecimentBoxCombine createState() => _SpecimentBoxCombine();
}

class _SpecimentBoxCombine extends State<SpecimentBoxCombine> {
  TextEditingController customCon = TextEditingController();

  List<SpecimenBoxItem> combineList = [];

  List<SpecimenBoxItem> boxList = [];

  List<String> combineBoxes = [];

  String box;

  @override
  void initState() {
    super.initState();
    getCombineList();
    getBoxList();
  }

  getCombineList() {
    combineList = [
      SpecimenBoxItem(code: '1', name: '01号标本箱'),
      SpecimenBoxItem(code: '2', name: '02号标本箱'),
      SpecimenBoxItem(code: '3', name: '03号标本箱'),
      SpecimenBoxItem(code: '4', name: '04号标本箱'),
    ];
  }

  getBoxList() {
    boxList = [
      SpecimenBoxItem(code: '5', name: '21号标本箱'),
      SpecimenBoxItem(code: '6', name: '22号标本箱'),
      SpecimenBoxItem(code: '7', name: '23号标本箱'),
      SpecimenBoxItem(code: '8', name: '24号标本箱'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '标本箱合箱', '外勤:张三'),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(50),
                        vertical: ScreenUtil().setWidth(20)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '待合标本箱',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Column(
                      children:
                          combineList.map((e) => buildCombineItem(e)).toList(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(50),
                        vertical: ScreenUtil().setWidth(20)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '选择标本箱（合并用箱）',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Column(
                      children:
                          combineList.map((e) => buildBoxItem(e)).toList(),
                    ),
                  )
                ],
              ),
            ),
            biuldCustomBox(),
            confirm()
          ],
        )));
  }

  Widget buildCombineItem(SpecimenBoxItem item) {
    return InkWell(
        onTap: () {
          if (combineBoxes.contains(item.code)) {
            combineBoxes.removeWhere((c) => c == item.code);
          } else {
            combineBoxes.add(item.code);
          }
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            children: <Widget>[
              Container(
                child: Container(
                  width: ScreenUtil().setWidth(80),
                  height: ScreenUtil().setWidth(80),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(50),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.wrapAssets(combineBoxes.contains(item.code)
                        ? 'record_sg.png'
                        : 'record_so.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(item.name,
                      style: TextStyle(color: Color(0xFF666666)))),
            ],
          ),
        ));
  }

  Widget buildBoxItem(SpecimenBoxItem item) {
    return InkWell(
        onTap: () {
          setState(() {
            box = item.code;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            children: <Widget>[
              Container(
                child: Container(
                  width: ScreenUtil().setWidth(80),
                  height: ScreenUtil().setWidth(80),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(50),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.wrapAssets(
                        box == item.code ? 'record_sg.png' : 'record_so.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(item.name,
                      style: TextStyle(color: Color(0xFF666666)))),
            ],
          ),
        ));
  }

  Widget biuldCustomBox() {
    return InkWell(
        onTap: () {
          setState(() {
            box = 'custom';
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            children: <Widget>[
              Container(
                child: Container(
                  width: ScreenUtil().setWidth(80),
                  height: ScreenUtil().setWidth(80),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(50),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.wrapAssets(
                        box == 'custom' ? 'record_sg.png' : 'record_so.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: TextField(
                        key: UniqueKey(),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(40),
                            color: Color.fromRGBO(0, 117, 255, 1)),
                        decoration: InputDecoration(
                            hintText: '请输入标本箱号',
                            hintStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Color.fromRGBO(211, 211, 211, 1),
                                height: 1.4),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            counterText: ""),
                        //禁止输入
                        maxLength: 12,
                        controller: customCon,
                      ))),
            ],
          ),
        ));
  }

  Widget confirm() {
    return Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {},
              child: Container(
                width: ScreenUtil().setWidth(1000),
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
                decoration: BoxDecoration(
                    color: DiyColors.heavy_blue,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                alignment: Alignment.center,
                child: Text(
                  '确  定',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
