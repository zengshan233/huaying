import 'package:flutter/material.dart';

import 'PopRoute.dart';

KumiPopupWindow showPopupWindow<T>(
  BuildContext context, {
  Widget Function(KumiPopupWindow popup) childFun,
  KumiPopupGravity gravity,
  bool customAnimation,
  bool customPop,
  bool customPage,
  Color bgColor,
  RenderBox targetRenderBox,
  Size childSize,
  bool underStatusBar,
  bool underAppBar,
  bool clickOutDismiss,
  bool clickBackDismiss,
  double offsetX,
  double offsetY,
  Duration duration,
  Function(KumiPopupWindow popup) onShowStart,
  Function(KumiPopupWindow popup) onShowFinish,
  Function(KumiPopupWindow popup) onDismissStart,
  Function(KumiPopupWindow popup) onDismissFinish,
  Function(KumiPopupWindow popup) onClickOut,
  Function(KumiPopupWindow popup) onClickBack,
}) {
  var popup = KumiPopupWindow(
    gravity: gravity,
    customAnimation: customAnimation,
    customPop: customPop,
    customPage: customPage,
    bgColor: bgColor,
    childFun: childFun,
    targetRenderBox: targetRenderBox,
    childSize: childSize,
    underStatusBar: underStatusBar,
    underAppBar: underAppBar,
    clickOutDismiss: clickOutDismiss,
    clickBackDismiss: clickBackDismiss,
    offsetX: offsetX,
    offsetY: offsetY,
    duration: duration,
    onShowStart: onShowStart,
    onShowFinish: onShowFinish,
    onDismissStart: onDismissStart,
    onDismissFinish: onDismissFinish,
    onClickOut: onClickOut,
    onClickBack: onClickBack,
  );
  popup.show(context);
  return popup;
}

KumiPopupWindow createPopupWindow<T>(
  BuildContext context, {
  Widget Function(KumiPopupWindow popup) childFun,
  KumiPopupGravity gravity,
  bool customAnimation,
  bool customPop,
  bool customPage,
  Color bgColor,
  RenderBox targetRenderBox,
  Size childSize,
  bool underStatusBar,
  bool underAppBar,
  bool clickOutDismiss,
  bool clickBackDismiss,
  double offsetX,
  double offsetY,
  Duration duration,
  Function(KumiPopupWindow popup) onShowStart,
  Function(KumiPopupWindow popup) onShowFinish,
  Function(KumiPopupWindow popup) onDismissStart,
  Function(KumiPopupWindow popup) onDismissFinish,
  Function(KumiPopupWindow popup) onClickOut,
  Function(KumiPopupWindow popup) onClickBack,
}) {
  return KumiPopupWindow(
    gravity: gravity,
    customAnimation: customAnimation,
    customPop: customPop,
    customPage: customPage,
    bgColor: bgColor,
    childFun: childFun,
    targetRenderBox: targetRenderBox,
    childSize: childSize,
    underStatusBar: underStatusBar,
    underAppBar: underAppBar,
    clickOutDismiss: clickOutDismiss,
    clickBackDismiss: clickBackDismiss,
    offsetX: offsetX,
    offsetY: offsetY,
    duration: duration,
    onShowStart: onShowStart,
    onShowFinish: onShowFinish,
    onDismissStart: onDismissStart,
    onDismissFinish: onDismissFinish,
    onClickOut: onClickOut,
    onClickBack: onClickBack,
  );
}

// ignore: must_be_immutable
class KumiPopupWindow extends StatefulWidget {
  /// ?????????????????????????????????????????????widget??????????????????????????????????????????[_child]
  /// ??????[_childSize] == null???????????????????????????????????????[_child]??????????????????[_childSize]
  /// Method for customizing the content of the popup window. The returned widget will be used as the content of the popup window, and then assigned to [_child]
  /// If [_childSize] == null, the size of [_child] will be assigned to [_childSize] when the drawing is completed
  final Widget Function(KumiPopupWindow popup) _childFun;

  ///????????????????????????
  ///????????? [KumiPopupGravity.center]
  /// ??????[_targetRenderBox] == null???????????????????????????????????????????????????
  /// ??????[_targetRenderBox] != null????????????????????????????????????????????????widget
  /// Relative position of the pop-up window.
  /// The default is [KumiPopupGravity.center]
  /// If [_targetRenderBox] == null, then the position of the pop-up window is relative to the screen.
  /// If [_targetRenderBox]! = Null, then the position of the popup window is relative to the target widget
  final KumiPopupGravity _gravity;

  /// ?????????popupWindow?????????
  /// ?????????false???
  /// ?????????true?????????????????????????????????????????????[_childFun]?????????widget???????????????
  /// Custom popupWindow animation
  ///The default is false.
  ///If true, then the default animation is invalid at this time, you need to customize the animation for the widget returned by [_childFun]
  final bool _customAnimation;

  ///?????????popupWindow??????????????????
  /// ?????????false???
  /// ?????????true???????????????[_gravity]????????????????????????????????????[_childFun]?????????widget????????????????????????
  /// Customize the position and animation of popupWindow
  ///The default is false.
  ///If true, then both [_gravity] and the default animation are invalid. You need to customize the position and animation for the widget returned by [_childFun]
  final bool _customPop;

  /// ??????????????????????????????[Scaffold]
  /// ?????????false???
  /// ?????????true????????????[_childFun]?????????widget?????????????????????
  /// Customize the entire page, including [Scaffold]
  ///The default is false.
  ///If true, you need to customize the entire page for the widget returned by [_childFun]
  final bool _customPage;

  ///??????????????????
  ///?????????[Colors.black].withOpacity(0.5)
  ///The color of the mask layer
  ///The default is [Colors.black].withOpacity(0.5)
  final Color _bgColor;

  ///??????widget???[RenderBox]
  ///?????????null
  ///???????????????????????????widget??????????????????
  ///?????????[_gravity]?????????
  ///[RenderBox] of the target widget
  ///The default is  null
  ///Get the position and size of the target widget through this property
  ///See the description of [_gravity]
  final RenderBox _targetRenderBox;

  ///???????????????????????????statusBar??????
  ///?????????false
  ///When the top pops up, is it below the statusBar
  ///The default is false
  final bool _underStatusBar;

  ///???????????????????????????AppBar??????
  ///?????????false
  ///When the top pops up, is it below the AppBar
  ///The default is false
  final bool _underAppBar;

  ///??????????????????????????????????????????
  ///?????????true
  ///Click outside the pop-up window to dismiss
  ///The default is true
  final bool _clickOutDismiss;

  ///????????????????????????????????????
  ///?????????true
  ///Click the physical back button to dismiss
  ///The default is true
  final bool _clickBackDismiss;

  ///????????????????????????
  ///?????????0.0
  /// ?????? [_offsetX] > 0???????????????
  /// ?????? [_offsetX] < 0???????????????
  ///Offset at horizontal axis edge
  ///The default is 0.0
  ///If [_offsetX] > 0, offset to the right
  ///If [_offsetX] < 0, offset to the left
  final double _offsetX;

  ///????????????????????????
  ///?????????0.0
  /// ?????? [_offsetY] > 0???????????????
  /// ?????? [_offsetY] < 0???????????????
  ///Offset at vertical axis edge
  ///The default is 0.0
  ///If [_offsetY] > 0, offset to the down
  ///If [_offsetY] < 0, offset to the up
  final double _offsetY;

  ///???????????????
  ///????????? 200ms
  ///Duration of the animation
  ///The default is 200ms
  final Duration _duration;

  ///???????????????????????????
  /// When the popupWindow show animation start
  final Function(KumiPopupWindow popup) _onShowStart;

  ///???????????????????????????
  /// When the popupWindow show animation finish
  final Function(KumiPopupWindow popup) _onShowEnd;

  ///???????????????????????????
  /// When the popupWindow dismiss animation start
  final Function(KumiPopupWindow popup) _onDismissStart;

  ///???????????????????????????
  /// When the popupWindow dismiss animation finish
  final Function(KumiPopupWindow popup) _onDismissEnd;

  ///???????????????????????????
  ///?????????[_clickOutDismiss] == false ?????????
  /// Click on the listener outside the popup
  /// Only works when [_clickOutDismiss] == false
  final Function(KumiPopupWindow popup) _onClickOut;

  ///?????????????????????????????????
  ///?????????[_clickBackDismiss] == false ?????????
  /// Listening on clicking the physical back button
  /// Only works when [_clickBackDismiss] == false
  final Function(KumiPopupWindow popup) _onClickBack;

  ///??????????????????
  ///?????????null????????????????????????????????????????????????
  /// PopupWindow  size
  /// If null, it will be calculated and assigned after drawing
  Size _childSize;

  ///????????????widget
  ///[_childFun]?????????widget
  ///Popup window widget
  ///[_childFun] Returned widget
  Widget _child;

  Widget get child => _child;

  ///???????????????
  //AnimationController
  AnimationController _controller;

  AnimationController get controller => _controller;

  KumiPopupWindow({
    @required Widget Function(KumiPopupWindow popup) childFun,
    KumiPopupGravity gravity,
    bool customAnimation,
    bool customPop,
    bool customPage,
    Color bgColor,
    RenderBox targetRenderBox,
    Size childSize,
    bool underStatusBar,
    bool underAppBar,
    bool clickOutDismiss,
    bool clickBackDismiss,
    double offsetX,
    double offsetY,
    Duration duration,
    Function(KumiPopupWindow popup) onShowStart,
    Function(KumiPopupWindow popup) onShowFinish,
    Function(KumiPopupWindow popup) onDismissStart,
    Function(KumiPopupWindow popup) onDismissFinish,
    Function(KumiPopupWindow popup) onClickOut,
    Function(KumiPopupWindow popup) onClickBack,
  })  : _childFun = childFun,
        _gravity = gravity ?? KumiPopupGravity.center,
        _customAnimation = customAnimation ?? false,
        _customPop = customPop ?? false,
        _customPage = customPage ?? false,
        _bgColor = bgColor ?? Colors.black.withOpacity(0.5),
        _targetRenderBox = targetRenderBox,
        _childSize = childSize,
        _underStatusBar = underStatusBar ?? false,
        _underAppBar = underAppBar ?? false,
        _clickOutDismiss = clickOutDismiss ?? true,
        _clickBackDismiss = clickBackDismiss ?? true,
        _offsetX = offsetX ?? 0,
        _offsetY = offsetY ?? 0,
        _duration = duration ?? Duration(milliseconds: 200),
        _onShowStart = onShowStart,
        _onShowEnd = onShowFinish,
        _onDismissStart = onDismissStart,
        _onDismissEnd = onDismissFinish,
        _onClickOut = onClickOut,
        _onClickBack = onClickBack;

  @override
  _KumiPopupWindowState createState() => _KumiPopupWindowState();

  ///????????????
  ///popup window dismiss
  Future dismiss(BuildContext context,
      {bool notStartAnimation, Function(KumiPopupWindow pop) onFinish}) async {
    _isShow = false;
    if (notStartAnimation == true) {
      Navigator.pop(context);
      if (onFinish != null) {
        onFinish(this);
      }
      return;
    }
    await _controller.reverse();
    Navigator.pop(context);
    if (onFinish != null) {
      onFinish(this);
    }
  }

  ///????????????
  ///popup window show
  Future show(BuildContext context) async {
    Navigator.push(
      context,
      PopRoute(
        child: this,
      ),
    );
    _isShow = true;
  }

  bool _isShow;

  bool get isShow => _isShow;
}

class _KumiPopupWindowState extends State<KumiPopupWindow>
    with SingleTickerProviderStateMixin {
  Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    widget._controller =
        AnimationController(duration: widget._duration, vsync: this);
    widget._controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          if (widget._onShowStart != null) {
            widget._onShowStart(widget);
          }
          break;
        case AnimationStatus.dismissed:
          if (widget._onDismissEnd != null) {
            widget._onDismissEnd(widget);
          }
          break;
        case AnimationStatus.reverse:
          if (widget._onDismissStart != null) {
            widget._onDismissStart(widget);
          }
          break;
        case AnimationStatus.completed:
          if (widget._onShowEnd != null) {
            widget._onShowEnd(widget);
          }
          break;
      }
    });

    ///?????????????????????????????????????????????
    ///Save the popup window to ensure its uniqueness
    widget._child = widget._childFun(widget);

    ///????????????????????????????????????????????????????????????????????????
    ///If you have set the size of the popup window, you can start the animation directly
    if (widget._childSize != null) {
      widget._controller.forward();
    }

    ///?????????????????????
    ///Draw completed listener
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (widget._customPage) {
        widget._controller.forward();
        return;
      }
      if (widget._customPop) {
        widget._controller.forward();
        return;
      }

      ///?????????????????????????????????
      ///If the size of the popup box is not set
      if (widget._childSize == null) {
        ///??????????????????????????????????????????????????????????????????
        ///Then you can directly get the size after the popup window is drawn.
        widget._childSize =
            (widget._child.key as GlobalKey).currentContext.size;

        ///?????????????????????????????????setState??????
        ///And start the animation, must be placed in setState
        setState(() {
          widget._controller.forward();
        });
      }
    });
  }

  dispose() {
    widget._controller.dispose();
    super.dispose();
  }

  ///??????statusBar?????????
  ///Get the height of statusBar
  double _getStatusBar(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.padding.top;
  }

  ///??????statusBar???appBar????????????
  ///Get the total height of statusBar and appBar
  double _getStatusBarAndAppBarHeight(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return mediaQuery.padding.top + kToolbarHeight;
  }

  ///???????????????????????????????????????statusBar??????appBar???????????????????????????
  ///Determines whether the pop-up window needs to be displayed below the statusBar or appBar and returns the offset
  double _getTopPadding(BuildContext context) {
    return widget._underAppBar == true
        ? _getStatusBarAndAppBarHeight(context)
        : (widget._underStatusBar == true ? _getStatusBar(context) : 0);
  }

  ///???popup window????????????????????????????????????????????????popup window???x?????????
  ///When the center point of the popup window coincides with the center point of the screen, the x-axis coordinate of the popup window at this time
  double _getScreenCenterX() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    if (widget._childSize == null) {
      return mediaQuery.size.width / 2;
    }
    return (mediaQuery.size.width - widget._childSize.width) / 2;
  }

  ///???popup window????????????????????????????????????????????????popup window???y?????????
  ///When the center point of the popup window coincides with the center point of the screen, the y-axis coordinate of the popup window at this time
  double _getScreenCenterY() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    if (widget._childSize == null) {
      return mediaQuery.size.height / 2;
    }
    return (mediaQuery.size.height - widget._childSize.height) / 2;
  }

  Widget getLayout(BuildContext context) {
    ///?????????????????????????????????
    ///If you want to customize the entire page
    if (widget._customPage) {
      return WillPopScope(
          child: widget._child,
          onWillPop: () {
            if (widget._clickBackDismiss) {
              widget.dismiss(context);
            }
            return Future.value(false);
          });
    }

    ///?????????????????????popup window??????????????????
    ///If you want to customize the position and animation of the popup window
    if (widget._customPop) {
      return WillPopScope(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Positioned(
                  child: GestureDetector(
                    child: FadeTransition(
                      opacity: Tween(begin: 0.0, end: 1.0)
                          .animate(widget._controller),
                      child: Container(
                        alignment: Alignment.center,
                        color: widget._bgColor,
                      ),
                    ),
                    onTap: () {
                      if (widget._clickOutDismiss) {
                        widget.dismiss(context);
                        return;
                      }
                      if (widget._onClickOut != null) {
                        widget._onClickOut(widget);
                      }
                    },
                  ),
                ),
                widget._child,
              ],
            ),
          ),
          onWillPop: () {
            if (widget._clickBackDismiss) {
              widget.dismiss(context);
              return Future.value(false);
            }
            if (widget._onClickBack != null) {
              widget._onClickBack(widget);
            }
            return Future.value(false);
          });
    }

    ///popup window?????????widget
    ///The final widget of the popup window
    var childView;

    ///??????widget?????????
    ///The position of the target widget
    Offset targetOffset;

    ///??????widget?????????
    ///The size of the target widget
    Size targetSize;

    ///???popup window??????????????????????????????widget???????????????????????????widget??????????????????
    ///When the position of the popup window is relative to a target widget, you need to initialize the position and size of the target widget
    if (widget._targetRenderBox != null) {
      targetOffset = widget._targetRenderBox.localToGlobal(Offset.zero);
      targetSize = widget._targetRenderBox.size;
    }
    switch (widget._gravity) {
      case KumiPopupGravity.leftTop:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen???Pop up from the top left corner of the screen
          childView = Positioned(
            left: widget._offsetX,
            top: _getTopPadding(context) + widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(-1, -1), end: Offset(0, 0))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///??????????????????????????????????????????widget??????????????????
          ///If the position is relative to the target widget, pop up from the upper left corner of the target widget
          ///Before popup, the upper left corner of the popup box is aligned with the upper left corner of the target widget
          childView = Positioned(
            left: targetOffset.dx + widget._offsetX,
            top: targetOffset.dy + widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0), end: Offset(-1, -1))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        }
        break;
      case KumiPopupGravity.centerTop:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen???Pop up from the top center corner of the screen
          childView = Positioned(
            left: _getScreenCenterX() + widget._offsetX,
            top: _getTopPadding(context) + widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : SlideTransition(
                    position: Tween(begin: Offset(0, -1), end: Offset(0, 0))
                        .animate(widget._controller),
                    child: FadeTransition(
                      opacity: Tween(begin: -1.0, end: 1.0)
                          .animate(widget._controller),
                      child: widget._child,
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///???????????????????????????x?????????????????????widget???x????????????????????????????????????????????????widget???????????????
          ///If the position is relative to the target widget, pop up from directly above the target widget
          ///Before the pop-up, the x-axis center point of the popup window is aligned with the x-axis center point of the target widget, and the top of the popup window is aligned with the top of the target widget
          childView = Positioned(
            left: targetOffset.dx -
                (widget._childSize == null
                        ? 0
                        : widget._childSize.width - targetSize.width) /
                    2 +
                widget._offsetX,
            top: targetOffset.dy + widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0), end: Offset(0, -1))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        }
        break;
      case KumiPopupGravity.rightTop:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen???Pop up from the top right corner of the screen
          childView = Positioned(
            right: -widget._offsetX,
            top: _getTopPadding(context) + widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(1, -1), end: Offset(0, 0))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///?????????????????????????????????????????????widget??????????????????
          ///If the position is relative to the target widget, pop up from the upper right of the target widget
          ///Before popup, the upper right corner of the popup box is aligned with the upper right corner of the target widget
          childView = Positioned(
            left: targetOffset.dx -
                (widget._childSize == null
                    ? 0
                    : widget._childSize.width - targetSize.width) +
                widget._offsetX,
            top: targetOffset.dy + widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0), end: Offset(1, -1))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        }
        break;
      case KumiPopupGravity.leftCenter:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen, pop up from the left of the screen
          childView = Positioned(
            left: widget._offsetX,
            top: _getScreenCenterY() +
                widget._offsetY +
                _getTopPadding(context) / 2,
            child: widget._customAnimation
                ? widget._child
                : SlideTransition(
                    position: Tween(begin: Offset(-1, 0), end: Offset(0, 0))
                        .animate(widget._controller),
                    child: FadeTransition(
                      opacity: Tween(begin: -1.0, end: 1.0)
                          .animate(widget._controller),
                      child: widget._child,
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///???????????????????????????y?????????????????????widget???y????????????????????????????????????????????????widget???????????????
          ///If the position is relative to the target widget, pop up from the left of the target widget
          ///Before the pop-up, the y-axis center point of the popup window is aligned with the y-axis center point of the target widget, and the left side of the popup window is aligned with the left side of the target widget
          childView = Positioned(
            left: targetOffset.dx + widget._offsetX,
            top: targetOffset.dy -
                (widget._childSize == null
                        ? 0
                        : widget._childSize.height - targetSize.height) /
                    2 +
                widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0), end: Offset(-1, 0))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        }
        break;
      case KumiPopupGravity.center:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen, pop up from the center of the screen
          childView = Positioned(
            left: _getScreenCenterX() + widget._offsetX,
            top: _getScreenCenterY() +
                widget._offsetY +
                _getTopPadding(context) / 2,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: FadeTransition(
                      opacity: Tween(begin: -1.0, end: 1.0)
                          .animate(widget._controller),
                      child: widget._child,
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///?????????????????????????????????????????????widget??????????????????
          ///If the position is relative to the target widget, pop it up from the center of the target widget
          ///Before pop-up, the center point of the popup window is aligned with the center point of the target widget
          childView = Positioned(
            left: targetOffset.dx -
                (widget._childSize == null
                        ? 0
                        : widget._childSize.width - targetSize.width) /
                    2 +
                widget._offsetX,
            top: targetOffset.dy -
                (widget._childSize == null
                        ? 0
                        : widget._childSize.height - targetSize.height) /
                    2 +
                widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: FadeTransition(
                      opacity: Tween(begin: -1.0, end: 1.0)
                          .animate(widget._controller),
                      child: widget._child,
                    )),
          );
        }
        break;
      case KumiPopupGravity.rightCenter:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen, pop up from the right of the screen
          childView = Positioned(
            right: -widget._offsetX,
            top: _getScreenCenterY() +
                widget._offsetY +
                _getTopPadding(context) / 2,
            child: widget._customAnimation
                ? widget._child
                : SlideTransition(
                    position: Tween(begin: Offset(1, 0), end: Offset(0, 0))
                        .animate(widget._controller),
                    child: FadeTransition(
                      opacity: Tween(begin: -1.0, end: 1.0)
                          .animate(widget._controller),
                      child: widget._child,
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///???????????????????????????y?????????????????????widget???y????????????????????????????????????????????????widget???????????????
          ///If the position is relative to the target widget, pop up from the left of the target widget
          ///Before the pop-up, the y-axis center point of the popup window is aligned with the y-axis center point of the target widget, and the right side of the popup window is aligned with the right side of the target widget
          childView = Positioned(
            left: targetOffset.dx -
                (widget._childSize == null
                    ? 0
                    : widget._childSize.width - targetSize.width) +
                widget._offsetX,
            top: targetOffset.dy -
                (widget._childSize == null
                        ? 0
                        : widget._childSize.height - targetSize.height) /
                    2 +
                widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0), end: Offset(1, 0))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        }
        break;
      case KumiPopupGravity.leftBottom:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen, pop up from the bottom left of the screen
          childView = Positioned(
            left: widget._offsetX,
            bottom: -widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(-1, 1), end: Offset(0, 0))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///?????????????????????????????????????????????widget??????????????????
          ///If the position is relative to the target widget, pop up from the bottom left of the target widget
          ///Before popping up, the bottom left corner of the popup box is aligned with the bottom left corner of the target widget
          childView = Positioned(
            left: targetOffset.dx + widget._offsetX,
            top: targetOffset.dy -
                (widget._childSize == null
                    ? 0
                    : widget._childSize.height - targetSize.height) +
                widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0), end: Offset(-1, 1))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        }
        break;
      case KumiPopupGravity.centerBottom:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen, it pops up right below the screen
          childView = Positioned(
            left: _getScreenCenterX() + widget._offsetX,
            bottom: -widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : SlideTransition(
                    position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                        .animate(widget._controller),
                    child: FadeTransition(
                      opacity: Tween(begin: -1.0, end: 1.0)
                          .animate(widget._controller),
                      child: widget._child,
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///???????????????????????????x?????????????????????widget???x????????????????????????????????????????????????widget???????????????
          ///If the position is relative to the target widget, pop up from directly below the target widget
          ///Before the pop-up, the x-axis center point of the popup window is aligned with the x-axis center point of the target widget, and the right side of the popup window is aligned with the bottom of the target widget
          childView = Positioned(
            left: targetOffset.dx -
                (widget._childSize == null
                        ? 0
                        : widget._childSize.width - targetSize.width) /
                    2 +
                widget._offsetX,
            top: targetOffset.dy -
                (widget._childSize == null
                    ? 0
                    : widget._childSize.height - targetSize.height) +
                widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0), end: Offset(0, 1))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        }
        break;
      case KumiPopupGravity.rightBottom:
        if (widget._targetRenderBox == null) {
          ///??????????????????????????????????????????????????????
          ///If the position is relative to the screen, pop up from the bottom right of the screen
          childView = Positioned(
            right: -widget._offsetX,
            bottom: -widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(1, 1), end: Offset(0, 0))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        } else {
          ///???????????????????????????widget????????????widget??????????????????
          ///?????????????????????????????????????????????widget??????????????????
          ///If the position is relative to the target widget, pop up from the bottom right of the target widget
          ///Before popping up, the bottom right corner of the popup box is aligned with the bottom right corner of the target widget
          childView = Positioned(
            left: targetOffset.dx -
                (widget._childSize == null
                    ? 0
                    : widget._childSize.width - targetSize.width) +
                widget._offsetX,
            top: targetOffset.dy -
                (widget._childSize == null
                    ? 0
                    : widget._childSize.height - targetSize.height) +
                widget._offsetY,
            child: widget._customAnimation
                ? widget._child
                : ScaleTransition(
                    scale:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: SlideTransition(
                      position: Tween(begin: Offset(0, 0), end: Offset(1, 1))
                          .animate(widget._controller),
                      child: FadeTransition(
                        opacity: Tween(begin: -1.0, end: 1.0)
                            .animate(widget._controller),
                        child: widget._child,
                      ),
                    ),
                  ),
          );
        }
        break;
      default:
        break;
    }
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                child: GestureDetector(
                  child: FadeTransition(
                    opacity:
                        Tween(begin: 0.0, end: 1.0).animate(widget._controller),
                    child: Container(
                      alignment: Alignment.center,
                      color: widget._bgColor,
                    ),
                  ),
                  onTap: () {
                    if (widget._clickOutDismiss) {
                      widget.dismiss(context);
                      return;
                    }
                    if (widget._onClickOut != null) {
                      widget._onClickOut(widget);
                    }
                  },
                ),
              ),
              childView,
            ],
          ),
        ),
        onWillPop: () {
          if (widget._clickBackDismiss) {
            widget.dismiss(context);
            return Future.value(false);
          }
          if (widget._onClickBack != null) {
            widget._onClickBack(widget);
          }
          return Future.value(false);
        });
  }

  @override
  Widget build(BuildContext context) {
    return getLayout(context);
  }
}

enum KumiPopupGravity {
  leftTop,
  centerTop,
  rightTop,
  leftCenter,
  center,
  rightCenter,
  leftBottom,
  centerBottom,
  rightBottom
}
