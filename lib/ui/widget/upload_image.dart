import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart' show radiusButton;
import 'package:huayin_logistics/ui/widget/img_picker.dart';

class UploadImgage extends StatefulWidget {
  List<FileUploadItem> imageList;
  final Function(List<FileUploadItem>) submit;
  final Function(List<FileUploadItem>) updateImages;
  final bool enable;
  UploadImgage(
      {this.imageList,
      @required this.submit,
      this.updateImages,
      this.enable = true});
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
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                      child: Text('图   片',
                          style: TextStyle(
                              color: DiyColors.normal_black,
                              fontSize: ScreenUtil().setSp(40))),
                    ),
                    Text('最多可上传5张图片',
                        style: TextStyle(
                            color: Color.fromRGBO(93, 164, 255, 1),
                            fontSize: ScreenUtil().setSp(30)))
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
                          var img = new ImgPicker(
                              maxImages: 5 - _imageList.length,
                              success: (res) {
                                _imageList.addAll(res);
                                setState(() => {_imageList = _imageList});
                                widget.updateImages(_imageList);
                              });
                          img.camera();
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
                          var img = new ImgPicker(
                              maxImages: 5 - _imageList.length,
                              success: (res) {
                                _imageList.addAll(res);
                                setState(() => {_imageList = _imageList});
                                widget.updateImages(_imageList);
                              });
                          img.loadAssets();
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
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _imageList
                  .map((e) => Container(
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(40)),
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  width: ScreenUtil().setWidth(158),
                                  height: ScreenUtil().setWidth(158),
                                  color: Color(0xFFf0f2f5),
                                  child: Image.network(
                                      'https://lrp-dev.idaoben.com' +
                                          (e.thumbnailUrl ?? e.innerUrl)),
                                )),
                            Positioned(
                                right: 0,
                                child: InkWell(
                                    onTap: () {
                                      _imageList.removeWhere((i) => i == e);
                                      setState(() {});
                                      widget.updateImages(_imageList);
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
                      ))
                  .toList()),
        ),
        InkWell(
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
