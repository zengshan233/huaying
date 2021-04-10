import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; //防止initState多次执行

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //防止initState多次执行
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            backgroundColor: DiyColors.background_grey,
            body: Container(
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    _header(),
                    _writeTicketText('录单'),
                    _gridContent(),
                    _writeTicketText('物流处理'),
                    _gridExpressContent(),
                    _writeTicketText('标本箱处理'),
                    _gridBoxContent(),
                    _writeTicketText('其他'),
                    _gridOtherContent()
                  ],
                ),
              ),
            )));
  }

  // 头部，包含标题和轮播图
  Widget _header() {
    return new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                ImageHelper.wrapAssets('main_background.png'),
              ),
              fit: BoxFit.fitWidth)),
      child: new Column(
        children: <Widget>[_headerContent(), _headerSwiper()],
      ),
    );
  }

  //头部组件
  Widget _headerContent() {
    return new Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(200),
          bottom: ScreenUtil().setHeight(40),
          right: ScreenUtil().setHeight(40),
          left: ScreenUtil().setHeight(40)),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
//			  alignment: Alignment.centerLeft,
              child: Text(
                '华银物流',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(48),
                    fontWeight: FontWeight.w600),
              ),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(440))),
          new Container(
//			  alignment: Alignment.centerLeft,
              child: Text(
            // TODO 之后从接口获取数据
            '外勤:张三', // 先写死
            maxLines: 1,
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.w300),
          ))
        ],
      ),
    );
  }

  Widget _writeTicketText(String text) {
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

  // 扫码框
  Widget _headerInput() {
    return Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(66)),
      child: new Row(
        children: <Widget>[
          new Container(
            width: ScreenUtil().setWidth(820),
            height: ScreenUtil().setHeight(108),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(94)),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: new TextField(
              style: TextStyle(
                color: Color.fromRGBO(255, 254, 254, 1),
                fontSize: ScreenUtil().setSp(42),
              ),
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.visiblePassword,
              //inputFormatters:[WhitelistingTextInputFormatter.digitsOnly],//只允许输入数字
              textInputAction: TextInputAction.search,
              cursorColor: Color.fromRGBO(255, 254, 254, 0.6),
              decoration: InputDecoration(
                  hintText: "请扫描或者输入条码号",
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(255, 254, 254, 0.8),
                    fontSize: ScreenUtil().setSp(42),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: ScreenUtil().setWidth(60),
                    color: Color.fromRGBO(214, 243, 255, 0.8),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  counterText: ''),
              maxLength: 12,
              onSubmitted: (v) {
                Navigator.pushNamed(context, RouteName.specimenStatusInquiry,
                    arguments: {'barCode': v.toString()});
              },
            ),
          ),
          new Container(
            width: ScreenUtil().setWidth(122),
            height: ScreenUtil().setHeight(108),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(28)),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      ImageHelper.wrapAssets('home_scan.png'),
                    ),
                    fit: BoxFit.contain)),
            child: FlatButton(
              onPressed: () {
                var p = new BarcodeScanner(success: (String code) {
                  if (code == '-1') return;
                  Future.delayed(Duration(milliseconds: 400), () {
                    Navigator.pushNamed(
                        context, RouteName.specimenStatusInquiry,
                        arguments: {'barCode': code});
                  });
                });
                p.scanBarcodeNormal();
              },
              splashColor: Color.fromRGBO(0, 146, 200, 0.6),
              child: Text(''),
            ),
          )
        ],
      ),
    );
  }

  Widget _headerSwiper() {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
      //设置背景底色透明
      clipBehavior: Clip.antiAlias,
      decoration: new BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(26)))),
      width: ScreenUtil.screenWidth,
      height: ScreenUtil().setHeight(630),
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: new ExactAssetImage(
                        ImageHelper.wrapAssets('upload01.png')),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(20)))),
          );
        },
        autoplay: true,
        itemCount: 1,
        autoplayDelay: 4000,
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                activeColor: Color.fromRGBO(220, 230, 236, 1),
                color: Color.fromRGBO(0, 46, 128, 1),
                size: 6,
                activeSize: 6)),
      ),
    );
  }

  //组件
  Widget _gridContent() {
    return new Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
      decoration: new BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(26))),
          color: Colors.white),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _gridCheckItem(
              text: '简易录单',
              img: 'main_simple_write.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.easyRecord);
              }),
          _gridCheckItem(
              text: '批量录单',
              img: 'main_batch_write.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.mutilRecord);
              }),
          _gridCheckItem(
              text: '交接单',
              img: 'main_transfer.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.deliveryReceipt);
              }),
          _gridCheckItem(
              text: '已录条码',
              img: 'main_write_code.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.recordedCode);
              }),
          _gridCheckItem(
              text: '单据拍照',
              img: 'main_ticket_picture.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.documentaryTakephone);
              })
        ],
      ),
    );
  }

  // 物流处理组件
  Widget _gridExpressContent() {
    return new Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
      decoration: new BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20))),
        color: DiyColors.background_grey,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _gridExpressItem(
              text: '标本箱发出',
              img: 'main_express_send.png',
              count: 12,
              routerPush: () {
                Navigator.pushNamed(context, RouteName.easyRecord);
              },
              color: DiyColors.heavy_orange),
          _gridExpressItem(
              text: '中转取件',
              img: 'main_express_transfer.png',
              count: 24,
              routerPush: () {
                print("????DSfsfsdfds");
                Navigator.pushNamed(context, RouteName.transferPicker);
              },
              color: DiyColors.thin_orange),
          _gridExpressItem(
              text: '标本箱送达',
              img: 'main_express_arrive.png',
              count: 8,
              routerPush: () {
                Navigator.pushNamed(context, RouteName.transferPicker);
              },
              color: DiyColors.heavy_green)
        ],
      ),
    );
  }

  // 标本箱处理组件
  Widget _gridBoxContent() {
    return new Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
      decoration: new BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20))),
        color: Colors.white,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _gridBoxItem(
              text: '标本箱合箱',
              img: 'main_merge_box.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.easyRecord);
              }),
          _gridBoxItem(
              text: '标本箱交接',
              img: 'main_hand_box.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.mutilRecord);
              }),
          _gridBoxItem(
              text: '标本箱接收',
              img: 'main_receive_box.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.transferPicker);
              })
        ],
      ),
    );
  }

  // 其他组件
  Widget _gridOtherContent() {
    return new Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.all(ScreenUtil().setWidth(40)),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(30), right: ScreenUtil().setWidth(30)),
      decoration: new BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20))),
        color: Colors.white,
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _gridOtherItem(
              text: '事件管理',
              img: 'main_issue_manage.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.easyRecord);
              }),
          _greyLine(),
          _gridOtherItem(
              text: '单据审核',
              img: 'main_ticket_examine.png',
              routerPush: () {
                Navigator.pushNamed(context, RouteName.mutilRecord);
              })
        ],
      ),
    );
  }

  Widget _greyLine() {
    return new Container(
        width: ScreenUtil.screenWidth - 100,
        height: ScreenUtil().setHeight(5),
        decoration: new BoxDecoration(color: DiyColors.line_grey));
  }

  Widget _gridOtherItem({String img, String text, Function() routerPush}) {
    return new Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(30)),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
            child: new Image(
                width: ScreenUtil().setWidth(90),
                height: ScreenUtil().setWidth(90),
                image: new AssetImage(ImageHelper.wrapAssets(img)),
                fit: BoxFit.fill),
          ),
          new Text(text = text,
              style: TextStyle(
                  color: DiyColors.normal_black,
                  fontSize: ScreenUtil().setSp(44),
                  fontWeight: FontWeight.w700))
        ],
      ),
    );
  }

  // 标本箱处理item
  Widget _gridBoxItem({String img, String text, Function() routerPush}) {
    return new Container(
      height: ScreenUtil().setHeight(260),
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            child: new Image(
                width: ScreenUtil().setWidth(90),
                height: ScreenUtil().setWidth(90),
                image: new AssetImage(ImageHelper.wrapAssets(img)),
                fit: BoxFit.fill),
          ),
          new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(text = text,
                    style: TextStyle(
                        color: DiyColors.normal_black,
                        fontSize: ScreenUtil().setSp(40))),
                new Text(text = '辅助文案',
                    style: TextStyle(
                        color: DiyColors.hint,
                        fontSize: ScreenUtil().setSp(36)))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _gridExpressItem(
      {String img,
      String text,
      int count,
      Function() routerPush,
      Color color}) {
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
                child: new Text(text = text,
                    style: TextStyle(
                        color: DiyColors.normal_black,
                        fontSize: ScreenUtil().setSp(40))),
              ),
              new Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(text = count.toString(),
                        style: TextStyle(
                            color: color,
                            fontSize: ScreenUtil().setSp(42),
                            fontWeight: FontWeight.w600)),
                    new Image(
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                        image: new AssetImage(ImageHelper.wrapAssets(img)),
                        fit: BoxFit.fill)
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _gridCheckItem({String img, String text, Function() routerPush}) {
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
                    ImageHelper.wrapAssets(img),
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
