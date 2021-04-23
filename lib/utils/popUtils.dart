import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';

class PopUtils {
  static Color themeColor;
  static Color theme2Color;
  static Color fontColor;
  static KumiPopupWindow showPop(
      {Widget child,
      BuildContext context,
      double opacity,
      int duration = -1,
      Function callback,
      Widget Function(KumiPopupWindow popup) childFun,
      bool animated = true,
      bool clickDismiss = false}) {
    context = context ?? GlobalConfig.navigatorKey.currentState.overlay.context;
    return showPopupWindow(
      context,
      gravity: KumiPopupGravity.center,
      bgColor: Colors.black.withOpacity(opacity == null ? 0 : opacity),
      clickOutDismiss: clickDismiss,
      clickBackDismiss: clickDismiss,
      duration: Duration(milliseconds: animated ? 200 : 0),
      onClickOut: (p) {
        print("onClickOut");
      },
      childFun: (pop) {
        if (duration > 0) {
          Timer(Duration(seconds: duration), () async {
            await pop.dismiss(context);
            if (callback != null) {
              callback();
            }
          });
        }
        Widget _child = child;
        if (childFun != null) {
          _child = childFun(pop);
        }
        return Container(
          key: GlobalKey(),
          child: _child,
        );
      },
    );
  }

  static KumiPopupWindow showLoading([BuildContext context]) {
    return showPop(
        context: context,
        clickDismiss: true,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(DiyColors.heavy_blue),
            ),
          ),
        ));
  }

  static void toast(
      {BuildContext context,
      String message,
      Function callback,
      String align,
      double distance}) {
    AlignmentGeometry alignment;
    Widget infoWidget = Container(
        child: DecoratedBox(
            decoration: BoxDecoration(
                color: Color.fromRGBO(17, 17, 17, 0.7),
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Padding(
                padding: EdgeInsets.only(
                    top: 6.0, right: 18.0, bottom: 6.0, left: 18.0),
                child: DefaultTextStyle(
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                    textAlign: TextAlign.center,
                    child: toTextWidget(message, 'message')))));

    // 判断对齐方式
    switch (align) {
      case 'top':
        alignment = Alignment.topCenter;
        infoWidget =
            Padding(padding: EdgeInsets.only(top: distance), child: infoWidget);
        break;
      case 'bottom':
        alignment = Alignment.bottomCenter;
        infoWidget = Padding(
            padding: EdgeInsets.only(bottom: distance), child: infoWidget);
        break;
      default:
        alignment = Alignment.center;
        break;
    }

    showPop(
        callback: callback,
        duration: 2,
        clickDismiss: true,
        child: Material(
            type: MaterialType.transparency, //透明类型
            child: Align(alignment: alignment, child: infoWidget)));
  }

  static showTip(
      {String title, Function confirm, String message, String confirmText}) {
    BuildContext context =
        GlobalConfig.navigatorKey.currentState.overlay.context;
    return showPop(
        opacity: 0.3,
        clickDismiss: true,
        childFun: (pop) => Container(
              width: ScreenUtil().setWidth(800),
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Column(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(800),
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(30),
                        bottom: ScreenUtil().setHeight(30),
                        left: ScreenUtil().setHeight(30)),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: GlobalConfig.borderColor,
                              width: 1.5 / ScreenUtil.pixelRatio)),
                    ),
                    child: Text(
                      title ?? '',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(44),
                        color: Color.fromRGBO(90, 90, 90, 1),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(50),
                        horizontal: ScreenUtil().setWidth(50)),
                    alignment: Alignment.center,
                    child: Text(message),
                  ),
                  new Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(50)),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(30)),
                    child: gradualButton(confirmText ?? '确定', onTap: () {
                      if (confirm != null) {
                        Navigator.pop(context);
                        confirm();
                      } else {
                        pop.dismiss(context);
                      }
                    }),
                  )
                ],
              ),
            ));
  }
}

// 字符串转Widget
Widget toTextWidget(content, key) {
  if (content == null) return null;
  // 判断是字符串或者是widget
  if (content is Widget == false && content is String == false) {
    throw new FormatException('$key类型只能为String || Widget');
  }

  if (content is String) {
    return Text(content);
  }

  return content;
}
