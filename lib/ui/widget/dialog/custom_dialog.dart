import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

YYDialog yyCustomDialog({Widget widget,double width,BuildContext context}) {

  	return YYDialog().build(context)
    ..width = width
    ..borderRadius = 10
    ..widget(
		widget
	)
    ..show();
}
