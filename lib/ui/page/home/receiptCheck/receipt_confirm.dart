import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:provider/provider.dart';
import 'package:huayin_logistics/view_model/home/check_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;

class ReceiptConfirm extends StatefulWidget {
  final String applyId;
  final Function(bool) update;
  const ReceiptConfirm({Key key, this.applyId, this.update}) : super(key: key);
  @override
  _ReceiptConfirm createState() => _ReceiptConfirm();
}

class _ReceiptConfirm extends State<ReceiptConfirm> {
  bool passed = false;
  TextEditingController textCon = TextEditingController();
  FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return ProviderWidget<CheckModel>(
        model: CheckModel(context: context),
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: DiyColors.background_grey,
              appBar: appBarWithName(context, '审核', '外勤:', withName: true),
              body: Column(
                children: <Widget>[
                  buildItem(true, '审核通过'),
                  buildItem(false, '审核不通过'),
                  buildContent(),
                  confirm()
                ],
              ));
        });
  }

  Widget buildItem(bool _pass, String text) {
    return InkWell(
        onTap: () {
          setState(() {
            passed = _pass;
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
                        passed == _pass ? 'record_sg.png' : 'record_so.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child:
                      Text(text, style: TextStyle(color: Color(0xFF666666)))),
            ],
          ),
        ));
  }

  Widget buildContent() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(50)),
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setWidth(40),
        horizontal: ScreenUtil().setWidth(40),
      ),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('审核意见'),
          ),
          Expanded(
              child: Container(
            constraints: BoxConstraints(minHeight: ScreenUtil().setWidth(500)),
            child: TextField(
              scrollPadding: EdgeInsets.all(0),
              autofocus: false,
              controller: textCon,
              maxLines: 10,
              focusNode: focusNode,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(40),
                color: Color.fromRGBO(90, 90, 91, 1),
              ),
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '请输入审核意见',
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
    return Consumer<CheckModel>(builder: (context, model, child) {
      return Container(
        width: ScreenUtil.screenWidth,
        margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  focusNode.unfocus();
                  if (passed) {
                    model.adopt(widget.applyId, textCon.text, success: () {
                      widget.update(passed);
                      Navigator.pop(context);
                    });
                  } else {
                    model.refuse(widget.applyId, textCon.text, success: () {
                      widget.update(passed);
                      Navigator.pop(context);
                    });
                  }
                },
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
    });
  }
}
