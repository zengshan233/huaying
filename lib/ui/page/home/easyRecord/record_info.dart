import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/model/speciment_box_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/ui/widget/select_items.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/recrod_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class RecordInfo extends StatefulWidget {
  RecrodModel model;
  Function(Map) updateInfo;
  Function(Map) onBarcodeSubmit;
  TextEditingController barCodeControll; //条码号

  TextEditingController recordNameControll; //姓名
  RecordInfo(
      {this.model,
      this.updateInfo,
      this.barCodeControll,
      this.recordNameControll,
      this.onBarcodeSubmit});
  @override
  _RecordInfo createState() => _RecordInfo();
}

class _RecordInfo extends State<RecordInfo> {
  String _companyId = ''; //单位名称id

  TextEditingController _companyNameControll = TextEditingController(); //单位名称

  List<SpecimentBox> _specimentBoxes = [];

  SpecimentBox _pickedBox;

  SelectCompanyListItem _pickedCompanyItem;

  DeliveryDetailModel boxDetail;

  String _labId;

  String _userId;

  bool _needConfirm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getBoxlist());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _boxNum(),
          SizedBox(
              width: ScreenUtil.screenWidth,
              height: ScreenUtil().setHeight(20)),
          _baseInfo(),
        ],
      ),
    );
  }

  Widget _boxNum() {
    return InkWell(
        onTap: () {
          PopUtils.showPop(
              opacity: 0.5,
              child: SelectItems(
                title: '标本箱选择',
                nameList: _specimentBoxes.map((l) => l.boxNo).toList(),
                pickedName: _pickedBox.boxNo,
                confirm: (index) {
                  if (_pickedBox.boxNo == _specimentBoxes[index].boxNo) {
                    return;
                  }
                  setState(() {
                    _pickedBox = _specimentBoxes[index];
                  });
                  updateInfo();
                  getDetail(_pickedBox.boxNo);
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
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.deliveryDetail,
                        arguments: {
                          "boxNo": _pickedBox?.boxNo ?? '',
                          'detail': boxDetail,
                          "updateStatus": (DeliveryDetailModel _boxDetail) {
                            boxDetail = _boxDetail;
                            checkConfirm();
                          }
                        });
                  },
                  child: radiusButton(text: '交接单', img: "transfer_ticket.png"))
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
                onChange: (v) => updateInfo(),
                onController: _companyNameControll,
                onTap: () {
                  if (_needConfirm) {
                    PopUtils.showTip(
                        title: '提示',
                        message: '存在未确认的交接单，请确认后再更换送检单位',
                        confirm: () {
                          Navigator.pushNamed(
                              context, RouteName.deliveryDetail, arguments: {
                            "boxNo": _pickedBox?.boxNo ?? '',
                            'detail': boxDetail
                          }).then((value) => checkConfirm(showLoading: true));
                        });
                    return;
                  }

                  Navigator.pushNamed(context, RouteName.selectCompany,
                      arguments: {'item': _pickedCompanyItem}).then((value) {
                    //print('接收到的单位返回值：'+value.toString());
                    if (value == null) return;
                    var tempMap = jsonDecode(value.toString());
                    _companyId = tempMap['custId'];
                    _companyNameControll.text = tempMap['custName'];
                    _pickedCompanyItem = value;
                  });
                }),
            simpleRecordInput(
              context,
              preText: '条码号',
              hintText: '请扫描或输入条码号',
              keyType: TextInputType.visiblePassword,
              onController: widget.barCodeControll,
              maxLength: 12,
              onChange: (v) => updateInfo(),
              onSubmitted: (v) => onBarcodeSubmit(),
              rightWidget: InkWell(
                  onTap: () {
                    var p = new BarcodeScanner(success: (String code) {
                      //print('条形码'+code);
                      if (code == '-1') return;
                      widget.barCodeControll.text = code;
                    });
                    p.scanBarcodeNormal();
                  },
                  child: radiusButton(text: '扫码', img: "scan.png")),
            ),
            widget.recordNameControll == null
                ? Container()
                : simpleRecordInput(context,
                    preText: '姓名',
                    hintText: '请输入姓名',
                    maxLength: 50,
                    onChange: (v) => updateInfo(),
                    onController: widget.recordNameControll,
                    needBorder: false)
          ],
        ));
  }

  getBoxlist() async {
    /// 先写死
    MineModel model = Provider.of<MineModel>(context, listen: false);
    _labId = '82858490362716212';
    _userId = model.user.user.id;
    KumiPopupWindow pop = PopUtils.showLoading();
    var response;
    try {
      response = await Repository.fetchBoxList(_labId, _userId);
    } catch (e) {
      print('getBoxlist error $e');
      showToast(e.toString());
      Navigator.pop(context);
      return;
    }
    _specimentBoxes = List<SpecimentBox>.from(
        response.data.map((r) => SpecimentBox.fromJson(r)));
    await getDetail(_specimentBoxes.first.boxNo, pop: pop);
    _pickedBox = _specimentBoxes.first;
    updateInfo();
    setState(() {});
    checkConfirm();
  }

  Future getDetail(String boxNo,
      {KumiPopupWindow pop, bool showLoading = true}) async {
    var responseId;
    DeliveryDetailModel detailResponse;
    if (showLoading) {
      pop = pop ?? PopUtils.showLoading();
    }
    try {
      responseId = await Repository.fetchDeliveryId(
          boxNo: boxNo, labId: _labId, recordId: _userId);
    } catch (e) {
      print('fetchDeliveryId error $e');
      showToast(e.toString());
      pop?.dismiss?.call(context);
      return;
    }
    print('responseId $responseId');
    if (responseId == null) {
      pop?.dismiss?.call(context);

      return;
    }
    try {
      detailResponse = await Repository.fetchDeliveryDetail(
          labId: _labId, id: responseId.toString());
    } catch (e) {
      print('fetchDeliveryDetail error $e');
      showToast(e.toString());
      pop?.dismiss?.call(context);

      return;
    }
    pop?.dismiss?.call(context);
    setState(() {
      boxDetail = detailResponse;
      Items item = detailResponse.items.last;
      _pickedCompanyItem = SelectCompanyListItem.fromParams(
          custName: item.inspectionUnitName, custId: item.inspectionUnitId);
      _companyId = item.inspectionUnitId;
      _companyNameControll.text = item.inspectionUnitName;
    });
    checkConfirm();
  }

  Future checkConfirm({bool showLoading = false}) async {
    bool response;
    KumiPopupWindow pop;
    if (showLoading) {
      pop = PopUtils.showLoading();
    }
    try {
      response = await Repository.fetchCheckCompany(
          boxNo: _pickedBox.boxNo,
          labId: _labId,
          recordId: _userId,
          inspectionUnitId: _companyId);
    } catch (e) {
      print('checkConfirm error $e');
      pop?.dismiss?.call(context);
      return;
    }
    pop?.dismiss?.call(context);
    _needConfirm = response;
  }

  updateInfo() {
    if (widget.updateInfo == null) {
      return;
    }
    Map info = {
      "inspectionUnitName": _companyNameControll.text,
      "inspectionUnitId": _companyId,
      "barCode": widget.barCodeControll.text,
      "boxNo": _pickedBox.boxNo,
      "joinId": boxDetail?.id,
      "name": widget.recordNameControll?.text ?? ''
    };
    widget.updateInfo(info);
  }

  onBarcodeSubmit() {
    if (widget.onBarcodeSubmit == null) {
      return;
    }
    Map info = {
      "inspectionUnitName": _companyNameControll.text,
      "inspectionUnitId": _companyId,
      "barCode": widget.barCodeControll.text,
      "boxNo": _pickedBox.boxNo,
      "joinId": boxDetail?.id,
    };
    widget.onBarcodeSubmit(info);
  }
}
