import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, radiusButton, recordInput, showMsgToast;
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/view_model/home/documentary_take_phone_model.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';

class DocumentaryTakePhone extends StatefulWidget {
  @override
  _DocumentaryTakePhone createState() => _DocumentaryTakePhone();
}

class _DocumentaryTakePhone extends State<DocumentaryTakePhone> {
  List<FileUploadItem> _imageList = [];

  TextEditingController _companyNameControll = TextEditingController(); //单位名称

  TextEditingController _barCodeControll = TextEditingController(); //条码号

  TextEditingController _boxControll = TextEditingController(); //标本箱号

  TextEditingController _dateControll = TextEditingController(); //录入时间

  bool searching = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: appBarWithName(context, '单据拍照', '外勤:', withName: true),
        body: new SingleChildScrollView(
            child: ProviderWidget<DocumentaryTakePhoneModel>(
                model: DocumentaryTakePhoneModel(context),
                builder: (cContext, model, child) {
                  return Column(
                    children: <Widget>[
                      _infoFrom(model),
                      searching
                          ? _image()
                          : UploadImgage(
                              imageList: _imageList,
                              submit: (data) {
                                print('data $data');
                                _imageList = data;
                                submit(model);
                              },
                            ),
                    ],
                  );
                })),
      ),
    );
  }

  //根据条码号查询信息
  void _serchInfoByBarCode(DocumentaryTakePhoneModel model) {
    if (_barCodeControll.text.isNotEmpty) {
      _imageList.clear();
      setState(() {
        searching = true;
      });
      _companyNameControll.text = "";
      _dateControll.text = "";
      _boxControll.text = "";
      model
          .documentaryTakePhoneData(context, _barCodeControll.text)
          .then((res) {
        if (res != null) {
          //print('返回数据'+res.toString());
          var jsonRes = jsonDecode(res.toString());
          _companyNameControll.text = jsonRes['apply']['inspectionUnitName'];
          // _boxControll.text = jsonRes['apply']['inspectionUnitName'];
          _dateControll.text =
              jsonRes['apply']['recordTime'].toString().substring(0, 16);
          var tempImgList = jsonRes['images'] == null ? [] : jsonRes['images'];
          //print(tempImgList.toString());
          for (var x in tempImgList) {
            var tempObj = {};
            if (x['url'] == null || x['fileId'] == null) continue;
            //print(x['fileId'].toString());
            tempObj['fileName'] = x['name'].toString();
            tempObj['innerUrl'] = x['url'].toString();
            tempObj['id'] = x['fileId'].toString();
            _imageList.add(FileUploadItem.fromJson(tempObj));
          }
          setState(() {
            _imageList = _imageList;
            searching = false;
          });
        }
      });
    }
  }

  //信息表单
  Widget _infoFrom(DocumentaryTakePhoneModel model) {
    return new Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
            child: recordInput(context,
                preText: '条码号',
                hintText: '请扫描或输入条码号',
                onController: _barCodeControll,
                maxLength: 12,
                keyType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.search,
                rightWidget: InkWell(
                    onTap: () {
                      var p = new BarcodeScanner(success: (String code) {
                        //print('条形码'+code);
                        if (code == '-1') return;
                        _barCodeControll.text = code;
                        _serchInfoByBarCode(model);
                      });
                      p.scanBarcodeNormal();
                    },
                    child: radiusButton(text: '扫码', img: "scan.png")),
                onSubmitted: (v) {
              _serchInfoByBarCode(model);
            })),
        recordInput(context,
            preText: '送检单位',
            hintText: '送检单位',
            onController: _companyNameControll,
            isRquire: false,
            enbleInput: false,
            onTap: () {}),
        recordInput(context,
            preText: '标本箱号',
            hintText: '标本箱号',
            onController: _boxControll,
            isRquire: false,
            enbleInput: false,
            onTap: () {}),
        recordInput(context,
            preText: '录入时间',
            hintText: '录入时间',
            onController: _dateControll,
            isRquire: false,
            needBorder: false,
            enbleInput: false,
            onTap: () {})
      ],
    );
  }

  Widget _image() {
    return Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
      height: ScreenUtil().setHeight(140),
      color: Colors.white,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
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
            opacity: 0.3,
            duration: Duration(milliseconds: 500),
            child: Container(
                child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                    child: radiusButton(text: '拍照', img: "shot.png")),
                Container(child: radiusButton(text: '上传', img: "pic.png")),
              ],
            )),
          ),
        ],
      ),
    );
  }

  //校验输入
  bool _checkLoginInput() {
    if (!isRequire(_barCodeControll.text)) {
      showMsgToast('条码号必填项，请维护！');
      return false;
    }
    if (_imageList.length <= 0) {
      showMsgToast('请上传照片！');
      return false;
    }
    return true;
  }

  submit(model) {
    List<Map<String, String>> tempList = [];

    for (var x in _imageList) {
      Map<String, String> tempMap = {};
      // tempMap['name']=x.fileName;
      // tempMap['url']=x.innerUrl;
      tempMap['fileId'] = x.id;
      tempList.add(tempMap);
    }
    model.documentaryTakePhoneSubmitData([
      {
        "barCode": _barCodeControll.text,
        "imageItems": tempList,
      }
    ]).then((val) {
      if (val) {
        Future.microtask(() {
          var yyDialog;
          yyDialog = yyNoticeDialog(text: '提交成功');
          Future.delayed(Duration(milliseconds: 1500), () {
            dialogDismiss(yyDialog);
          });
        });
      }
    });
    ;
  }
}
