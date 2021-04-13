import 'dart:async';
import 'package:flutter/material.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';

class PopUtils {
  static Color themeColor;
  static Color theme2Color;
  static Color fontColor;
  static void showPop(
      {Widget child,
      double opacity,
      int duration = -1,
      Function callback,
      Widget Function(KumiPopupWindow popup) childFun,
      BuildContext context,
      bool clickDismiss = false}) {
    showPopupWindow(
      context,
      gravity: KumiPopupGravity.center,
      bgColor: Colors.black.withOpacity(opacity == null ? 0 : opacity),
      clickOutDismiss: clickDismiss,
      clickBackDismiss: clickDismiss,
      duration: Duration(milliseconds: 200),
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
        context: context,
        callback: callback,
        duration: 2,
        clickDismiss: true,
        child: Material(
            type: MaterialType.transparency, //透明类型
            child: Align(alignment: alignment, child: infoWidget)));
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
