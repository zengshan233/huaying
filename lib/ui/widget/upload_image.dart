import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show inputPreText, radiusButton, showMsgToast;
import 'package:huayin_logistics/ui/widget/img_picker.dart';
import 'package:huayin_logistics/utils/events_utils.dart';

import 'image_swiper.dart';

class UploadImgage extends StatefulWidget {
  List<FileUploadItem> imageList;
  final Function(List<FileUploadItem>) submit;
  final Function(List<FileUploadItem>) updateImages;
  final bool enable;
  final String tips;
  final bool isRequire;
  UploadImgage(
      {this.imageList,
      @required this.submit,
      this.updateImages,
      this.enable = true,
      this.isRequire = true,
      this.tips});
  @override
  _UploadImgage createState() => _UploadImgage();
}

class _UploadImgage extends State<UploadImgage> {
  List<FileUploadItem> _imageList = new List<FileUploadItem>();

  @override
  void initState() {
    super.initState();
    if (widget.imageList != null) {
      _imageList = widget.imageList;
    }
    EventBus.instance.addListener(EventKeys.clearImages, (map) {
      setState(() {
        _imageList = [];
      });
      widget.updateImages?.call(_imageList);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EventBus.instance.removeListener(EventKeys.clearImages);
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil.screenWidth,
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
          height: ScreenUtil().setHeight(140),
          color: Colors.white,
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    inputPreText(preText: '图片', isRquire: widget.isRequire),
                    Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                        child: Text('最多可上传5张图片',
                            style: TextStyle(
                                color: Color.fromRGBO(93, 164, 255, 1),
                                fontSize: ScreenUtil().setSp(30))))
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: widget.enable ? 1 : 0.3,
                duration: Duration(milliseconds: 500),
                child: Container(
                    child: Row(
                  children: <Widget>[
                    InkWell(
                        onTap: () async {
                          if (!widget.enable) {
                            return;
                          }
                          if (_imageList.length >= 5) {
                            showMsgToast('上传图片数量不可超过5张', context: context);
                            return;
                          }
                          var img = new ImgPicker(
                              maxImages: 5 - _imageList.length,
                              success: (res) {
                                _imageList.addAll(res);
                                setState(() => {_imageList = _imageList});
                                widget.updateImages(_imageList);
                              });
                          img.camera(context);
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(40)),
                            child: radiusButton(text: '拍照', img: "shot.png"))),
                    InkWell(
                        onTap: () async {
                          if (!widget.enable) {
                            return;
                          }
                          if (_imageList.length >= 5) {
                            showMsgToast('上传图片数量不可超过5张', context: context);
                            return;
                          }
                          var img = new ImgPicker(
                              maxImages: 5 - _imageList.length,
                              success: (res) {
                                _imageList.addAll(res);
                                setState(() => {_imageList = _imageList});
                                widget.updateImages?.call(_imageList);
                              });
                          img.loadAssets(context);
                        },
                        child: Container(
                            child: radiusButton(text: '上传', img: "pic.png"))),
                  ],
                )),
              ),
            ],
          ),
        ),
        Container(
          width: ScreenUtil.screenWidth,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
          child: Wrap(
              spacing: ScreenUtil().setWidth(30),
              children: List.generate(
                  _imageList.length,
                  (index) => Container(
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(40)),
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                                bottom: 0,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ImageSwiper(
                                                    index: index,
                                                    imgUrls: _imageList
                                                        .map((e) => e.innerUrl)
                                                        .toList(),
                                                  )));
                                    },
                                    child: Container(
                                      width: ScreenUtil().setWidth(158),
                                      height: ScreenUtil().setWidth(158),
                                      color: Color(0xFFf0f2f5),
                                      child: Image.network(
                                        FlavorConfig.instance.imgPre +
                                            (_imageList[index].thumbnailUrl ??
                                                _imageList[index].innerUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ))),
                            Positioned(
                                right: 0,
                                child: InkWell(
                                    onTap: () {
                                      _imageList.removeAt(index);
                                      setState(() {});
                                      widget.updateImages?.call(_imageList);
                                    },
                                    child: Container(
                                      child: new Image.asset(
                                        ImageHelper.wrapAssets('delete.png'),
                                        width: ScreenUtil().setWidth(60),
                                        height: ScreenUtil().setWidth(60),
                                      ),
                                    )))
                          ],
                        ),
                      ))),
        ),
        Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(20),
                left: ScreenUtil().setWidth(40)),
            alignment: Alignment.centerLeft,
            child: Text(widget.tips ?? '',
                style: TextStyle(
                    color: Color.fromRGBO(93, 164, 255, 1),
                    fontSize: ScreenUtil().setSp(30)))),
        GestureDetector(
            onTap: () async {
              try {
                await widget.submit(_imageList);
              } catch (e) {}
            },
            child: Container(
              width: ScreenUtil().setWidth(1000),
              height: ScreenUtil().setWidth(150),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFF1677ff),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: Text(
                '提  交',
                style: TextStyle(color: Colors.white),
              ),
            ))
      ],
    );
  }
}
