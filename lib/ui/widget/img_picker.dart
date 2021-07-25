import 'dart:math';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/oss_model.dart';
import 'package:huayin_logistics/ui/helper/gaps.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/utils/platform_utils.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:intl/intl.dart';
import 'package:oss_dart/oss_dart.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'image_swiper.dart';

class ImgPicker {
  int maxImages;
  Function(List<FileUploadItem>) success;
  OssSts ossData;
  ImgPicker({
    this.maxImages = 5,
    @required this.success,
  });
  int imgQulity = 20; //0-100

  Future loadAssets(BuildContext context) async {
    List<String> filesPath = [];
    List<AssetEntity> assets;
    try {
      assets = await AssetPicker.pickAssets(context,
          maxAssets: maxImages, requestType: RequestType.image);
    } catch (e) {
      print(e.toString());
      showMsgToast(e.toString());
      return;
    }
    if (assets == null) return;
    Iterable<Future<File>> futures = assets.map((a) => a.file);
    List<File> files = await Future.wait<File>(futures);
    filesPath = files.map((e) => e.path).toList();
    imageUpload(filesPath, context);
  }

  Future camera(BuildContext context) async {
    // Media media;
    // try {
    //   media = await ImagePickers.openCamera(
    //       cameraMimeType: CameraMimeType.photo, compressQuality: imgQulity);
    // } catch (e) {
    //   print(e.toString());
    //   showMsgToast(e.toString());
    //   return;
    // }

    // print('media.path  ${media.path}');
    // PhotoEditorResult result = await PESDK.openEditor(image: media.path);
    // print('-------------------------------------------------------------');
    // print(result?.toJson());
    // String path = result?.toJson()['image'].replaceAll('file://', '');
    // print('pathpath $path');
    // imageUpload([path], context);
    // createCameraFile(path);
    var configs = ImagePickerConfigs();
    configs.model = PickerMode.Camera;
    configs.multiPictures = true;
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (_context, animation, __) {
      return ImagePicker(
        maxCount: maxImages,
        configs: configs,
        onFinished: (objects) {
          if ((objects?.length ?? 0) > 0) {
            List<String> imagesPath =
                objects.map((e) => e.modifiedPath).toList();
            imageUpload(imagesPath, context);
            // createCameraFile(path);
          }
        },
      );
    }));
  }

  /// 拍照的图片在手机创建一个“华银物流APP”文件夹，将APP拍照的图片存在该文件夹下
  void createCameraFile(String filePath) async {
    /// 只针对安卓设备
    if (!Platform.isAndroid) {
      return;
    }
    Directory directory = Directory("/storage/emulated/0/华银物流APP");
    await directory.create(recursive: true);
    DateTime ketF = new DateTime.now();
    String baru = "${ketF.year}${ketF.month}${ketF.day}";
    int rand = new Random().nextInt(100000);
    File imageFile = File(filePath);
    // img.Image gambard = img.decodeImage(imageFile.readAsBytesSync());
    // img.Image gambarKecilx = img.copyResize(gambard, width: 700, height: 700); //图片裁剪
    File("${directory.path}//image_$baru$rand.jpg")
      ..writeAsBytesSync(imageFile.readAsBytesSync());
  }

  Future imageUpload(List<String> resultList, BuildContext context) async {
    var yyDialog = yyProgressDialogBody(text: '正在上传...', context: context);
    List<FileUploadItem> uploadResponse;
    try {
      ossData = await Repository.fetchOssSts();
      Iterable<Future<FileUploadItem>> futures =
          resultList.map((e) => ossUpload(e));
      List<String> ossPaths = resultList.map((e) => getOssFilePath(e)).toList();
      await Future.wait(futures);
      uploadResponse = await Repository.fetchFileSave('1', ossPaths);
    } catch (e, s) {
      print('upload erro $e');
      dialogDismiss(yyDialog);
      await Future.delayed(Duration(milliseconds: 100));
      PopUtils.showError(e, s);

      return null;
    }
    dialogDismiss(yyDialog);
    success(uploadResponse);
  }

  Future<FileUploadItem> ossUpload(String path) async {
    OssClient client = OssClient(
        bucketName: ossData.bucket,
        endpoint: ossData.endpoint,
        tokenGetter: () {
          return ossData.credentials.toJson();
        });
    List<int> fileData = File(path).readAsBytesSync(); //上传文件的二进制
    String ossPath = getOssFilePath(path);
    await client.putObject(fileData, ossPath);
  }
}

String getOssFilePath(String path) {
  String fileName = path.substring(path.lastIndexOf("/") + 1, path.length);
  var formatterMonth = new DateFormat('yyyy-MM');
  var formatterDay = new DateFormat('dd');
  DateTime now = DateTime.now();
  String month = formatterMonth.format(now);
  String day = formatterDay.format(now);
  String ossPath = 'hy_logistics/$month/$day/$fileName';
  return ossPath;
}

Widget eventImgGridView(
  List<EventImage> images, {
  @required BuildContext context,
  int maxLength = 5,
  Function selectClick,
  Function delCallBack,
  bool initButton = true,
  Function cSelect,
  Function pSelect,
}) {
  return Container(
    height: ScreenUtil().setHeight(230) * ((images.length / 5).floor() + 1),
    margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
    child: GridView.count(
      crossAxisCount: 5,
      childAspectRatio: 1,
      mainAxisSpacing: ScreenUtil().setHeight(40),
      crossAxisSpacing: ScreenUtil().setWidth(40),
      children: [
        ...List.generate(images.length, (index) {
          return new Stack(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(220),
                height: ScreenUtil().setHeight(220),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ImageSwiper(
                                  index: index,
                                  imgUrls:
                                      images.map((r) => r.imageUrl).toList(),
                                )));
                  },
                  child: Image.network(
                    FlavorConfig.instance.imgPre + images[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    ),
  );
}

void selectBottomSheet(BuildContext context, dynamic img) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((20.0)),
            color: Colors.white,
          ),
          child: Wrap(children: <Widget>[
            ListTile(
                title: Text(
                  '拍照',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  img.camera();
                  Navigator.pop(context);
                }),
            Gaps.line,
            ListTile(
                title: Text(
                  '从手机相册选择',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  img.loadAssets();
                  Navigator.pop(context);
                })
          ]),
        );
      });
}
