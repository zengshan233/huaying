import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';


YYDialog yyAlertDialogWithDivider({Function success,String tip='确定要执行该操作吗？'}) {
	var yyDialog;
	yyDialog=YYDialog().build()
	..width = 240
	..borderRadius = 4.0
	..text(
		padding: EdgeInsets.all(25.0),
		alignment: Alignment.center,
		text: tip,
		color: Colors.black,
		fontSize: 16.0,
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
