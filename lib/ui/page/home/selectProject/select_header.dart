import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/utils/events_utils.dart';

class SelectHeader extends StatefulWidget {
  final List<SelectItemRightListItem> hasSelectItem;
  SelectHeader({this.hasSelectItem});
  @override
  _SelectHeader createState() => _SelectHeader();
}

class _SelectHeader extends State<SelectHeader> {
  bool showItems = false;

  @override
  void initState() {
    // TODO: implement initState
    GlobalEvents().showHeader.stream.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        showItems = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFf0f2f5),
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
      child: Row(
        children: <Widget>[
          Expanded(child: Container()),
          Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '已选项目',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(46)),
                  ))),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      right: ScreenUtil().setWidth(60),
                      bottom: ScreenUtil().setWidth(showItems ? 15 : 0),
                      top: ScreenUtil().setWidth(showItems ? 0 : 20)),
                  child: Transform.rotate(
                    angle: (showItems ? 1 : -1) * pi / 2,
                    child: Image.asset(
                      ImageHelper.wrapAssets('right_more.png'),
                      width: ScreenUtil().setWidth(90),
                      height: ScreenUtil().setWidth(90),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
