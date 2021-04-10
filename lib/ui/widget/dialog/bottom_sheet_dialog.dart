import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

YYDialog yyBottomSheetDialog({String leftText='',String rightText='',@required Function leftPress,@required Function rightPress}) {
  return YYDialog().build()
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Colors.transparent
    ..widget(Container(
      width: 300,
      height: 45,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: FlatButton(
        child: Text(leftText),
		onPressed: leftPress,
      ),
    ))
    ..widget(Container(
      width: 300,
      height: 45,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: FlatButton(
        child: Text(
          rightText
        ),
		highlightColor: Colors.transparent,
		onPressed: rightPress,
      ),
    ))
    ..show();
}
