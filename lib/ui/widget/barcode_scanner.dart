import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qrcode/qrcode.dart';

/// 使用前需已经获取相关权限
/// Relevant privileges must be obtained before use
class QrcodeReaderView extends StatefulWidget {
  final Widget headerWidget;
  final Future Function(String) onScan;
  final double scanBoxRatio;
  final Color boxLineColor;
  final Widget helpWidget;
  final bool initCamera;
  QrcodeReaderView(
      {Key key,
      @required this.onScan,
      this.headerWidget,
      this.boxLineColor = Colors.cyanAccent,
      this.helpWidget,
      this.scanBoxRatio = 0.85,
      this.initCamera})
      : super(key: key);

  @override
  QrcodeReaderViewState createState() => new QrcodeReaderViewState();
}

class QrcodeReaderViewState extends State<QrcodeReaderView>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  bool openFlashlight;
  Timer _timer;
  QRCaptureController _captureController = QRCaptureController();
  bool _isTorchOn = false;
  String _data;
  @override
  void initState() {
    super.initState();
    openFlashlight = false;
    if (widget.initCamera) {
      startScan();
    }
    _captureController.onCapture((data) {
      _data = data;
      if (widget.initCamera) {
        widget.onScan(data);
      }
    });
  }

  void _initAnimation() {
    setState(() {
      _animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 1000));
    });
    _animationController
      ..addListener(_upState)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _timer = Timer(Duration(seconds: 1), () {
            _animationController?.reverse(from: 1.0);
          });
        } else if (state == AnimationStatus.dismissed) {
          _timer = Timer(Duration(seconds: 1), () {
            _animationController?.forward(from: 0.0);
          });
        }
      });
    _animationController.forward(from: 0.0);
  }

  void _clearAnimation() {
    _timer?.cancel();
    if (_animationController != null) {
      _animationController?.dispose();
      _animationController = null;
    }
  }

  void _upState() {
    setState(() {});
  }

  bool isScan = false;

  void startScan() {
    isScan = true;
    _initAnimation();
  }

  void stopScan() {
    isScan = false;
    _clearAnimation();
  }

  Future setFlashlight() async {
    if (_isTorchOn) {
      _captureController.torchMode = CaptureTorchMode.off;
    } else {
      _captureController.torchMode = CaptureTorchMode.on;
    }
    _isTorchOn = !_isTorchOn;
  }

  @override
  Widget build(BuildContext context) {
    final flashOpen = Image.asset(
      "assets/tool_flashlight_open.png",
      package: "flutter_qr_reader",
      width: 35,
      height: 35,
      color: Colors.white,
    );
    final flashClose = Image.asset(
      "assets/tool_flashlight_close.png",
      package: "flutter_qr_reader",
      width: 35,
      height: 35,
      color: Colors.white,
    );
    return Material(
      color: Colors.black,
      child: LayoutBuilder(builder: (context, constraints) {
        final qrScanSize = constraints.maxWidth * widget.scanBoxRatio;
        final mediaQuery = MediaQuery.of(context);
        return Stack(
          children: <Widget>[
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: QRCaptureView(controller: _captureController),
            ),
            if (widget.headerWidget != null) widget.headerWidget,
            Positioned(
              left: (constraints.maxWidth - qrScanSize) / 2,
              top: (constraints.maxHeight - qrScanSize) * 0.333333,
              child: CustomPaint(
                painter: QrScanBoxPainter(
                  boxLineColor: widget.boxLineColor,
                  animationValue: _animationController?.value ?? 0,
                  isForward:
                      _animationController?.status == AnimationStatus.forward,
                ),
                child: SizedBox(
                  width: qrScanSize,
                  height: qrScanSize,
                ),
              ),
            ),
            Positioned(
                top: (constraints.maxHeight - qrScanSize) * 0.333333 +
                    qrScanSize +
                    24,
                width: constraints.maxWidth,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(700),
                      margin: EdgeInsets.only(bottom: 5),
                      child: Align(
                        alignment: Alignment.center,
                        child: DefaultTextStyle(
                          style: TextStyle(color: Colors.white),
                          child: widget.helpWidget ??
                              Text(
                                  "请将条形码/二维码置于方框中${widget.initCamera ? "" : ", 点击"}"),
                        ),
                      ),
                    ),
                    widget.initCamera
                        ? Container()
                        : Container(
                            width: ScreenUtil().setWidth(700),
                            child: Align(
                              alignment: Alignment.center,
                              child: DefaultTextStyle(
                                style: TextStyle(color: Colors.white),
                                child: widget.helpWidget ?? Text("下方扫码按钮开始扫码"),
                              ),
                            ),
                          ),
                  ],
                )),
            Positioned(
              top: (constraints.maxHeight - qrScanSize) * 0.333333 +
                  qrScanSize -
                  12 -
                  35,
              width: constraints.maxWidth,
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: setFlashlight,
                  child: _isTorchOn ? flashOpen : flashClose,
                ),
              ),
            ),
            widget.initCamera
                ? Container()
                : Positioned(
                    width: constraints.maxWidth,
                    bottom: constraints.maxHeight == mediaQuery.size.height
                        ? 12 + mediaQuery.padding.top
                        : 12,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // GestureDetector(
                        //   behavior: HitTestBehavior.translucent,
                        //   onTap: _scanImage,
                        //   child: Container(
                        //     width: 45,
                        //     height: 45,
                        //     alignment: Alignment.center,
                        //     child: Image.asset(
                        //       "assets/tool_img.png",
                        //       package: "flutter_qr_reader",
                        //       width: 25,
                        //       height: 25,
                        //       color: Colors.white54,
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              if (isScan) {
                                stopScan();
                              } else {
                                startScan();
                                await Future.delayed(Duration(seconds: 1));
                                await widget.onScan(_data);
                                stopScan();
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                border: Border.all(
                                    color: Colors.white30, width: 12),
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/tool_qrcode.png",
                                package: "flutter_qr_reader",
                                width: 35,
                                height: 35,
                                color: Colors.white54,
                              ),
                            )),
                      ],
                    ),
                  )
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _clearAnimation();
    super.dispose();
  }
}

class QrScanBoxPainter extends CustomPainter {
  final double animationValue;
  final bool isForward;
  final Color boxLineColor;

  QrScanBoxPainter(
      {@required this.animationValue,
      @required this.isForward,
      this.boxLineColor})
      : assert(animationValue != null),
        assert(isForward != null);

  @override
  void paint(Canvas canvas, Size size) {
    final borderRadius = BorderRadius.all(Radius.circular(12)).toRRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    canvas.drawRRect(
      borderRadius,
      Paint()
        ..color = Colors.white54
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = new Path();
    // leftTop
    path.moveTo(0, 50);
    path.lineTo(0, 12);
    path.quadraticBezierTo(0, 0, 12, 0);
    path.lineTo(50, 0);
    // rightTop
    path.moveTo(size.width - 50, 0);
    path.lineTo(size.width - 12, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 12);
    path.lineTo(size.width, 50);
    // rightBottom
    path.moveTo(size.width, size.height - 50);
    path.lineTo(size.width, size.height - 12);
    path.quadraticBezierTo(
        size.width, size.height, size.width - 12, size.height);
    path.lineTo(size.width - 50, size.height);
    // leftBottom
    path.moveTo(50, size.height);
    path.lineTo(12, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 12);
    path.lineTo(0, size.height - 50);

    canvas.drawPath(path, borderPaint);

    canvas.clipRRect(
        BorderRadius.all(Radius.circular(12)).toRRect(Offset.zero & size));

    // 绘制横向网格
    final linePaint = Paint();
    final lineSize = size.height * 0.45;
    final leftPress = (size.height + lineSize) * animationValue - lineSize;
    linePaint.style = PaintingStyle.stroke;
    linePaint.shader = LinearGradient(
      colors: [Colors.transparent, boxLineColor],
      begin: isForward ? Alignment.topCenter : Alignment(0.0, 2.0),
      end: isForward ? Alignment(0.0, 0.5) : Alignment.topCenter,
    ).createShader(Rect.fromLTWH(0, leftPress, size.width, lineSize));
    for (int i = 0; i < size.height / 5; i++) {
      canvas.drawLine(
        Offset(
          i * 5.0,
          leftPress,
        ),
        Offset(i * 5.0, leftPress + lineSize),
        linePaint,
      );
    }
    for (int i = 0; i < lineSize / 5; i++) {
      canvas.drawLine(
        Offset(0, leftPress + i * 5.0),
        Offset(
          size.width,
          leftPress + i * 5.0,
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(QrScanBoxPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;

  @override
  bool shouldRebuildSemantics(QrScanBoxPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}
