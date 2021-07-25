import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';

YYDialog yyNoticeDialog({String text = '操作成功', BuildContext context}) {
  return YYDialog().build(context)
    ..width = 120
    ..height = 110
    ..barrierColor = Colors.transparent
    ..barrierDismissible = false
    ..backgroundColor = Colors.black.withOpacity(0.8)
    ..borderRadius = 10.0
    ..widget(Padding(
      padding: EdgeInsets.only(top: 21),
      child: Image.asset(
        ImageHelper.wrapAssets('success.png'),
        width: 38,
        height: 38,
      ),
    ))
    ..widget(Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ))
    ..show();
}

YYDialog yyNoticeFailedDialog({String text = '操作失败'}) {
  return YYDialog().build()
    ..width = 120
    ..height = 110
    ..barrierColor = Colors.transparent
    ..barrierDismissible = false
    ..backgroundColor = Colors.black.withOpacity(0.8)
    ..borderRadius = 10.0
    ..widget(Padding(
      padding: EdgeInsets.only(top: 21),
      child: Image.asset(
        ImageHelper.wrapAssets('failed.png'),
        width: 38,
        height: 38,
      ),
    ))
    ..widget(Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ))
    ..show();
}
