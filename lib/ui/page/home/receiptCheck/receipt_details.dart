import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/check_data_model.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/receiptCheck/receipt_form.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget;
import 'package:huayin_logistics/ui/widget/info_form_item.dart';
import 'package:huayin_logistics/view_model/home/check_model.dart';

class ReceiptDetail extends StatefulWidget {
  final int status;
  final String receiptId;
  final String applyId;
  final Function updateList;

  const ReceiptDetail(
      {Key key, this.status, this.receiptId, this.applyId, this.updateList})
      : super(key: key);

  @override
  _ReceiptDetail createState() => _ReceiptDetail();
}

class _ReceiptDetail extends State<ReceiptDetail> {
  EventFeedback feedback;
  TextEditingController _replyMessageController;
  bool showInfo = false;
  int status;
  String statusName;
  @override
  void initState() {
    super.initState();
    _replyMessageController = TextEditingController();
    status = widget.status;
    statusName = checkStatus[status];
  }

  @override
  void dispose() {
    super.dispose();
    _replyMessageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CheckModel>(
      builder: (context, model, child) {
        return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: appBarWithName(context, '单据详情', '外勤:', withName: true),
              body: new SingleChildScrollView(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ReceiptForm(
                        model: model, status: status, statusName: statusName),
                    _projects(model),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    _subInfo(model),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    status == 2 ? confirm() : Container(),
                    SizedBox(height: ScreenUtil().setHeight(80)),
                  ],
                ),
              ),
            ));
      },
      model: CheckModel(context: context),
      onModelReady: (model) {
        model.getCheckDetail(widget.receiptId);
      },
    );
  }

  Widget _subInfo(CheckModel model) {
    List<String> extraList = model.checkDetail?.extra?.keys?.toList() ?? [];
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
              onTap: () {
                setState(() {
                  showInfo = !showInfo;
                });
              },
              child: InfoFormItem(
                  lable: '辅助信息',
                  rightWidget: Container(
                    padding: EdgeInsets.only(
                      right: ScreenUtil().setWidth(60),
                      // bottom: ScreenUtil().setWidth(showInfo ? 15 : 0),
                      // top: ScreenUtil().setWidth(showInfo ? 0 : 20),
                    ),
                    child: Transform.rotate(
                      angle: (showInfo ? 1 : -1) * pi / 2,
                      child: Image.asset(
                        ImageHelper.wrapAssets('right_more.png'),
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                      ),
                    ),
                  ))),
          showInfo
              ? extraList.isEmpty
                  ? Container(
                      child: noDataWidget(text: '暂无辅助信息'),
                    )
                  : Column(
                      children: extraList.map((e) {
                      int idx = model.checkDetail?.meta
                          ?.indexWhere((m) => m.fieldId == e);
                      if (idx > -1) {
                        Meta metaItem = model.checkDetail?.meta[idx];
                        return InfoFormItem(
                            lable: metaItem.fieldName,
                            text: model.checkDetail?.extra[e].toString(),
                            commonWidth: ScreenUtil().setWidth(230));
                      }
                      return Container();
                    }).toList())
              : Container()
        ],
      ),
    );
  }

  Widget _projects(CheckModel model) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InfoFormItem(lable: '申请项目'),
          Column(
            children: (model.checkDetail?.items ?? [])
                .map(
                  (e) => Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(90),
                      top: ScreenUtil().setWidth(30),
                      bottom: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(120),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                width: 0.5, color: Color(0xFFf0f0f0)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: ScreenUtil().setWidth(600),
                            child: Text(
                              e.itemName ?? '',
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(40)),
                            )),
                        Container(
                            width: ScreenUtil().setWidth(310),
                            alignment: Alignment.bottomRight,
                            child: Text(e.specimenTypeName ?? '',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(40))))
                      ],
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Widget confirm() {
    return Container(
      width: ScreenUtil.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteName.receiptConfirm,
                    arguments: {
                      "applyId": widget.applyId,
                      "update": (bool value) {
                        widget.updateList();
                        setState(() {
                          status = value ? 3 : 4;
                          statusName = checkStatus[status];
                        });
                      }
                    });
              },
              child: Container(
                width: ScreenUtil().setWidth(1000),
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
                decoration: BoxDecoration(
                    color: DiyColors.heavy_blue,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                alignment: Alignment.center,
                child: Text(
                  '审  核',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
