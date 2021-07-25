import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:firexcode/firexcode.dart';
import 'dart:math' as math;

import '../configs/image_picker_configs.dart';
import '../models/image_object.dart';
import '../modules/all_emojies.dart';
import '../modules/color_filter_generator.dart';
import '../modules/colors_picker.dart';
import '../modules/emoji.dart';
import '../modules/sliders.dart';
import '../modules/text.dart';
import '../modules/textview.dart';
import '../utils/image_utils.dart'; // import this

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
var width = 300;
var height = 300;
List<Map> widgetJson = [];
//List fontsize = [];
//List<Color> colorList = [];
var howmuchwidgetis = 0;
//List multiwidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller =
    SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditViewer extends StatefulWidget {
  final ImageObject imgObject;
  final Color? appBarColor;
  final Color? bottomBarColor;
  final Directory? pathSave;
  final double? pixelRatio;
  final ImagePickerConfigs? configs;
  final Function(ImageObject)? onChanged;
  final Function(List<ImageObject>)? onFinished;
  ImageEditViewer(
      {required this.imgObject,
      this.appBarColor,
      this.bottomBarColor,
      this.pathSave,
      this.pixelRatio,
      this.onChanged,
      this.onFinished,
      this.configs});

  @override
  _ImageEditViewerState createState() => _ImageEditViewerState();
}

var slider = 0.0;

class _ImageEditViewerState extends State<ImageEditViewer> {
  ImagePickerConfigs _configs = ImagePickerConfigs();

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller =
        SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  File _image = File('');
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction = Timer(Duration(seconds: 0), () => {});
  double imgRatio = 1;
  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    _controller.clear();
    widgetJson.clear();
    heightcontroler.clear();
    widthcontroler.clear();
    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    //  fontsize.clear();
    offsets.clear();
    //  multiwidget.clear();
    howmuchwidgetis = 0;
    initImage();
    super.initState();
  }

  initImage() async {
    if (widget.configs != null) _configs = widget.configs!;
    var decodedImage = await decodeImageFromList(
        File(widget.imgObject.modifiedPath).readAsBytesSync());
    setState(() {
      width = decodedImage.width;
      height = decodedImage.height;
      imgRatio = decodedImage.height / decodedImage.width;
      _image = File(widget.imgObject.modifiedPath);
    });
  }

  double flipValue = 0;
  int rotateValue = 0;
  double blurValue = 0;
  double opacityValue = 0;
  Color colorValue = Colors.transparent;

  double hueValue = 0;
  double brightnessValue = 0;
  double saturationValue = 0;

  Future<File> _imagePreProcessing(String? path) async {
    if (_configs.imagePreProcessingBeforeEditingEnabled)
      return await ImageUtils.compressResizeImage(path!,
          maxWidth: _configs.maxWidth,
          maxHeight: _configs.maxHeight,
          quality: _configs.compressQuality);
    return File(path!);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: [
            Positioned.fill(
                child: Screenshot(
              controller: screenshotController,
              child: RotatedBox(
                quarterTurns: rotateValue,
                child: imageFilterLatest(
                  hue: hueValue,
                  brightness: brightnessValue,
                  saturation: saturationValue,
                  child: RepaintBoundary(
                      key: globalKey,
                      child: xStack.list(
                        [
                          _image != null
                              ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(flipValue),
                                  child: _image.path
                                      .decorationIFToFitWidth(
                                          fit: BoxFit.fitWidth)
                                      .xContainer(
                                          padding: EdgeInsets.zero,
                                          width: screenWidth,
                                          height: screenWidth * imgRatio,
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: blurValue,
                                              sigmaY: blurValue,
                                            ),
                                            child: Container(
                                              color: colorValue
                                                  .withOpacity(opacityValue),
                                            ),
                                          )),
                                )
                              : Container(),
                          Signat().xGesture(
                            onPanUpdate: (DragUpdateDetails details) {
                              setState(() {
                                RenderBox object =
                                    context.findRenderObject() as RenderBox;
                                var _localPosition = object
                                    .globalToLocal(details.globalPosition);
                                _points = List.from(_points)
                                  ..add(_localPosition);
                              });
                            },
                            onPanEnd: (DragEndDetails details) {
                              _points.add(null as Offset);
                            },
                          ).xContainer(padding: EdgeInsets.all(0.0)),
                          xStack.list(
                            widgetJson.asMap().entries.map((f) {
                              return type[f.key] == 1
                                  ? EmojiView(
                                      left: offsets[f.key].dx,
                                      top: offsets[f.key].dy,
                                      ontap: () {
                                        scaf.currentState
                                            ?.showBottomSheet((context) {
                                          return Sliders(
                                            index: f.key,
                                            mapValue: f.value,
                                          );
                                        });
                                      },
                                      onpanupdate: (details) {
                                        setState(() {
                                          offsets[f.key] = Offset(
                                              offsets[f.key].dx +
                                                  details.delta.dx,
                                              offsets[f.key].dy +
                                                  details.delta.dy);
                                        });
                                      },
                                      mapJson: f.value,
                                    )
                                  : type[f.key] == 2
                                      ? TextView(
                                          left: offsets[f.key].dx,
                                          top: offsets[f.key].dy,
                                          ontap: () {
                                            showModalBottomSheet(
                                                shape: BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10))
                                                    .xShapeBorder(),
                                                context: context,
                                                builder: (context) {
                                                  return Sliders(
                                                    index: f.key,
                                                    mapValue: f.value,
                                                  );
                                                });
                                          },
                                          onpanupdate: (details) {
                                            setState(() {
                                              offsets[f.key] = Offset(
                                                  offsets[f.key].dx +
                                                      details.delta.dx,
                                                  offsets[f.key].dy +
                                                      details.delta.dy);
                                            });
                                          },
                                          mapJson: f.value,
                                        )
                                      : Container();
                            }).toList(),
                          )
                        ],
                      )).toContainer(
                    width: screenWidth,
                    height: screenWidth * imgRatio,
                  ),
                ),
              ),
            ).xCenter()),
            Positioned(
                top: MediaQuery.of(context).padding.top + 30,
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: FontAwesomeIcons.chevronCircleLeft
                            .xIcons(color: Colors.white, size: 25),
                      ),
                    )
                  ],
                )),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 10,
              width: screenWidth,
              height: 70,
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var image = await this._imagePreProcessing(
                                  widget.imgObject.modifiedPath);
                              File? croppedFile = await ImageCropper.cropImage(
                                  sourcePath: image.path,
                                  compressQuality: _configs.compressQuality,
                                  maxWidth: _configs.maxWidth,
                                  maxHeight: _configs.maxHeight,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                                  androidUiSettings: AndroidUiSettings(
                                      toolbarTitle: _configs.textImageCropTitle,
                                      toolbarColor: Colors.black87,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio:
                                          CropAspectRatioPreset.original,
                                      lockAspectRatio: false),
                                  iosUiSettings: IOSUiSettings(
                                    minimumAspectRatio: 1.0,
                                  ));
                              if (croppedFile != null) {
                                setState(() {
                                  _image = croppedFile;
                                });
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FontAwesomeIcons.crop
                                        .xIcons(color: Colors.white, size: 25),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        '裁剪',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: '选择颜色'.text(),
                                    content: ColorPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: changeColor,
                                      showLabel: true,
                                      pickerAreaHeightPercent: 0.8,
                                    ).xSingleChildScroolView(),
                                    actions: <Widget>[
                                      '确定'.text().xFlatButton(
                                        onPressed: () {
                                          setState(
                                              () => currentColor = pickerColor);
                                          back(context);
                                        },
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FontAwesomeIcons.brush
                                        .xIcons(color: Colors.white, size: 25),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        '画笔',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          GestureDetector(
                              onTap: () async {
                                var value = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TextEditorImage()));
                                if (value['name'] == null) {
                                  print('true');
                                } else {
                                  type.add(2);
                                  widgetJson.add(value);
                                  offsets.add(Offset(screenWidth / 2,
                                      (screenWidth * imgRatio) / 2));
                                  howmuchwidgetis++;
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icons.text_fields.xIcons(
                                          color: Colors.white, size: 25),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          '文字',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      )
                                    ],
                                  ))),
                          GestureDetector(
                              onTap: () {
                                _controller.clear();
                                //  type.clear();
                                // // fontsize.clear();
                                //  offsets.clear();
                                // // multiwidget.clear();
                                howmuchwidgetis = 0;
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FontAwesomeIcons.eraser.xIcons(
                                          color: Colors.white, size: 25),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          '清除',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      )
                                    ],
                                  ))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  flipValue = flipValue == 0 ? math.pi : 0;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icons.flip.xIcons(
                                          color: Colors.white, size: 25),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          '翻转',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      )
                                    ],
                                  ))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  rotateValue--;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icons.rotate_left.xIcons(
                                          color: Colors.white, size: 25),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          '左旋转',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      )
                                    ],
                                  ))),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  rotateValue++;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icons.rotate_right.xIcons(
                                          color: Colors.white, size: 25),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          '右旋转',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      )
                                    ],
                                  ))),
                          GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                shape: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10))
                                    .xShapeBorder(),
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setS) {
                                      return xColumn.list(
                                        [
                                          '色彩过滤'.xTextColorWhite().toCenter(),
                                          Divider(

                                              // height: 1,
                                              ),
                                          20.0.sizedHeight(),
                                          '色彩'.xTextColorWhite(),
                                          //   10.0.sizedHeight(),
                                          xRowCC.list([
                                            BarColorPicker(
                                                width: 300,
                                                thumbColor: Colors.white,
                                                cornerRadius: 10,
                                                pickMode: PickMode.Color,
                                                colorListener: (int value) {
                                                  setS(() {
                                                    setState(() {
                                                      colorValue = Color(value);
                                                    });
                                                  });
                                                }).xExpanded(),
                                            '重置'.xTextColorWhite().xFlatButton(
                                                onPressed: () {
                                              setState(() {
                                                setS(() {
                                                  colorValue =
                                                      Colors.transparent;
                                                });
                                              });
                                            })
                                          ]),
                                          5.0.sizedHeight(),
                                          '模糊度'.xTextColorWhite(),
                                          10.0.sizedHeight(),
                                          xRow.list([
                                            Slider(
                                                activeColor: Colors.white,
                                                inactiveColor: Colors.grey,
                                                value: blurValue,
                                                min: 0.0,
                                                max: 10.0,
                                                onChanged: (v) {
                                                  setS(() {
                                                    setState(() {
                                                      blurValue = v;
                                                    });
                                                  });
                                                }).xExpanded(),
                                            '重置'.xTextColorWhite().xFlatButton(
                                                onPressed: () {
                                              setS(() {
                                                setState(() {
                                                  blurValue = 0.0;
                                                });
                                              });
                                            })
                                          ]),
                                          5.0.sizedHeight(),
                                          '透明度'.xTextColorWhite(),
                                          10.0.sizedHeight(),
                                          xRow.list([
                                            Slider(
                                                activeColor: Colors.white,
                                                inactiveColor: Colors.grey,
                                                value: opacityValue,
                                                min: 0.00,
                                                max: 1.0,
                                                onChanged: (v) {
                                                  setS(() {
                                                    setState(() {
                                                      opacityValue = v;
                                                    });
                                                  });
                                                }).xExpanded(),
                                            '重置'.xTextColorWhite().xFlatButton(
                                                onPressed: () {
                                              setS(() {
                                                setState(() {
                                                  opacityValue = 0.0;
                                                });
                                              });
                                            })
                                          ]),
                                        ],
                                      ).toContainer(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
                                        padding: EdgeInsets.all(20),
                                        height: 400,
                                        color: Colors.black87,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icons.blur_on
                                        .xIcons(color: Colors.white, size: 25),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        '模糊',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10))
                                        .xShapeBorder(),
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setS) {
                                          return xColumnCC.list([
                                            5.0.sizedHeight(),
                                            '色调'.xTextColorWhite(),
                                            10.0.sizedHeight(),
                                            xRow.list([
                                              Slider(
                                                  activeColor: Colors.white,
                                                  inactiveColor: Colors.grey,
                                                  value: hueValue,
                                                  min: -10.0,
                                                  max: 10.0,
                                                  onChanged: (v) {
                                                    setS(() {
                                                      setState(() {
                                                        hueValue = v;
                                                      });
                                                    });
                                                  }).xExpanded(),
                                              '重置'
                                                  .xTextColorWhite()
                                                  .xFlatButton(onPressed: () {
                                                setS(() {
                                                  setState(() {
                                                    blurValue = 0.0;
                                                  });
                                                });
                                              })
                                            ]),
                                            5.0.sizedHeight(),
                                            '饱和度'.xTextColorWhite(),
                                            10.0.sizedHeight(),
                                            xRow.list([
                                              Slider(
                                                  activeColor: Colors.white,
                                                  inactiveColor: Colors.grey,
                                                  value: saturationValue,
                                                  min: -10.0,
                                                  max: 10.0,
                                                  onChanged: (v) {
                                                    setS(() {
                                                      setState(() {
                                                        saturationValue = v;
                                                      });
                                                    });
                                                  }).xExpanded(),
                                              '重置'
                                                  .xTextColorWhite()
                                                  .xFlatButton(onPressed: () {
                                                setS(() {
                                                  setState(() {
                                                    saturationValue = 0.0;
                                                  });
                                                });
                                              })
                                            ]),
                                            5.0.sizedHeight(),
                                            '亮度'.xTextColorWhite(),
                                            10.0.sizedHeight(),
                                            xRow.list([
                                              Slider(
                                                  activeColor: Colors.white,
                                                  inactiveColor: Colors.grey,
                                                  value: brightnessValue,
                                                  min: 0.0,
                                                  max: 1.0,
                                                  onChanged: (v) {
                                                    setS(() {
                                                      setState(() {
                                                        brightnessValue = v;
                                                      });
                                                    });
                                                  }).xExpanded(),
                                              '重置'
                                                  .xTextColorWhite()
                                                  .xFlatButton(onPressed: () {
                                                setS(() {
                                                  setState(() {
                                                    brightnessValue = 0.0;
                                                  });
                                                });
                                              })
                                            ])
                                          ]);
                                        },
                                      ).xContainer(
                                          color: Colors.black87,
                                          height: 300,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10)));
                                    });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icons.photo.xIcons(
                                          color: Colors.white, size: 25),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          '滤镜',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      )
                                    ],
                                  ))),
                          GestureDetector(
                              onTap: () {
                                var getemojis = showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Emojies();
                                    });
                                getemojis.then((value) {
                                  if (value['name'] != null) {
                                    type.add(1);
                                    widgetJson.add(value);
                                    //    fontsize.add(20);
                                    offsets.add(Offset.zero);
                                    //  multiwidget.add(value);
                                    howmuchwidgetis++;
                                  }
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FontAwesomeIcons.smile.xIcons(
                                          color: Colors.white, size: 25),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          '表情',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      )
                                    ],
                                  ))),
                        ],
                      ),
                    )),
                    InkWell(
                      onTap: () {
                        screenshotController
                            .capture(pixelRatio: widget.pixelRatio ?? 1.5)
                            .then((binaryIntList) async {
                          final paths =
                              widget.pathSave ?? await getTemporaryDirectory();
                          final file = await File('${paths.path}/' +
                                  DateTime.now().toString() +
                                  '.jpg')
                              .create();
                          file.writeAsBytesSync(binaryIntList!);
                          widget.imgObject.modifiedPath = file.path;
                          widget.onChanged?.call(widget.imgObject);
                          Navigator.pop(context);
                          if (widget.configs?.multiPictures == false) {
                            Navigator.pop(context);
                            widget.onFinished?.call([widget.imgObject]);
                          }
                        }).catchError((onError) {
                          print(onError);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        child: Text(
                          '完成',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return xListView.list(
      [
        Signature(
            controller: _controller,
            height: height.toDouble(),
            width: width.toDouble(),
            backgroundColor: Colors.transparent),
      ],
    );
  }
}

Widget imageFilterLatest({brightness, saturation, hue, child}) {
  return ColorFiltered(
      colorFilter:
          ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      )),
      child: ColorFiltered(
          colorFilter:
              ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
            value: saturation,
          )),
          child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
              value: hue,
            )),
            child: child,
          )));
}
