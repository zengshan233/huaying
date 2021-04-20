import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

Widget appBarWithName(BuildContext context, String title, String name,
    {Widget rightWidget, bool withName = false}) {
  MineModel model = Provider.of<MineModel>(context);
  String userName = model.user == null
      ? '未登录'
      : model.user.user == null ? '--' : model.user?.user?.name;
  return AppBar(
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    title: Text(title,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(48),
            fontWeight: FontWeight.w600,
            color: DiyColors.normal_black)),
    centerTitle: true,
    leading: GestureDetector(
      child: new Container(
        child: Center(
            child: Image.asset(
          ImageHelper.wrapAssets('left_back.png'),
          color: Colors.black,
          width: ScreenUtil().setHeight(90),
          height: ScreenUtil().setHeight(90),
          fit: BoxFit.fill,
        )),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    ),
    actions: <Widget>[
      rightWidget != null
          ? rightWidget
          : Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
              child: new Text(
                '$name${withName ? userName : ''}',
                style: TextStyle(
                    color: DiyColors.heavy_blue,
                    fontSize: ScreenUtil().setSp(42)),
              ),
            )
    ],
  );
}

Widget radiusButton({String text, String img}) {
  return Container(
    padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
    width: ScreenUtil().setWidth(190),
    decoration: BoxDecoration(
        border: Border.all(color: DiyColors.heavy_blue, width: 1),
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(40)))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Image(
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setWidth(50),
            image: new AssetImage(ImageHelper.wrapAssets(img)),
            fit: BoxFit.fill),
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
          child: new Text(text,
              style: TextStyle(
                  color: DiyColors.heavy_blue,
                  fontSize: ScreenUtil().setSp(36))),
        )
      ],
    ),
  );
}

//appbar头部
Widget appBarComon(BuildContext context,
    {String text = '', Widget leading, Widget rightWidget}) {
  return GradientAppBar(
    title: Text(
      text,
      style: TextStyle(fontSize: ScreenUtil().setSp(48)),
    ),
    centerTitle: true,
    gradient: LinearGradient(colors: [
      Color.fromRGBO(56, 219, 254, 1),
      Color.fromRGBO(38, 181, 247, 1),
      Color.fromRGBO(21, 145, 241, 1),
    ]),
    leading: leading != null
        ? leading
        : IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
    actions: <Widget>[rightWidget != null ? rightWidget : SizedBox()],
  );
}

//渐变按钮
Widget gradualButton(String text, {Function onTap}) {
  return new PhysicalModel(
    color: Colors.white,
    //设置背景底色透明
    borderRadius: BorderRadius.all(Radius.circular(10)),
    clipBehavior: Clip.antiAlias,
    //注意这个属性
    elevation: 4,
    shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
    child: Container(
      width: ScreenUtil().setWidth(800),
      height: ScreenUtil().setHeight(150),
      decoration: BoxDecoration(
        gradient: LinearGradient(//背景径向渐变
            colors: [
          Color.fromRGBO(42, 192, 255, 1),
          Color.fromRGBO(35, 177, 250, 1),
          Color.fromRGBO(21, 145, 241, 1)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: FlatButton(
        onPressed: () {
          onTap();
        },
        child: new Text(
          text,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(46),
              color: Colors.white,
              letterSpacing: 1),
        ),
      ),
    ),
  );
}

//录单卡片
Widget recordCard(
    {String title,
    Widget titleRight,
    @required List<Color> colors,
    Widget contentWidget}) {
  return new Container(
    margin: EdgeInsets.only(top: ScreenUtil().setHeight(34)),
    padding: EdgeInsets.only(left: ScreenUtil().setWidth(60)),
    child: new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: ScreenUtil().setWidth(30),
          height: ScreenUtil().setHeight(80),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              boxShadow: [
                BoxShadow(
                    color: colors[0], offset: Offset(0, 2.0), blurRadius: 3.0)
              ]),
        ),
        new PhysicalModel(
          color: Colors.white,
          //设置背景底色透明
          borderRadius: BorderRadius.all(Radius.circular(10)),
          clipBehavior: Clip.antiAlias,
          //注意这个属性
          elevation: 4,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
          child: SingleChildScrollView(
              child: new Container(
                  width: ScreenUtil().setWidth(945),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(36)),
                  //外层padding
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        height: ScreenUtil().setHeight(116),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: GlobalConfig.borderColor,
                                    width: 1 / ScreenUtil.pixelRatio))),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              title,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(44),
                                  color: Color.fromRGBO(90, 90, 91, 1)),
                            ),
                            titleRight == null ? new SizedBox() : titleRight
                          ],
                        ),
                      ),
                      contentWidget == null ? new SizedBox() : contentWidget
                    ],
                  ))),
        )
      ],
    ),
  );
}

//简易录单输入框
Widget simpleRecordInput(BuildContext context,
    {Widget rightWidget,
    String preText,
    String hintText,
    bool needBorder = true,
    Function onChange,
    Function onTap,
    TextEditingController onController,
    bool enbleInput = true,
    TextInputType keyType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.none,
    Function onSubmitted,
    int maxLength = 200}) {
  return new Container(
    height: ScreenUtil().setHeight(140),
    decoration: BoxDecoration(
        border: Border(
            bottom: needBorder
                ? BorderSide(
                    color: GlobalConfig.borderColor,
                    width: 1 / ScreenUtil.pixelRatio,
                  )
                : BorderSide.none)),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(preText, style: TextStyle(fontSize: ScreenUtil().setSp(40))),
        new Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            new Container(
              color: Colors.transparent,
              width: ScreenUtil().setWidth(776),
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
//              padding: EdgeInsets.only(right: ScreenUtil().setWidth(140)),
              child: new TextField(
                key: UniqueKey(),
                textInputAction: textInputAction,
                keyboardType: keyType,
                inputFormatters: keyType == TextInputType.number
                    ? [
                        WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                      ]
                    : [],
                //只允许输入数字
                onSubmitted: onSubmitted,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(40), color: Color(0xFF333333)),
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        color: Color.fromRGBO(211, 211, 211, 1),
                        height: 1.4),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    counterText: ""),
                enableInteractiveSelection: enbleInput,
                //禁止输入
                onTap: () {
                  onTap?.call();
                  enbleInput
                      ? (() {})()
                      : FocusScope.of(context).requestFocus(new FocusNode());
                },
                onChanged: (v) {
                  /// 手动实现输入框的maxLength属性，解决原maxLength设置输入满后，难以再次唤起键盘输入的问题
                  if (maxLength != null && v.length > maxLength) {
                    String text = onController.text;
                    onController.text = text.substring(0, text.length - 1);
                    onController.selection = TextSelection(
                        baseOffset: maxLength, extentOffset: maxLength);
                  }
                  onChange?.call(onController.text);
                },
                controller: onController,
              ),
            ),
            new Positioned(
                right: 0, child: rightWidget == null ? SizedBox() : rightWidget)
          ],
        )
      ],
    ),
  );
}

//录单输入框
Widget recordInput(BuildContext context,
    {Widget rightWidget,
    String preText,
    String hintText,
    bool isRquire = true,
    bool needBorder = true,
    Function onChange,
    Function onTap,
    TextEditingController onController,
    bool enbleInput = true,
    TextInputType keyType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.none,
    Function onSubmitted,
    int maxLength = 200}) {
  return new Container(
    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
    height: ScreenUtil().setHeight(134),
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: needBorder
                ? BorderSide(
                    color: GlobalConfig.borderColor,
                    width: 1 / ScreenUtil.pixelRatio)
                : BorderSide.none)),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text.rich(TextSpan(children: [
          TextSpan(
              text: isRquire ? "*" : '',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(46),
                  color: Color.fromRGBO(234, 44, 67, 1))),
          TextSpan(
              text: preText,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(40),
                  color: Color.fromRGBO(90, 90, 91, 1)))
        ])),
        new Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            new Container(
              width: ScreenUtil().setWidth(776),
              padding: EdgeInsets.only(right: ScreenUtil().setWidth(140)),
              child: new TextField(
                key: UniqueKey(),
                textInputAction: textInputAction,
                keyboardType: keyType,
                inputFormatters: keyType == TextInputType.number
                    ? [WhitelistingTextInputFormatter.digitsOnly]
                    : [],
                //只允许输入数字
                onSubmitted: onSubmitted,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(40), color: Color(0xFF666666)),
                decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        color: Color.fromRGBO(211, 211, 211, 1),
                        height: 1.4),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    counterText: ""),
                enableInteractiveSelection: enbleInput,
                //禁止输入
                maxLength: maxLength,
                onTap: () {
                  onTap?.call();
                  enbleInput
                      ? (() {})()
                      : FocusScope.of(context).requestFocus(new FocusNode());
                },
                onChanged: (v) {
                  onChange?.call(v);
                },
                controller: onController,
              ),
            ),
            new Positioned(
                right: 0, child: rightWidget == null ? SizedBox() : rightWidget)
          ],
        )
      ],
    ),
  );
}

//单个体检项目
Widget singleProgect(String text, {Function delTap, Key key}) {
  return new Container(
    key: key == null ? UniqueKey() : key,
    height: ScreenUtil().setHeight(100),
    child: new Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Positioned(
          child: new Container(
            height: ScreenUtil().setHeight(76),
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            margin: EdgeInsets.only(right: ScreenUtil().setHeight(30)),
            constraints: BoxConstraints(
              minWidth: ScreenUtil().setWidth(200),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromRGBO(0, 150, 255, 1)),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: SingleChildScrollView(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(38),
                    color: Color.fromRGBO(0, 117, 255, 1),
                  ),
                )
              ],
            )),
          ),
        ),
        new Positioned(
          top: 0,
          right: 0,
          child: new Container(
            width: ScreenUtil().setHeight(80),
            height: ScreenUtil().setHeight(60),
            child: new FlatButton(
                //color: Colors.red,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  delTap?.call();
                },
                child: new Image.asset(
                  ImageHelper.wrapAssets('record_del.png'),
                  width: ScreenUtil().setHeight(50),
                  height: ScreenUtil().setHeight(50),
                )),
          ),
        )
      ],
    ),
  );
}

//列表头部
Widget listTitleDecoration(
    {String title,
    @required List<Color> colors,
    Widget widget,
    EdgeInsetsGeometry customPadding}) {
  return new Container(
    padding: customPadding ?? EdgeInsets.only(left: ScreenUtil().setWidth(55)),
    child: new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          width: ScreenUtil().setWidth(30),
          height: ScreenUtil().setHeight(80),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(24)),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              boxShadow: [
                BoxShadow(
                    color: colors[0], offset: Offset(0, 2.0), blurRadius: 3.0)
              ]),
        ),
        new PhysicalModel(
            color: Colors.white,
            //设置背景底色透明
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            clipBehavior: Clip.antiAlias,
            //注意这个属性
            elevation: 0.1,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
            child: new Container(
              width: ScreenUtil().setWidth(955),
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30)), //外层padding
              child: new Container(
                height: ScreenUtil().setHeight(116),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: GlobalConfig.borderColor,
                          width: 1 / ScreenUtil.pixelRatio)),
                ),
                child: new Row(
                  children: <Widget>[
                    new Offstage(
                      offstage: title == null,
                      child: new Text(
                        title.toString(),
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(44),
                            color: Color.fromRGBO(90, 90, 91, 1)),
                      ),
                    ),
                    widget != null ? widget : Offstage()
                  ],
                ),
              ),
            ))
      ],
    ),
  );
}

//提示toast
ToastFuture showMsgToast(message, {BuildContext context}) {
  return showToast(message,
      context: context,
      position: ToastPosition.bottom,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
      radius: 2);
}

//无数据提示
Widget noDataWidget({String text = '暂无数据'}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
    child: Column(
      children: <Widget>[
        Image.asset(
          ImageHelper.wrapAssets('no_data.png'),
          height: ScreenUtil().setHeight(240),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(38),
              color: Color.fromRGBO(90, 90, 90, 0.2),
              fontWeight: FontWeight.w600),
        )
      ],
    ),
  );
}
