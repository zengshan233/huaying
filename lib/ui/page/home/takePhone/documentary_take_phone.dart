import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show
        appBarWithName,
        inputPreText,
        radiusButton,
        recordInput,
        showMsgToast,
        simpleRecordInput;
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/scanner.dart';
import 'package:huayin_logistics/utils/device_utils.dart';
import 'package:huayin_logistics/view_model/home/documentary_take_phone_model.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

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
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    child: Column(
                      children: <Widget>[
                        _infoFrom(model),
                        searching
                            ? _image()
                            : UploadImgage(
                                imageList: _imageList,
                                isRequire: false,
                                submit: (data) {
                                  print('data $data');
                                  _imageList = data;
                                  submit(model);
                                },
                              ),
                      ],
                    ),
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
      MineModel userModel = Provider.of<MineModel>(context, listen: false);
      String labId = userModel.labId;
      String userId = userModel.user.user.id;
      model
          .documentaryTakePhoneData(
              context: context,
              barCode: _barCodeControll.text,
              labId: labId,
              recordId: userId)
          .then((res) {
        if (res != null) {
          _companyNameControll.text = res['apply']['inspectionUnitName'];
          _boxControll.text = res['boxNo'];
          _dateControll.text =
              res['apply']['recordTime'].toString().substring(0, 16);
          var tempImgList = res['images'] == null ? [] : res['images'];
          for (var x in tempImgList) {
            var tempObj = {};
            if (x['url'] == null || x['fileId'] == null) continue;
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
    return Column(
      children: <Widget>[
        Container(
            color: Colors.white,
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
            margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
            child: simpleRecordInput(
              context,
              preText: '条码编号',
              hintText: '请扫描或输入条码编号',
              keyType: TextInputType.visiblePassword,
              onController: _barCodeControll,
              maxLength: 12,
              isRquire: true,
              onSubmitted: (v) {
                _serchInfoByBarCode(model);
              },
              rightWidget: InkWell(
                  onTap: () async {
                    DeviceUtils.scanBarcode(
                      confirm: (code) {
                        if (code != null) {
                          _barCodeControll.text = code;
                          _serchInfoByBarCode(model);
                        }
                      },
                    );
                  },
                  child: radiusButton(text: '扫码', img: "scan.png")),
            )),
        Container(
            color: Colors.white,
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
            child: new Column(
              children: [
                simpleRecordInput(context,
                    preText: '送检单位',
                    hintText: '送检单位',
                    onController: _companyNameControll,
                    isRquire: false,
                    enbleInput: false,
                    onTap: () {}),
                simpleRecordInput(context,
                    preText: '标本箱号',
                    hintText: '标本箱号',
                    onController: _boxControll,
                    isRquire: false,
                    enbleInput: false,
                    onTap: () {}),
                simpleRecordInput(context,
                    preText: '录入时间',
                    hintText: '录入时间',
                    onController: _dateControll,
                    isRquire: false,
                    needBorder: false,
                    enbleInput: false,
                    onTap: () {})
              ],
            ))
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
                inputPreText(preText: '图片', isRquire: false),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                  child: Text('最多可上传5张图片',
                      style: TextStyle(
                          color: Color.fromRGBO(93, 164, 255, 1),
                          fontSize: ScreenUtil().setSp(30))),
                )
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
