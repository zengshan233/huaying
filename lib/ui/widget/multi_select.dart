import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';

class MultiSelect extends StatelessWidget {
  final bool select;
  final bool disable;
  MultiSelect({this.select = false, this.disable = false});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        width: ScreenUtil().setWidth(80),
        height: ScreenUtil().setWidth(80),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(50), right: ScreenUtil().setWidth(50)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            select
                ? Container(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                    child: Image.asset(
                      ImageHelper.wrapAssets(
                          disable ? 'record_so.png' : 'record_sg.png'),
                      fit: BoxFit.fitWidth,
                    ))
                : Container(
                    width: ScreenUtil().setWidth(disable ? 80 : 55),
                    height: ScreenUtil().setWidth(disable ? 80 : 55),
                    child: Image.asset(
                      ImageHelper.wrapAssets(
                          disable ? 'record_so.png' : 'select_off.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  )
          ],
        ));
  }
}
