import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/net/api.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/provider/view_state.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/platform_utils.dart';
import 'package:oktoast/oktoast.dart';

const String NETWORK_ERR = '当前网络不可用，请检查你的网络设置! ';
const String NETWORK_TIMEOUT = '服务器响应超时! ';

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
            child: UnconstrainedBox(
          child: Container(
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            child: CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(DiyColors.heavy_blue)),
          ),
        )));
  }

  static KumiPopupWindow showNotice({String text = '提交成功', Function onPop}) {
    BuildContext context =
        GlobalConfig.navigatorKey.currentState.overlay.context;
    return showPop(
        context: context,
        clickDismiss: true,
        duration: 2,
        callback: onPop,
        child: Container(
            width: 120,
            height: 110,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 21),
                  child: Image.asset(
                    ImageHelper.wrapAssets('success.png'),
                    width: 38,
                    height: 38,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )));
  }

  static dismiss() {
    BuildContext context =
        GlobalConfig.navigatorKey.currentState.overlay.context;
    Navigator.pop(context);
  }

  static String toast(String message) {
    message = message.contains('SocketException') ? NETWORK_ERR : message;
    message = message.contains('CONNECT_TIMEOUT') ? NETWORK_TIMEOUT : message;
    showToast(message.toString());
    return message;
  }

  static String showError(e, stackTrace,
      {String message, bool errState = true}) {
    if (e?.response?.statusCode == 401) {
      return null;
    }
    ViewStateErrorType errorType = ViewStateErrorType.defaultError;
    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        // timeout
        errorType = ViewStateErrorType.networkTimeOutError;
        message = e.error;
      } else if (e.type == DioErrorType.response) {
        // incorrect status, such as 404, 503...
        message = e.error;
      } else if (e.type == DioErrorType.cancel) {
        // to be continue...
        message = e.error;
      } else {
        // dio将原error重新套了一层
        e = e.error;
        if (e is UnAuthorizedException) {
          stackTrace = null;
          errorType = ViewStateErrorType.unauthorizedError;
        } else if (e is NotSuccessException) {
          stackTrace = null;
          message = e.message;
        } else if (e is SocketException) {
          errorType = ViewStateErrorType.networkTimeOutError;
          message = e.message;
        } else {
          message = e?.message ?? e.toString();
        }
      }
    }
    ViewStateError viewStateError = ViewStateError(
      errorType,
      message: message,
      errorMessage: e.toString(),
    );
    if (viewStateError.isNetworkTimeOut) {
      message ??= "当前网络不可用，请检查你的网络设置！";
    } else {
      message ??= viewStateError.message;
    }
    return toast(message);
  }

  /// 显示错误消息
  showErrorMessage(context, {String message}) {}

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
