import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoFormItem extends StatelessWidget {
  final String lable;
  final String text;
  final Widget rightWidget;
  InfoFormItem({this.lable, this.text, this.rightWidget});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(50),
                right: ScreenUtil().setWidth(50)),
            constraints: BoxConstraints(minWidth: ScreenUtil().setWidth(230)),
            child: Text(
              lable,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(38),
                color: Color(0xFF333333),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(38),
                color: Color(0xFF717171),
              ),
            ),
          ),
          rightWidget ?? Container()
        ],
      ),
    );
  }
}
