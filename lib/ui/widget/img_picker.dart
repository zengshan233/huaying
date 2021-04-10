import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/storage_manager.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/login_data_model.dart';
import 'package:huayin_logistics/ui/helper/gaps.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:image_pickers/UIConfig.dart';
import 'package:image_pickers/image_pickers.dart';
//import 'package:image_pickers/CorpConfig.dart';
import 'package:image_pickers/Media.dart';

class ImgPicker {
  int maxImages;
  Function(List<FileUploadItem>) success;
  ImgPicker({this.maxImages = 5, @required this.success});
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
    Future<FormData> getImg() async {
      var formData = FormData();
      for (var x in resultList) {
        formData.files.add(MapEntry(
          "fileuploads",
          await MultipartFile.fromFile(x.path,
              filename:
                  x.path.substring(x.path.lastIndexOf("/") + 1, x.path.length)),
        ));
      }
      return formData;
    }

    FormData data = await getImg();
    imageUpload(data);
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
    imageUpload(formData);
  }

  void imageUpload(FormData formData) async {
    // 	'fileuploads':1,// [文件类型] — 1.图片， 2.pdf ， 3.word, 4.excel. 4.配置文件, 99.其他
    // 	'businessType':1,//[业务类型] — 属于那种业务的文件： 1.报告单pdf， 2.常规结果图片, 3.用户签名图片、公司logo、二维码图片
    print("imageUploadimageUploadimageUploadimageUpload $formData");
    var userMap = StorageManager.localStorage.getItem('userInfo');
    var userInfo;
    if (userMap != null) {
      if (userMap['user'] is User) {
        userMap['user'] = userMap['user'].toJson();
      }
      userInfo = LoginDataModel.fromJson(userMap);
    }
    var dio = Dio(BaseOptions(
        connectTimeout: 1000000,
        receiveTimeout: 1000000,
        headers: {'token': userInfo?.token}));
    var yyDialog;
    yyDialog = yyProgressDialogBody(text: '正在上传...');
    var response;
    try {
      response = await dio.post<Map<String, dynamic>>(
          FlavorConfig.instance.apiHost +
              "/i8n/files/report?fileType=1&businessType=1",
          data: formData);
    } catch (e) {
      Future.microtask(() {
        yyDialog = yyNoticeFailedDialog(text: '上传失败！');
        Future.delayed(Duration(milliseconds: 1500), () {
          dialogDismiss(yyDialog);
        });
      });
    }
    dialogDismiss(yyDialog);
    print('图片' + response.data.toString()); //注意采坑此处response.data与response一样
    var res = FileUpload.fromJson(response.data);
    if (res.code == 0) {
      success(res.data);
    } else {
      Future.microtask(() {
        yyDialog = yyNoticeFailedDialog(text: '上传失败！');
        Future.delayed(Duration(milliseconds: 1500), () {
          dialogDismiss(yyDialog);
        });
      });
    }
  }
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
                        FlavorConfig.instance.imgPre + images[index].imageUrl);
                  },
                  child: Image.network(
                    FlavorConfig.instance.imgPre + images[index].imageUrl,
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
