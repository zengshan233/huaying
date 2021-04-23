import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class SpecimentBoxCombine extends StatefulWidget {
  @override
  _SpecimentBoxCombine createState() => _SpecimentBoxCombine();
}

class _SpecimentBoxCombine extends State<SpecimentBoxCombine> {
  TextEditingController customCon = TextEditingController();

  List<SpecimenCombinedItem> combineList = [];

  List<SpecimenUnusedItem> boxList = [];

  List<SpecimenCombinedItem> combineBoxes = [];

  SpecimenUnusedItem box;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  getData() async {
    var userInfo = Provider.of<MineModel>(context, listen: false).user?.user;
    String labId = '82858490362716212';
    String userId = userInfo.id;
    KumiPopupWindow pop = PopUtils.showLoading();
    try {
      combineList =
          await Repository.fetchCombinedBoxes(labId: labId, userId: userId);
      boxList = await Repository.fetchUnUsedBoxes(labId: labId, userId: userId);
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
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '标本箱合箱', '外勤:', withName: true),
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
                      children: boxList.map((e) => buildBoxItem(e)).toList(),
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

  Widget buildCombineItem(SpecimenCombinedItem item) {
    return InkWell(
        onTap: () {
          if (combineBoxes.contains(item)) {
            combineBoxes.removeWhere((c) => c.boxNo == item.boxNo);
          } else {
            combineBoxes.add(item);
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
                    ImageHelper.wrapAssets(combineBoxes.contains(item)
                        ? 'record_sg.png'
                        : 'record_so.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(item.boxNo,
                      style: TextStyle(color: Color(0xFF666666)))),
            ],
          ),
        ));
  }

  Widget buildBoxItem(SpecimenUnusedItem item) {
    return InkWell(
        onTap: () {
          setState(() {
            box = item;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(35)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            children: <Widget>[
              Container(
                child: Container(
                  width: ScreenUtil().setWidth(55),
                  height: ScreenUtil().setWidth(55),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(60),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.wrapAssets(box?.boxNo == item.boxNo
                        ? 'select_on.png'
                        : 'select_off.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(item.boxNo,
                      style: TextStyle(color: Color(0xFF666666)))),
            ],
          ),
        ));
  }

  Widget biuldCustomBox() {
    return InkWell(
        onTap: () {
          setState(() {
            box = null;
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
                  width: ScreenUtil().setWidth(55),
                  height: ScreenUtil().setWidth(55),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(60),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.wrapAssets(
                        box == null ? 'select_on.png' : 'select_off.png'),
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
              onTap: submit,
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

  submit() async {
    var userInfo = Provider.of<MineModel>(context, listen: false).user?.user;
    String labId = '82858490362716212';
    List items = combineBoxes
        .map((e) => {"boxNo": e.boxNo, "joinId": e.joinId, "boxId": e.boxId})
        .toList();
    KumiPopupWindow pop = PopUtils.showLoading();
    try {
      await Repository.fetchBoxesCombine(data: {
        "boxId": box.id,
        "boxNo": box.boxNo,
        "items": items,
        "userId": userInfo.id,
        "userName": userInfo.name
      }, labId: labId);
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
      });
    });
  }
}
