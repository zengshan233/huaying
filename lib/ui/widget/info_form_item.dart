import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';

class InfoFormItem extends StatelessWidget {
  final String lable;
  final String text;
  final Widget rightWidget;
  final double commonWidth;
  InfoFormItem({this.lable, this.text, this.rightWidget, this.commonWidth});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(30),
          horizontal: ScreenUtil().setWidth(50)),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
            child: inputPreText(
                preText: lable, isRquire: false, width: commonWidth),
          ),
          Expanded(
            child: text != null
                ? Text(
                    text.isEmpty ? '--' : text,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(38),
                      color: Color(0xFF717171),
                    ),
                  )
                : Container(),
          ),
          rightWidget ?? Container()
        ],
      ),
    );
  }
}
