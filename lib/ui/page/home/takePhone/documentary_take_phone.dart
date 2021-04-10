import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show
        appBarComon,
        appBarWithName,
        gradualButton,
        radiusButton,
        recordCard,
        recordInput,
        showMsgToast;
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/img_picker.dart';
import 'package:huayin_logistics/view_model/home/documentary_take_phone_model.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';

class DocumentaryTakePhone extends StatefulWidget {
  @override
  _DocumentaryTakePhone createState() => _DocumentaryTakePhone();
}

class _DocumentaryTakePhone extends State<DocumentaryTakePhone> {
  var _imageList = new List<FileUploadItem>();

  TextEditingController _companyNameControll = TextEditingController(); //单位名称

  TextEditingController _barCodeControll = TextEditingController(); //条码号

  TextEditingController _recordNameControll = TextEditingController(); //姓名

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
        appBar: appBarWithName(context, '单据拍照', '外勤:张三'),
        body: new SingleChildScrollView(
            child: ProviderWidget<DocumentaryTakePhoneModel>(
                model: DocumentaryTakePhoneModel(context),
                builder: (cContext, model, child) {
                  return Column(
                    children: <Widget>[
                      _infoFrom(model),
                      UploadImgage(
                        submit: (data) {
                          print('data $data');
                        },
                      ),
                    ],
                  );
                })),
      ),
    );
  }

  //根据条码号查询信息
  void _serchInfoByBarCode(model) {
    if (_barCodeControll.text.isNotEmpty) {
      _imageList.clear();
      model.documentaryTakePhoneData(_barCodeControll.text).then((res) {
        if (res != null) {
          //print('返回数据'+res.toString());
          var jsonRes = jsonDecode(res.toString());
          _companyNameControll.text = jsonRes['apply']['inspectionUnitName'];
          _recordNameControll.text =
              jsonRes['apply']['name'] == null ? '' : jsonRes['apply']['name'];
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
          print(_imageList.toString());
          setState(() {
            _imageList = _imageList;
          });
        }
      });
    }
  }

  //信息表单
  Widget _infoFrom(model) {
    return new Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
            child: recordInput(context,
                preText: '条码号',
                hintText: '请扫描或输入条码号',
                onController: _barCodeControll,
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
            onController: _recordNameControll,
            isRquire: false,
            enbleInput: false,
            onTap: () {}),
        recordInput(context,
            preText: '录入时间',
            hintText: '录入时间',
            onController: _recordNameControll,
            isRquire: false,
            needBorder: false,
            enbleInput: false,
            onTap: () {})
      ],
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
}
