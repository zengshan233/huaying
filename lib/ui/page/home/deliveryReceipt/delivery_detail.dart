import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;
import 'package:huayin_logistics/ui/widget/info_form_item.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

import 'company_details.dart';

class DeliveryDetail extends StatefulWidget {
  final DeliveryDetailModel detail;
  final String boxNo;
  DeliveryDetail({this.detail, this.boxNo});
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

  getDetail() async {
    MineModel model = Provider.of<MineModel>(context, listen: false);

    /// 426519329613053990
    /// 426519329613053982
    /// 先写死
    String labId = '82858490362716212';
    String userId = model.user.user.id;
    var responseId;
    DeliveryDetailModel detailResponse;
    try {
      responseId = await Repository.fetchDeliveryId(
          boxNo: widget.boxNo, labId: labId, recordId: userId);
      detailResponse = await Repository.fetchDeliveryDetail(
          labId: labId, id: responseId.toString());
    } catch (e) {
      print('getBoxlist error $e');
      return;
    }

    setState(() {
      detail = detailResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '交接单详情', '外勤:', withName: true),
        body: detail != null
            ? SingleChildScrollView(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(100)),
                child: Column(
                  children: <Widget>[
                    buildStatus(),
                    InfoFormItem(
                        lable: '日期', text: detail.recordDate.split(' ').first),
                    InfoFormItem(lable: '标本箱号', text: detail.boxNo),
                    Column(
                      children: detail.items
                          .map((e) => CompanyDetails(item: e, detail: detail))
                          .toList(),
                    )
                  ],
                ))
            : Container());
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
          Container(
            child: Text('交接单状态',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(38),
                  color: Color(0xFF333333),
                )),
          ),
          Container(
              child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(5),
                    horizontal: ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                    color: detail.confirmStatus == 0
                        ? Colors.transparent
                        : Color(0xffd6e6ff),
                    border: Border.all(
                        width: 1,
                        color: detail.confirmStatus == 0
                            ? Color(0xFFf0f0f0)
                            : Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                alignment: Alignment.center,
                child: Text(
                  '已确认',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(34),
                      color: detail.confirmStatus == 0
                          ? Color(0xFFcccccc)
                          : DiyColors.heavy_blue),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(5),
                    horizontal: ScreenUtil().setWidth(20)),
                decoration: BoxDecoration(
                    color: detail.signForStatus == 0
                        ? Colors.transparent
                        : Color(0xffd6e6ff),
                    border: Border.all(
                        width: 1,
                        color: detail.signForStatus == 0
                            ? Color(0xFFf0f0f0)
                            : Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                alignment: Alignment.center,
                child: Text(
                  '未签收',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(34),
                      color: detail.signForStatus == 0
                          ? Color(0xFFcccccc)
                          : DiyColors.heavy_blue),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
