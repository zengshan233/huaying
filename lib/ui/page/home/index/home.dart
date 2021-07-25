import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/home_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:huayin_logistics/model/config_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/index/home_items.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

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
                    WriteTicketText(
                      text: '录单',
                    ),
                    _gridContent(),
                    WriteTicketText(
                      text: '物流处理',
                    ),
                    _gridExpressContent(),
                    WriteTicketText(
                      text: '标本箱处理',
                    ),
                    _gridBoxContent(),
                    WriteTicketText(
                      text: '其他',
                    ),
                    _gridOtherContent()
                  ],
                ),
              ),
            )));
  }

  /// 头部，包含标题和轮播图
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

  /// 头部组件
  Widget _headerContent() {
    MineModel model = Provider.of<MineModel>(context);
    String userName = model.user == null
        ? '未登录'
        : model.user.user == null ? '--' : model.user?.user?.name;
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
              child: Text(
            '外勤:$userName',
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

  /// 轮播图
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

  /// 录单相关组件
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
          children: homeTabsWrite
              .map((e) => GridCheckItem(
                    text: e.text,
                    imgUrl: e.imgUrl,
                    routerPush: () => Navigator.pushNamed(context, e.routeName),
                  ))
              .toList()),
    );
  }

  /// 物流处理组件
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
          children: homeTabsExpress
              .map((e) => GridExpressItem(
                    text: e.text,
                    imgUrl: e.imgUrl,
                    routerPush: () => Navigator.pushNamed(context, e.routeName),
                  ))
              .toList()),
    );
  }

  /// 标本箱处理组件
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: homeTabsBox
              .map((e) => GridBoxItem(
                    text: e.text,
                    imgUrl: e.imgUrl,
                    routerPush: () => Navigator.pushNamed(context, e.routeName),
                  ))
              .toList()),
    );
  }

  /// 其他组件
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
          children: List.generate(homeTabsOther.length, (index) {
            HomeTabsItem item = homeTabsOther[index];
            return GridOtherItem(
              text: item.text,
              imgUrl: item.imgUrl,
              showBorder: index != homeTabsOther.length - 1,
              routerPush: () => Navigator.pushNamed(context, item.routeName),
            );
          })),
    );
  }
}
