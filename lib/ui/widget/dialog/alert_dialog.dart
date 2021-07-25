import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

YYDialog yyAlertDialogWithDivider(
    {Function success,
    Function cancel,
    String tip = '确定要执行该操作吗？',
    BuildContext context,
    List<String> tipList = const []}) {
  var yyDialog;
  yyDialog = YYDialog().build(context)
    ..width = 240
    ..borderRadius = 4.0
    ..text(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      text: tipList.isNotEmpty ? tipList.first : tip,
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    )
    ..text(
      padding: EdgeInsets.only(bottom: 15.0),
      alignment: Alignment.center,
      text: tipList.isNotEmpty ? tipList.last : '',
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    )
    ..divider()
    ..doubleButton(
      padding: EdgeInsets.only(top: 10.0),
      gravity: Gravity.center,
      withDivider: true,
      text1: "取消",
      color1: Color.fromRGBO(177, 177, 177, 1),
      fontSize1: 14.0,
      fontWeight1: FontWeight.bold,
      onTap1: () {
        cancel?.call();
      },
      text2: "确定",
      color2: Color.fromRGBO(21, 145, 241, 1),
      fontSize2: 14.0,
      fontWeight2: FontWeight.bold,
      onTap2: () {
        success();
      },
    )
    ..show();
  return yyDialog;
}
