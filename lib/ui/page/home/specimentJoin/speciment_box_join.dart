import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, simpleRecordInput;
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class SpecimentBoxJoin extends StatefulWidget {
  @override
  _SpecimentBoxJoin createState() => _SpecimentBoxJoin();
}

class _SpecimentBoxJoin extends State<SpecimentBoxJoin> {
  TextEditingController takeCon = TextEditingController();
  TextEditingController textCon = TextEditingController();

  List<SpecimenBoxItem> combineList = [];

  String box;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getBoxList());
  }

  getBoxList() {
    MineModel model = Provider.of<MineModel>(context, listen: false);
    String labId = '82858490362716212';
    String userId = model.user.user.id;
    Repository.fetchJoinBoxes(labId: labId, userId: userId);
    combineList = [
      SpecimenBoxItem(code: '1', name: '01号标本箱'),
      SpecimenBoxItem(code: '2', name: '02号标本箱'),
      SpecimenBoxItem(code: '3', name: '03号标本箱'),
      SpecimenBoxItem(code: '4', name: '04号标本箱'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '标本箱交接', '外勤:', withName: true),
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
                      '可交接标本箱',
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
            Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(40)),
                child: simpleRecordInput(context,
                    preText: '接收人',
                    hintText: '(必填)请选择接收人',
                    enbleInput: false,
                    rightWidget: new Image.asset(
                      ImageHelper.wrapAssets('mine_rarrow.png'),
                      width: ScreenUtil().setHeight(40),
                      height: ScreenUtil().setHeight(40),
                    ),
                    onController: takeCon,
                    onTap: () {})),
            buildContent(),
            confirm()
          ],
        )));
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

  Widget buildContent() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setWidth(40),
        horizontal: ScreenUtil().setWidth(40),
      ),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('备注信息'),
          ),
          Expanded(
              child: Container(
            constraints: BoxConstraints(minHeight: ScreenUtil().setWidth(300)),
            child: TextField(
              scrollPadding: EdgeInsets.all(0),
              autofocus: false,
              controller: textCon,
              maxLines: 5,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(40),
                color: Color.fromRGBO(90, 90, 91, 1),
              ),
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '请输入备注',
                  hintStyle: TextStyle(color: Color(0xFFcccccc)),
                  contentPadding:
                      EdgeInsets.only(left: ScreenUtil().setWidth(50), top: 0)),
            ),
          ))
        ],
      ),
    );
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
                  '提  交',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
