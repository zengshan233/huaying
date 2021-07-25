import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

YYDialog yyProgressDialogNoBody() {
  return YYDialog().build()
    ..width = 200
    ..borderRadius = 4.0
    ..backgroundColor = Colors.transparent
    ..circularProgress(
      padding: EdgeInsets.all(24.0),
    )
    ..show();
}

YYDialog yyProgressDialogBody({String text = '加载中...', BuildContext context}) {
  return YYDialog().build(context)
    ..width = 100
    ..borderRadius = 8.0
    ..circularProgress(
      padding: EdgeInsets.all(10),
      valueColor: Colors.white,
    )
    ..text(
      padding: EdgeInsets.only(bottom: 8),
      text: text,
      alignment: Alignment.center,
      color: Colors.white,
      fontSize: 16.0,
    )
    ..barrierColor = Colors.transparent
    ..backgroundColor = Color.fromRGBO(0, 0, 0, 0.6)
    ..barrierDismissible = false
    ..show();
}

void dialogDismiss(yyDialog) {
  yyDialog?.dismiss();
}
