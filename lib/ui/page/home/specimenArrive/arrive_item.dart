import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/view_model/home/specimen_box_arrive_model.dart';

class ArriveItem extends StatelessWidget {
  final SpecimenboxArriveItem item;
  final SpecimenBoxArriveModel model;
  ArriveItem({this.item, this.model});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(60),
            right: ScreenUtil().setWidth(60),
            bottom: ScreenUtil().setWidth(40)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(20),
                  horizontal: ScreenUtil().setWidth(40)),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Text(
                    '发出人：${item.senderName}',
                    style: TextStyle(color: Color(0xFF666666)),
                  )),
                  Container(
                      child: Text(
                    item.statusName,
                    style: TextStyle(
                        color: item.status == 3
                            ? Color(0xFF999999)
                            : DiyColors.heavy_blue),
                  ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20)),
                          child: Text(
                            item.boxNo,
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: ScreenUtil().setSp(38)),
                          )),
                      Image.asset(
                        ImageHelper.wrapAssets('express.png'),
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10),
                              vertical: ScreenUtil().setWidth(10)),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Color(0xFFf0f0f0))),
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(30),
                              bottom: ScreenUtil().setWidth(10)),
                          child: Text(
                            item.lineName,
                            style: TextStyle(
                                color: Color(0xFF9d9d9d),
                                fontSize: ScreenUtil().setSp(34)),
                          )),
                      Container(
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setWidth(70),
                        child: Image.asset(
                          ImageHelper.wrapAssets('to.png'),
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20)),
                          child: Text(
                            item.estimateArriveSiteName,
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: ScreenUtil().setSp(38)),
                          )),
                      Image.asset(
                        ImageHelper.wrapAssets('flag.png'),
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                      )
                    ],
                  ))
                ],
              ),
            ),
            Container(
              width: ScreenUtil.screenWidth,
              margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        confirm(context);
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(240),
                        height: ScreenUtil().setWidth(80),
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
                        decoration: BoxDecoration(
                            color: [3, 4].contains(item.status)
                                ? Color(0xFFf2f2f2)
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: [3, 4].contains(item.status)
                                    ? Color(0xFFe0e0e0)
                                    : DiyColors.heavy_blue),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(100)))),
                        alignment: Alignment.center,
                        child: Text(
                            [3, 4].contains(item.status)
                                ? item.statusName
                                : '确认送达',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: [3, 4].contains(item.status)
                                    ? Color(0xFF999999)
                                    : DiyColors.heavy_blue,
                                letterSpacing: 1)),
                      )),
                ],
              ),
            )
          ],
        ));
  }

  confirm(BuildContext context) async {
    if ([3, 4].contains(item.status)) {
      return;
    }
    model.specimenArriveOperate(
        id: item.id,
        deliveredId: item.senderId,
        deliveredName: item.senderName,
        callBack: () {
          int idx = model.list.indexWhere((element) => element == item);
          model.list.removeAt(idx);
          showMsgToast('送达成功！', context: context);
        });
  }
}
