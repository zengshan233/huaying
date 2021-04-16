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
import 'package:image_pickers/UIConfig.dart';
import 'package:image_pickers/image_pickers.dart';
//import 'package:image_pickers/CorpConfig.dart';
import 'package:image_pickers/Media.dart';
import 'package:intl/intl.dart';
import 'package:oss_dart/oss_dart.dart';

class ImgPicker {
  int maxImages;
  Function(List<FileUploadItem>) success;
  OssSts ossData;
  ImgPicker({
    this.maxImages = 5,
    @required this.success,
  });
  int imgQulity = 20; //0-100

  Future loadAssets() async {
    List<Media> resultList = List();
    GalleryMode _galleryMode = GalleryMode.image;
    try {
      _galleryMode = GalleryMode.image;
      resultList = await ImagePickers.pickerPaths(
        galleryMode: _galleryMode,
        selectCount: maxImages,
        showCamera: true,
        compressSize: 500,
        uiConfig: UIConfig(uiThemeColor: Color.fromRGBO(21, 145, 241, 1)),
        compressQuality: imgQulity,
        // corpConfig: CorpConfig(enableCrop: true, width: 230, height: 320)
      );
    } on Exception catch (e) {
      print(e.toString());
    }
    imageUpload(resultList);
  }

  Future<Media> camera() async {
    Media media;
    try {
      media = await ImagePickers.openCamera(
          cameraMimeType: CameraMimeType.photo, compressQuality: imgQulity);
    } on Exception catch (e) {
      print(e.toString());
    }
    FormData formData = FormData();
    formData.files.add(MapEntry(
      "fileuploads",
      await MultipartFile.fromFile(media.path,
          filename: media.path
              .substring(media.path.lastIndexOf("/") + 1, media.path.length)),
    ));
    imageUpload([media]);
  }

  Future imageUpload(List<Media> resultList) async {
    var yyDialog = yyProgressDialogBody(text: '正在上传...');
    ossData = await Repository.fetchOssSts();
    List<String> paths = resultList.map((e) => e.path).toList();
    Iterable<Future<FileUploadItem>> futures = paths.map((e) => ossUpload(e));
    List<FileUploadItem> uploadResponse;
    List<String> ossPaths =
        resultList.map((e) => getOssFilePath(e.path)).toList();
    try {
      await Future.wait(futures);
      uploadResponse = await Repository.fetchFileSave('1', ossPaths);
    } catch (e) {
      print('upload erro $e');
      Future.microtask(() {
        yyDialog = yyNoticeFailedDialog(text: '上传失败！');
        Future.delayed(Duration(milliseconds: 1500), () {
          dialogDismiss(yyDialog);
        });
      });
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

// void selectBottomSheet(dynamic img){
// 	var yyDialog;
// 	yyDialog=yyBottomSheetDialog(
// 		leftText: '拍照',
// 		rightText:'从手机相册选择',
// 		leftPress: (){
// 			Future.microtask(() {
// 				dialogDismiss(yyDialog);
// 			});
// 			img.camera();
// 		},
// 		rightPress: (){
// 			Future.microtask(() {
// 				dialogDismiss(yyDialog);
// 			});
// 			img.loadAssets();
// 		}
// 	);
// }

Widget imgGridView(List<FileUploadItem> images,
    {int maxLength = 5,
    Function selectClick,
    Function delCallBack,
    bool initButton = true,
    Function cSelect,
    Function pSelect}) {
  return Container(
    height: ScreenUtil().setHeight(500),
    margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
    child: GridView.count(
      crossAxisCount: 3,
      childAspectRatio:
          ScreenUtil().setWidth(260) / ScreenUtil().setHeight(210),
      mainAxisSpacing: ScreenUtil().setHeight(10),
      crossAxisSpacing: ScreenUtil().setWidth(10),
      children: [
        ...List.generate(images.length, (index) {
          return new Stack(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(260),
                height: ScreenUtil().setHeight(210),
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1 / ScreenUtil.pixelRatio,
                        color: GlobalConfig.borderColor)),
                child: GestureDetector(
                  onTap: () {
                    ImagePickers.previewImage(
                        FlavorConfig.instance.imgPre + images[index].innerUrl);
                  },
                  child: Image.network(
                    FlavorConfig.instance.imgPre + images[index].innerUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              new Positioned(
                top: 0,
                right: 0,
                child: new Container(
                  width: ScreenUtil().setHeight(80),
                  height: ScreenUtil().setHeight(80),
                  child: new FlatButton(
                      //color: Colors.red,
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        delCallBack(index);
                      },
                      child: new Image.asset(
                        ImageHelper.wrapAssets('record_del.png'),
                        width: ScreenUtil().setHeight(50),
                        height: ScreenUtil().setHeight(50),
                      )),
                ),
              )
            ],
          );
        }),
        initButton
            ? (images.length < maxLength
                ? Container(
                    width: ScreenUtil().setWidth(260),
                    height: ScreenUtil().setHeight(210),
                    child: new FlatButton(
                      padding: EdgeInsets.all(0),
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        selectClick();
                      },
                      child: new Image.asset(
                        ImageHelper.wrapAssets('record_simg.png'),
                        width: ScreenUtil().setHeight(190),
                        height: ScreenUtil().setHeight(160),
                      ),
                    ),
                  )
                : SizedBox())
            : (images.length < maxLength
                ? Container(
                    width: ScreenUtil().setWidth(260),
                    height: ScreenUtil().setHeight(210),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setHeight(90),
                          child: gradualButton(
                            '拍照',
                            onTap: () {
                              cSelect();
                            },
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(20)),
                        Container(
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setHeight(90),
                          child: gradualButton(
                            '相册',
                            onTap: () {
                              pSelect();
                            },
                          ),
                        )
                      ],
                    ))
                : SizedBox())
      ],
    ),
  );
}

Widget eventImgGridView(List<EventImage> images,
    {int maxLength = 5,
    Function selectClick,
    Function delCallBack,
    bool initButton = true,
    Function cSelect,
    Function pSelect}) {
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
                    ImagePickers.previewImage(
                        FlavorConfig.instance.imgPre + images[index].imageUrl);
                  },
                  child: Image.network(
                    FlavorConfig.instance.imgPre + images[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // new Positioned(
              //   top: 0,
              //   right: 0,
              //   child: new Container(
              //     width: ScreenUtil().setHeight(80),
              //     height: ScreenUtil().setHeight(80),
              //     child: new FlatButton(
              //         //color: Colors.red,
              //         padding: EdgeInsets.all(0),
              //         onPressed: () {
              //           delCallBack(index);
              //         },
              //         child: new Image.asset(
              //           ImageHelper.wrapAssets('record_del.png'),
              //           width: ScreenUtil().setHeight(50),
              //           height: ScreenUtil().setHeight(50),
              //         )),
              //   ),
              // )
            ],
          );
        }),
        // initButton
        //     ? (images.length < maxLength
        //         ? Container(
        //             width: ScreenUtil().setWidth(220),
        //             height: ScreenUtil().setHeight(220),
        //             child: new FlatButton(
        //               padding: EdgeInsets.all(0),
        //               highlightColor: Colors.transparent,
        //               onPressed: () {
        //                 selectClick();
        //               },
        //               child: new Image.asset(
        //                 ImageHelper.wrapAssets('record_simg.png'),
        //                 width: ScreenUtil().setHeight(190),
        //                 height: ScreenUtil().setHeight(160),
        //               ),
        //             ),
        //           )
        //         : SizedBox())
        //     : (images.length < maxLength
        //         ? Container(
        //             width: ScreenUtil().setWidth(260),
        //             height: ScreenUtil().setHeight(210),
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: <Widget>[
        //                 Container(
        //                   width: ScreenUtil().setWidth(200),
        //                   height: ScreenUtil().setHeight(90),
        //                   child: gradualButton(
        //                     '拍照',
        //                     onTap: () {
        //                       cSelect();
        //                     },
        //                   ),
        //                 ),
        //                 SizedBox(height: ScreenUtil().setWidth(20)),
        //                 Container(
        //                   width: ScreenUtil().setWidth(200),
        //                   height: ScreenUtil().setHeight(90),
        //                   child: gradualButton(
        //                     '相册',
        //                     onTap: () {
        //                       pSelect();
        //                     },
        //                   ),
        //                 )
        //               ],
        //             ))
        //         : SizedBox()
        // )
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
