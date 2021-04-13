import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/model/speciment_box_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/dialog/custom_dialog.dart';
import 'package:huayin_logistics/ui/widget/select_items.dart';
import 'package:huayin_logistics/ui/widget/upload_image.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, showMsgToast, radiusButton, simpleRecordInput;
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/recrod_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

import 'apply_project.dart';

class EasyRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyRecordPage(context: context);
  }
}

class EasyRecordPage extends StatefulWidget {
  BuildContext context;
  EasyRecordPage({this.context});
  @override
  _EasyRecord createState() => _EasyRecord();
}

class _EasyRecord extends State<EasyRecordPage> {
  List<Map<String, String>> _projectItemArray = [];

  String _companyId = ''; //单位名称id

  TextEditingController _companyNameControll = TextEditingController(); //单位名称

  TextEditingController _barCodeControll = TextEditingController(); //条码号

  TextEditingController _recordNameControll = TextEditingController(); //姓名

  List<SelectItemRightListItem> _hasSelectItem = []; //已选择的项目

  List<SpecimentBox> _specimentBoxes = [];

  SpecimentBox _pickedBox;

  @override
  void initState() {
    super.initState();
    getBoxlist(widget.context);
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
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '简易录单', '外勤:', withName: true),
        body: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ProviderWidget<RecrodModel>(
                model: RecrodModel(context),
                builder: (cContext, model, child) {
                  return Column(
                    children: <Widget>[
                      _boxNum(),
                      SizedBox(
                          width: ScreenUtil.screenWidth,
                          height: ScreenUtil().setHeight(20)),
                      _baseInfo(),
                      ApplyProject(
                        updateProject: (items) {
                          _projectItemArray = items;
                        },
                      ),
                      UploadImgage(
                        submit: (data) {
                          submit(model, data);
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                    ],
                  );
                })),
      ),
    );
  }

  Widget _boxNum() {
    return InkWell(
        onTap: () {
          PopUtils.showPop(
              context: context,
              opacity: 0.5,
              child: SelectItems(
                title: '标本箱选择',
                nameList: _specimentBoxes.map((l) => l.boxNo).toList(),
                pickedName: _pickedBox.boxNo,
                confirm: (index) {
                  setState(() {
                    _pickedBox = _specimentBoxes[index];
                  });
                },
              ));
        },
        child: Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil().setHeight(140),
          color: Colors.white,
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _leftText('标本箱号'),
              Container(
                width: ScreenUtil().setWidth(200),
                child: _leftText(_pickedBox?.boxNo ?? ''),
              ), // 先写死
              new SizedBox(width: ScreenUtil().setWidth(140)),
              new Image(
                  color: Colors.black,
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setWidth(60),
                  image:
                      new AssetImage(ImageHelper.wrapAssets("right_more.png")),
                  fit: BoxFit.fill),
              radiusButton(text: '交接单', img: "transfer_ticket.png")
            ],
          ),
        ));
  }

  Widget _leftText(String title) {
    return Container(
      child: Text(title,
          style: TextStyle(
              color: DiyColors.normal_black, fontSize: ScreenUtil().setSp(40))),
    );
  }

  // 基本信息
  Widget _baseInfo() {
    return new Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
        child: new Column(
          children: <Widget>[
            simpleRecordInput(context,
                preText: '送检单位',
                hintText: '(必填)请选择送检单位',
                enbleInput: false,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: _companyNameControll, onTap: () {
              Navigator.pushNamed(context, RouteName.selectCompany)
                  .then((value) {
                //print('接收到的单位返回值：'+value.toString());
                if (value == null) return;
                var tempMap = jsonDecode(value.toString());
                _companyId = tempMap['custId'];
                _companyNameControll.text = tempMap['custName'];
              });
            }),
            simpleRecordInput(
              context,
              preText: '条码号',
              hintText: '请扫描或输入条码号',
              keyType: TextInputType.visiblePassword,
              onController: _barCodeControll,
              maxLength: 12,
              rightWidget: InkWell(
                  onTap: () {
                    var p = new BarcodeScanner(success: (String code) {
                      //print('条形码'+code);
                      if (code == '-1') return;
                      _barCodeControll.text = code;
                    });
                    p.scanBarcodeNormal();
                  },
                  child: radiusButton(text: '扫码', img: "scan.png")),
            ),
            simpleRecordInput(context,
                preText: '姓名',
                hintText: '请输入姓名',
                maxLength: 50,
                onController: _recordNameControll,
                needBorder: false)
          ],
        ));
  }

  getBoxlist(context) async {
    /// 先写死
    MineModel model = Provider.of<MineModel>(context);
    String labId = '82858490362716212';
    String userId = model.user.user.id;
    var response;
    try {
      response = await Repository.fetchBoxList(labId, userId);
    } catch (e) {
      print('getBoxlist error $e');
      return;
    }
    _specimentBoxes = List<SpecimentBox>.from(
        response.data.map((r) => SpecimentBox.fromJson(r)));
    _pickedBox = _specimentBoxes.first;
    setState(() {});
  }

  //校验输入
  bool _checkLoginInput(List<FileUploadItem> _imageList) {
    if (!isRequire(_companyNameControll.text)) {
      showMsgToast('请选择送检单位！');
      return false;
    }
    if (!isRequire(_barCodeControll.text)) {
      showMsgToast('条码号必填项，请维护！');
      return false;
    }
    if (_barCodeControll.text.length != 12) {
      showMsgToast('条码号长度必须为12位！', context: context);
      return false;
    }
    // if(_barCodeControll.text.substring(10,12)!='00'){
    // 	showMsgToast(
    // 		'条码号必须以00结尾！',
    // 		context: context
    // 	);
    // 	return false;
    // }
    if (_imageList.length <= 0) {
      showMsgToast('请上传照片！');
      return false;
    }
    return true;
  }

  submit(model, List<FileUploadItem> _imageList) {
    if (!_checkLoginInput(_imageList)) return;
    List<Map<String, String>> tempList = [];

    for (var x in _imageList) {
      Map<String, String> tempMap = {};
      // tempMap['name']=x.fileName;
      // tempMap['url']=x.innerUrl;
      tempMap['fileId'] = x.id;
      tempList.add(tempMap);
    }
    model.recordSavaSubmitData([
      {
        "apply": {
          "inspectionUnitName": _companyNameControll.text,
          "inspectionUnitId": _companyId,
          "barCode": _barCodeControll.text,
          "name": _recordNameControll.text
        },
        "imageItems": tempList,
        "items": _projectItemArray
      }
    ]).then((val) {
      if (val) {
        Future.microtask(() {
          var yyDialog;
          yyDialog = yyNoticeDialog(text: '提交成功');
          Future.delayed(Duration(milliseconds: 1500), () {
            dialogDismiss(yyDialog);
            _barCodeControll.text = '';
            _recordNameControll.text = '';
            _projectItemArray.clear();
            _hasSelectItem.clear();
            _imageList.clear();
            setState(() {
              _projectItemArray = _projectItemArray;
              _imageList = _imageList;
            });
          });
        });
      }
    });
  }
}
