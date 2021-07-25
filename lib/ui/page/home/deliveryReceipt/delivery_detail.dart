import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, inputPreText;
import 'package:huayin_logistics/ui/widget/info_form_item.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'company_details.dart';

class DeliveryDetail extends StatefulWidget {
  final DeliveryDetailModel detail;
  final String id;
  final Function(DeliveryDetailModel) updateStatus;
  DeliveryDetail({this.detail, this.id, this.updateStatus});
  @override
  _DeliveryDetail createState() => _DeliveryDetail();
}

class _DeliveryDetail extends State<DeliveryDetail> {
  DeliveryDetailModel detail;

  @override
  void initState() {
    super.initState();
    if (widget.detail != null) {
      detail = widget.detail;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => getDetail());
    }
  }

  getDetail({bool showLoading = true}) async {
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    DeliveryDetailModel detailResponse;
    KumiPopupWindow pop;
    if (showLoading) {
      pop = PopUtils.showLoading();
    }
    try {
      detailResponse =
          await Repository.fetchDeliveryDetail(labId: labId, id: widget.id);
    } catch (e, s) {
      print('getBoxlist error $e');
      if (showLoading) {
        PopUtils.dismiss();
      }
      PopUtils.showError(e, s);
      return;
    }

    if (showLoading) {
      PopUtils.dismiss();
    }
    setState(() {
      detail = detailResponse;
    });
    widget.updateStatus?.call(detail);
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
            appBar: appBarWithName(context, '交接单详情', '外勤:', withName: true),
            body: detail != null
                ? SingleChildScrollView(
                    padding:
                        EdgeInsets.only(bottom: ScreenUtil().setWidth(100)),
                    child: Column(
                      children: <Widget>[
                        buildStatus(),
                        InfoFormItem(
                            lable: '日期',
                            text: detail.recordDate.split(' ').first),
                        InfoFormItem(lable: '标本箱号', text: detail.boxNo),
                        Column(
                          children: (detail.items ?? [])
                              .map((e) => CompanyDetails(
                                    item: e,
                                    detail: detail,
                                    updateStatus: () {
                                      getDetail(showLoading: false);
                                    },
                                  ))
                              .toList(),
                        )
                      ],
                    ))
                : Container()));
  }

  Widget buildStatus() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(30),
          horizontal: ScreenUtil().setWidth(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          inputPreText(preText: '交接单状态', isRquire: false),
          Container(
              child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(5),
                    horizontal: ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                    color: detail.confirmStatus == 1
                        ? Colors.transparent
                        : Color(0xffd6e6ff),
                    border: Border.all(
                        width: 1,
                        color: detail.confirmStatus == 1
                            ? Color(0xFFf0f0f0)
                            : Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                alignment: Alignment.center,
                child: Text(
                  detail.confirmStatus == 0 ? '未确认' : '已确认',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(34),
                      color: detail.confirmStatus == 1
                          ? Color(0xFFcccccc)
                          : DiyColors.heavy_blue),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
