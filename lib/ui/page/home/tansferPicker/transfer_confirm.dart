import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/image_swiper.dart';
import 'package:huayin_logistics/ui/widget/img_picker.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/transfer_picker_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class TransferConfirm extends StatefulWidget {
  final SpecimenboxArriveItem item;
  final TransferPickerModel model;
  final Function success;
  TransferConfirm({this.item, this.model, this.success});
  @override
  _TransferConfirm createState() => _TransferConfirm();
}

class _TransferConfirm extends State<TransferConfirm> {
  List<FileUploadItem> _imageList = new List<FileUploadItem>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<ImageItem> sendImages = widget.item.sendImages ?? [];
    if (sendImages.isNotEmpty) {
      _imageList = List<FileUploadItem>.from(sendImages
          .map((e) => FileUploadItem.fromParams(id: e.fileId, innerUrl: e.url))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(850),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Container(
              width: ScreenUtil().setWidth(920),
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(50),
                bottom: ScreenUtil().setHeight(50),
              ),
              alignment: Alignment.center,
              child: Text(
                '签收确认',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(44),
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              )),
          Container(
              width: ScreenUtil().setWidth(920),
              alignment: Alignment.center,
              child: Text(
                '请上传签收图片,最多支持上传10张',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(40),
                  color: Color(0xFF333333),
                ),
              )),
          Container(
              margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      onTap: () async {
                        int maxImages = 10 - _imageList.length;
                        print('maxImages $maxImages');
                        var img = new ImgPicker(
                            maxImages: maxImages,
                            success: (res) {
                              _imageList.addAll(res);
                              setState(() => {_imageList = _imageList});
                            });
                        img.camera(context);
                      },
                      child: Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                          child: radiusButton(text: '拍照', img: "shot.png"))),
                  InkWell(
                      onTap: () async {
                        int maxImages = 10 - _imageList.length;
                        print('maxImages $maxImages');
                        if (maxImages == 0) {
                          showToast('最多不可超过10张');
                          return;
                        }
                        var img = new ImgPicker(
                            maxImages: maxImages,
                            success: (res) {
                              _imageList.addAll(res);
                              setState(() => {_imageList = _imageList});
                            });
                        img.loadAssets(context);
                      },
                      child: Container(
                          child: radiusButton(text: '上传', img: "pic.png"))),
                ],
              )),
          Container(
            width: ScreenUtil().setWidth(700),
            constraints: BoxConstraints(
              minHeight: ScreenUtil().setWidth(450),
            ),
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(35),
                right: ScreenUtil().setWidth(35),
                bottom: ScreenUtil().setWidth(50)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Color(0xFFcccccc)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: _imageList.isEmpty
                ? Container(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      noDataWidget(text: '暂无图片'),
                    ],
                  ))
                : Wrap(
                    spacing: ScreenUtil().setWidth(40),
                    children: _imageList
                        .map((e) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ImageSwiper(
                                            index: _imageList
                                                .indexWhere((i) => i == e),
                                            imgUrls: _imageList
                                                .map((e) =>
                                                    FlavorConfig
                                                        .instance.imgPre +
                                                    e.innerUrl)
                                                .toList(),
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(40)),
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
                                                          index: _imageList
                                                              .indexWhere((i) =>
                                                                  i == e),
                                                          imgUrls: _imageList
                                                              .map((r) =>
                                                                  r.innerUrl)
                                                              .toList(),
                                                        )));
                                          },
                                          child: Container(
                                            width: ScreenUtil().setWidth(158),
                                            height: ScreenUtil().setWidth(158),
                                            color: Color(0xFFf0f2f5),
                                            child: Image.network(
                                              FlavorConfig.instance.imgPre +
                                                  (e.thumbnailUrl ??
                                                      e.innerUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ))),
                                  Positioned(
                                      right: 0,
                                      child: InkWell(
                                          onTap: () {
                                            _imageList
                                                .removeWhere((i) => i == e);
                                            setState(() {});
                                          },
                                          child: Container(
                                            child: new Image.asset(
                                              ImageHelper.wrapAssets(
                                                  'delete.png'),
                                              width: ScreenUtil().setWidth(60),
                                              height: ScreenUtil().setWidth(60),
                                            ),
                                          )))
                                ],
                              ),
                            )))
                        .toList()),
          ),
          InkWell(
              onTap: () {
                submit();
              },
              child: Container(
                  width: ScreenUtil().setWidth(850),
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(40)),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(width: 0.5, color: Color(0xFFe5e5e5)),
                    bottom: BorderSide(width: 0.5, color: Color(0xFFe5e5e5)),
                  )),
                  alignment: Alignment.center,
                  child: Text(
                    '签收确认',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(44),
                      fontWeight: FontWeight.bold,
                      color: DiyColors.heavy_blue,
                    ),
                  ))),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                width: ScreenUtil().setWidth(850),
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
                alignment: Alignment.center,
                child: Text(
                  '取消',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(44),
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                )),
          )
        ],
      ),
    );
  }

  bool checkData() {
    if (_imageList.isEmpty) {
      showMsgToast('请上传图片');
      return false;
    }
    return true;
  }

  submit() async {
    if (!checkData()) {
      return;
    }
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    PopUtils.showLoading();

    try {
      await Repository.fetchTransferConfirm(labId: labId, data: {
        "id": widget.item.id,
        "pickUpId": userModel.user.user.id,
        "pickUpName": userModel.user.user.name,
        "imageIds": _imageList.map((e) => e.id).toList(),
      });
    } catch (e, s) {
      print('submit error $e');
      PopUtils.showError(e, s);

      PopUtils.dismiss();
      return;
    }
    PopUtils.dismiss();

    PopUtils.showNotice(
        text: '签收成功',
        onPop: () {
          Navigator.pop(context);
          widget.success?.call();
        });
  }
}
