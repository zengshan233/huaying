import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';

class GridCheckItem extends StatelessWidget {
  final String text;
  final Function routerPush;
  final String imgUrl;
  GridCheckItem({this.text, this.routerPush, this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return new Container(
        width: ScreenUtil().setWidth(200),
        height: ScreenUtil().setHeight(300),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: routerPush,
                highlightColor: Colors.transparent,
                color: Colors.white,
                elevation: 0.0,
                shape: CircleBorder(side: BorderSide(style: BorderStyle.none)),
                splashColor: Color.fromRGBO(0, 146, 200, 0.1),
                child: new Container(
                  child: new Image.asset(
                    ImageHelper.wrapAssets(imgUrl),
                    fit: BoxFit.fill,
                  ),
                )),
            Text(text,
                style: TextStyle(
                    color: DiyColors.normal_black,
                    fontSize: ScreenUtil().setSp(38)))
          ],
        ));
  }
}

class WriteTicketText extends StatelessWidget {
  final String text;
  WriteTicketText({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
      child: new Text(text,
          style: TextStyle(
              color: DiyColors.normal_black,
              fontWeight: FontWeight.w700,
              fontSize: ScreenUtil().setSp(40))),
    );
  }
}

class GridExpressItem extends StatelessWidget {
  final String text;
  final String imgUrl;
  final Function routerPush;
  GridExpressItem({this.text, this.imgUrl, this.routerPush});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          routerPush();
        },
        child: Container(
          width: ScreenUtil().setWidth(320),
          height: ScreenUtil().setHeight(260),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(26)))),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setWidth(20)),
                child: new Text(text,
                    style: TextStyle(
                        color: DiyColors.normal_black,
                        fontSize: ScreenUtil().setSp(40))),
              ),
              new Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Image(
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                        image: new AssetImage(ImageHelper.wrapAssets(imgUrl)),
                        fit: BoxFit.fill)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class GridBoxItem extends StatelessWidget {
  final String text;
  final String imgUrl;
  final Function routerPush;
  GridBoxItem({this.text, this.imgUrl, this.routerPush});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: routerPush,
        child: Container(
          height: ScreenUtil().setHeight(260),
          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: new Image(
                    width: ScreenUtil().setWidth(90),
                    height: ScreenUtil().setWidth(90),
                    image: new AssetImage(ImageHelper.wrapAssets(imgUrl)),
                    fit: BoxFit.fill),
              ),
              new Container(
                child: Text(text,
                    style: TextStyle(
                        color: DiyColors.normal_black,
                        fontSize: ScreenUtil().setSp(40))),
              )
            ],
          ),
        ));
  }
}

class GridOtherItem extends StatelessWidget {
  final String text;
  final String imgUrl;
  final Function routerPush;
  final bool showBorder;
  GridOtherItem({this.text, this.imgUrl, this.routerPush, this.showBorder});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: routerPush,
        child: new Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: showBorder
                      ? BorderSide(
                          width: ScreenUtil().setHeight(5),
                          color: DiyColors.line_grey)
                      : BorderSide.none)),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                child: new Image(
                    width: ScreenUtil().setWidth(90),
                    height: ScreenUtil().setWidth(90),
                    image: new AssetImage(ImageHelper.wrapAssets(imgUrl)),
                    fit: BoxFit.fill),
              ),
              new Text(text,
                  style: TextStyle(
                      color: DiyColors.normal_black,
                      fontSize: ScreenUtil().setSp(44),
                      fontWeight: FontWeight.w700))
            ],
          ),
        ));
  }
}
