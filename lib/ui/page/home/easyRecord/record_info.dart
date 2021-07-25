import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/model/speciment_box_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/device_utils.dart';
import 'package:huayin_logistics/utils/events_utils.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/recrod_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class RecordInfo extends StatefulWidget {
  final RecrodModel model;
  final Function(Map) updateInfo;
  final Future Function(Map, bool) onBarcodeSubmit;
  final TextEditingController barCodeControll;
  final FocusNode barNode;
  final FocusNode boxNode;
  final TextEditingController recordNameControll;
  final Function clearData;
  final Function(bool) onScan;
  RecordInfo(
      {this.model,
      this.updateInfo,
      @required this.barCodeControll,
      this.recordNameControll,
      @required this.barNode,
      @required this.boxNode,
      this.onBarcodeSubmit,
      this.onScan,
      this.clearData});
  @override
  _RecordInfo createState() => _RecordInfo();
}

class _RecordInfo extends State<RecordInfo> {
  String _companyId = ''; //单位名称id
  FocusNode _nameNode = FocusNode();

  TextEditingController _companyNameControll = TextEditingController(); //单位名称

  TextEditingController _boxControll = TextEditingController(); //单位名称
  List<SpecimentBox> _specimentBoxes;
  SpecimentBox _pickedBox;

  SelectCompanyListItem _pickedCompanyItem;

  DeliveryDetailModel boxDetail;

  String _joinId;

  String _labId;

  String _userId;

  bool _hasConfirm = true;

  bool _boxFocus = false;

  String _fetchBoxError;

  Function _checkBoxFunc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getBoxlist());
    EventBus.instance.addListener(EventKeys.updateBoxDetail, (map) {
      _checkBox(showLoading: map["updateBoxDetail"]);
    });

    widget.boxNode.addListener(() async {
      if (widget.boxNode.hasFocus) {
        _boxFocus = true;
      } else {
        await Future.delayed(Duration(milliseconds: 200));
        _boxFocus = false;
      }
    });

    widget.barNode.addListener(() {
      if (widget.barNode.hasFocus && _boxFocus) {
        _checkBox(showLoading: true);
      }
    });
    _nameNode.addListener(() {
      if (_nameNode.hasFocus && _boxFocus) {
        _checkBox(showLoading: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    EventBus.instance.removeListener(EventKeys.updateBoxDetail);
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

  _checkBox({bool showLoading = true, KumiPopupWindow pop}) {
    String _boxNo = _boxControll.text;
    if (_boxNo.isEmpty) {
      _clearData();
      updateInfo();
      onBarcodeSubmit(add: false);
      return;
    }
    int index = -1;
    if (_specimentBoxes != null) {
      index = _specimentBoxes.indexWhere((s) => s.boxNo == _boxNo);
    } else {
      if (_fetchBoxError != null) {
        PopUtils.toast(_fetchBoxError);
      } else {
        KumiPopupWindow _pop = PopUtils.showLoading();
        _checkBoxFunc = () {
          _checkBox(pop: _pop);
        };
      }

      return;
    }
    if (!mounted) {
      return;
    }
    if (index > -1) {
      setState(() {
        _pickedBox = _specimentBoxes[index];
      });
      updateInfo();
      onBarcodeSubmit(add: false);
      getDetail(box: _pickedBox, showLoading: showLoading, pop: pop);
    } else {
      pop?.dismiss?.call(context);
      showMsgToast('标本箱不存在，请检查输入的标本箱号是否正确!');
      _clearData();
      onBarcodeSubmit(add: false);
      updateInfo();
    }
  }

  Widget _boxNum() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
        child: simpleRecordInput(context,
            preText: '标本箱号',
            hintText: '请扫描或输入标本箱号',
            keyType: TextInputType.text,
            onController: _boxControll,
            maxLength: 12,
            isRquire: true,
            focusNode: widget.boxNode,
            onChange: (v) {
              updateInfo();
            },
            onSubmitted: (v) => _checkBox(),
            rightWidget: InkWell(
                onTap: () {
                  if (boxDetail == null) {
                    showMsgToast('暂无交接单');
                    return;
                  }
                  Navigator.pushNamed(context, RouteName.deliveryDetail,
                      arguments: {
                        "id": _joinId,
                        'detail': boxDetail,
                        "updateStatus": (DeliveryDetailModel _boxDetail) {
                          boxDetail = _boxDetail;
                          checkConfirm();
                        }
                      });
                },
                child: radiusButton(text: '交接单', img: "transfer_ticket.png"))));
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
                isRquire: true,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onChange: (v) => updateInfo(),
                onController: _companyNameControll,
                onTap: () {
                  if (_boxControll.text.isEmpty) {
                    showMsgToast('请先输入标本箱号！');
                    return;
                  }
                  if (widget.boxNode.hasFocus) {
                    _checkBox(showLoading: true);
                    return;
                  }
                  String _boxNo = _boxControll.text;
                  int index =
                      _specimentBoxes.indexWhere((s) => s.boxNo == _boxNo);
                  if (index == -1) {
                    showMsgToast('标本箱不存在，请检查输入的标本箱号是否正确!');
                    return;
                  }
                  if (!_hasConfirm) {
                    yyAlertDialogWithDivider(
                        context: context,
                        tipList: ["当前标本箱的交接单未确认，", "请确认后再更换送检单位"],
                        success: () async {
                          await Future.delayed(Duration(milliseconds: 100));
                          Navigator.pushNamed(context, RouteName.deliveryDetail,
                              arguments: {
                                "id": _joinId,
                                'detail': boxDetail,
                                "updateStatus":
                                    (DeliveryDetailModel _boxDetail) {
                                  boxDetail = _boxDetail;
                                  checkConfirm();
                                }
                              });
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
                    updateInfo();
                    onBarcodeSubmit(add: false);
                  });
                }),
            simpleRecordInput(
              context,
              preText: '条码编号',
              hintText: '请扫描或输入条码编号',
              keyType: TextInputType.visiblePassword,
              onController: widget.barCodeControll,
              maxLength: 12,
              isRquire: true,
              onChange: (v) => updateInfo(),
              onSubmitted: (v) => onBarcodeSubmit(),
              focusNode: widget.barNode ?? FocusNode(),
              rightWidget: Row(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        if (widget.barNode.hasFocus) {
                          widget.barNode.unfocus();
                        } else {
                          FocusScope.of(context).requestFocus(widget.barNode);
                        }
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                        child: Image.asset(
                          ImageHelper.wrapAssets('keyboard.png'),
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                          fit: BoxFit.scaleDown,
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        widget.barCodeControll.clear();
                        if (!widget.barNode.hasFocus) {
                          FocusScope.of(context).requestFocus(widget.barNode);
                        }
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                        child: Image.asset(
                          ImageHelper.wrapAssets('delete.png'),
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                          fit: BoxFit.scaleDown,
                        ),
                      )),
                  InkWell(
                      onTap: () async {
                        widget.barCodeControll.clear();
                        widget.onScan?.call(false);
                        DeviceUtils.scanBarcode(
                            multi: widget.onBarcodeSubmit != null,
                            confirm: (code) {
                              if (code != null) {
                                if (widget.onBarcodeSubmit == null) {
                                  widget.barCodeControll.text = code;
                                }
                                updateInfo();
                                onBarcodeSubmit(barCode: code);
                              }
                            },
                            pop: () {
                              widget.onScan?.call(true);
                            });
                      },
                      child: radiusButton(text: '扫码', img: "scan.png"))
                ],
              ),
            ),
            widget.recordNameControll == null
                ? Container()
                : simpleRecordInput(context,
                    preText: '客户姓名',
                    hintText: '请输入客户姓名',
                    maxLength: 50,
                    focusNode: _nameNode,
                    onChange: (v) => updateInfo(),
                    onController: widget.recordNameControll,
                    needBorder: false)
          ],
        ));
  }

  getBoxlist() async {
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    _labId = userModel.labId;
    _userId = userModel.user?.user?.id;
    var response;
    try {
      response = await Repository.fetchBoxList(_labId, _userId);
    } catch (e, s) {
      print('getBoxlist error $e');
      _fetchBoxError = PopUtils.showError(e, s);
      return;
    }
    _specimentBoxes = List<SpecimentBox>.from(
        response.data.map((r) => SpecimentBox.fromJson(r)));
    _checkBoxFunc?.call();
  }

  Future getDetail(
      {SpecimentBox box, KumiPopupWindow pop, bool showLoading = true}) async {
    DeliveryDetailModel detailResponse;
    if (showLoading) {
      pop = pop ?? PopUtils.showLoading();
    }
    if (box != null) {
      try {
        _joinId = await Repository.fetchDeliveryId(
            boxId: box.id, boxNo: box.boxNo, labId: _labId, recordId: _userId);
      } catch (e, s) {
        print('fetchDeliveryId error $e');
        PopUtils.showError(e, s);

        pop?.dismiss?.call(context);
        return;
      }
    }
    if (_joinId == null || _joinId == 'null') {
      pop?.dismiss?.call(context);
      _clearData();
      updateInfo();
      onBarcodeSubmit(add: false);
      return;
    }
    try {
      detailResponse = await Repository.fetchDeliveryDetail(
          labId: _labId, id: _joinId.toString());
    } catch (e, s) {
      print('fetchDeliveryDetail error $e');
      PopUtils.showError(e, s);

      pop?.dismiss?.call(context);
      return;
    }
    pop?.dismiss?.call(context);
    setState(() {
      boxDetail = detailResponse;
      Items item = detailResponse.items.first;
      _pickedCompanyItem = SelectCompanyListItem.fromParams(
          custName: item.inspectionUnitName, custId: item.inspectionUnitId);
      _companyId = item.inspectionUnitId;
      _companyNameControll.text = item.inspectionUnitName;
    });
    updateInfo();
    onBarcodeSubmit(add: false);
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
          boxNo: boxDetail.boxNo,
          labId: _labId,
          recordId: _userId,
          inspectionUnitId: _companyId);
    } catch (e) {
      print('checkConfirm error $e');
      pop?.dismiss?.call(context);
      return;
    }
    pop?.dismiss?.call(context);
    _hasConfirm = response;
  }

  updateInfo() {
    if (widget.updateInfo == null) {
      return;
    }
    Map info = {
      "inspectionUnitName": _companyNameControll.text,
      "inspectionUnitId": _companyId,
      "barCode": widget.barCodeControll.text,
      "boxNo": _boxControll.text,
      "joinId": boxDetail?.id,
      "boxId": _pickedBox?.id,
      "name": widget.recordNameControll?.text ?? ''
    };
    widget.updateInfo(info);
  }

  onBarcodeSubmit({bool add = true, String barCode}) {
    if (widget.onBarcodeSubmit == null) {
      return;
    }
    Map info = {
      "inspectionUnitName": _companyNameControll.text,
      "inspectionUnitId": _companyId,
      "barCode": barCode ?? widget.barCodeControll.text,
      "boxNo": _boxControll.text,
      "boxId": _pickedBox?.id,
      "joinId": boxDetail?.id,
    };
    widget.onBarcodeSubmit(info, add);
  }

  _clearData() {
    if (!mounted) {
      return;
    }
    setState(() {
      _hasConfirm = true;
      boxDetail = null;
      _pickedCompanyItem = null;
      _companyId = null;
      _companyNameControll.text = '';
    });
  }
}
