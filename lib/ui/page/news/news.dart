import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';


class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
			margin: EdgeInsets.only(top:ScreenUtil().setHeight(800)),
			child: noDataWidget(text: '功能暂未开放，敬请期待！'),
		),
      ),
    );
  }
}
