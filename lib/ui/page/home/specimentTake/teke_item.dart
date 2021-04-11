import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';

class TakeItem extends StatelessWidget {
  final String sender;
  final String bill;
  final String line;
  final String end;
  final String date;
  final String remark;
  final bool confirm;
  TakeItem(
      {this.sender,
      this.bill,
      this.line,
      this.end,
      this.date,
      this.remark,
      this.confirm});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(60),
            right: ScreenUtil().setWidth(60),
            bottom: ScreenUtil().setWidth(40)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(20),
                  horizontal: ScreenUtil().setWidth(40)),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Text(
                    '发出人：${sender}',
                    style: TextStyle(color: Color(0xFF666666)),
                  )),
                  Container(
                      child: Text(
                    confirm ? '已接收' : '未接收',
                    style: TextStyle(
                        color:
                            confirm ? Color(0xFF999999) : DiyColors.heavy_blue),
                  ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20)),
                          child: Text(
                            bill,
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: ScreenUtil().setSp(38)),
                          )),
                      Image.asset(
                        ImageHelper.wrapAssets('express.png'),
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10),
                              vertical: ScreenUtil().setWidth(10)),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Color(0xFFf0f0f0))),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(30),
                              bottom: ScreenUtil().setWidth(10)),
                          child: Text(
                            line,
                            style: TextStyle(
                                color: Color(0xFF9d9d9d),
                                fontSize: ScreenUtil().setSp(34)),
                          )),
                      Container(
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setWidth(70),
                        child: Image.asset(
                          ImageHelper.wrapAssets('to.png'),
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20)),
                          child: Text(
                            end,
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: ScreenUtil().setSp(38)),
                          )),
                      Image.asset(
                        ImageHelper.wrapAssets('flag.png'),
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                      )
                    ],
                  ))
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setWidth(20)),
                child: Text('交接时间：$date',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400))),
            Container(
                margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(30),
                    left: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setWidth(20)),
                child: Text('备注：$remark',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400))),
            Container(
              width: ScreenUtil.screenWidth,
              margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                      onTap: () {},
                      child: Container(
                        width: ScreenUtil().setWidth(220),
                        height: ScreenUtil().setHeight(72),
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                        decoration: BoxDecoration(
                            color: confirm
                                ? Color(0xFFf2f2f2)
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: confirm
                                    ? Color(0xFFe0e0e0)
                                    : DiyColors.heavy_blue),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(100)))),
                        alignment: Alignment.center,
                        child: Text(confirm ? '已确认' : '确认接收',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: confirm
                                    ? Color(0xFF999999)
                                    : DiyColors.heavy_blue,
                                letterSpacing: 1)),
                      )),
                ],
              ),
            )
          ],
        ));
  }
}
