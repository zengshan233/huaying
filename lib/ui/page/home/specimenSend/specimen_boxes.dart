import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/specimenSend/box_list.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/view_model/home/specimen_send_model.dart';
import 'package:provider/provider.dart';

class SpecimenBoxes extends StatefulWidget {
  final Function updateBox;
  SpecimenBoxes({this.updateBox});
  @override
  _SpecimenBoxes createState() => _SpecimenBoxes();
}

class _SpecimenBoxes extends State<SpecimenBoxes> {
  bool showMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpecimenSendModel>(
      builder: (c, model, w) {
        int minCount = min(5, model.boxList?.length ?? 0);
        return model.busy
            ? Container()
            : Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setWidth(15)),
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                      '${model.boxPicked.length}/${model.boxList.length}'))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '选择标本箱',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontWeight: FontWeight.bold),
                                  ))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '冰敷',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontWeight: FontWeight.bold),
                                  ))),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                    model.boxList.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(30)),
                            child: noDataWidget(text: '暂无标本箱数据'),
                          )
                        : Container(
                            child: Column(
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: model.boxList
                                      .sublist(
                                          0,
                                          showMore
                                              ? model.boxList.length
                                              : minCount)
                                      .map((e) {
                                    List<String> boxNoList = model.boxPicked
                                        .map((b) => b.boxNo)
                                        .toList();
                                    return InkWell(
                                        onTap: () {
                                          if (!e.isAllJoinItemConfirm) {
                                            yyAlertDialogWithDivider(
                                                context: context,
                                                tipList: [
                                                  "当前标本箱的交接单未确",
                                                  "认，请确认后再发出"
                                                ],
                                                success: () {
                                                  toDetails(e, model,
                                                      add: true);
                                                });
                                            return;
                                          }
                                          model.addCombineItem(e);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenUtil().setWidth(15)),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 1,
                                                      color:
                                                          Color(0xFFf0f0f0)))),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                    Container(
                                                      child: Container(
                                                        width: ScreenUtil()
                                                            .setWidth(80),
                                                        height: ScreenUtil()
                                                            .setWidth(80),
                                                        margin: EdgeInsets.only(
                                                            left: ScreenUtil()
                                                                .setWidth(20)),
                                                        child: Image.asset(
                                                          ImageHelper.wrapAssets(
                                                              boxNoList.contains(
                                                                      e.boxNo)
                                                                  ? 'record_sg.png'
                                                                  : 'record_so.png'),
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ),
                                                    )
                                                  ])),
                                              Expanded(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(e.boxNo,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF666666))))),
                                              Expanded(
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        e.ice = !e.ice;
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                          child: Image.asset(
                                                        ImageHelper.wrapAssets(
                                                            'ice_${e.ice ? 'on' : 'off'}.png'),
                                                        width: ScreenUtil()
                                                            .setWidth(60),
                                                        height: ScreenUtil()
                                                            .setWidth(60),
                                                      )))),
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () {
                                                  toDetails(e, model);
                                                },
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Container(
                                                        child: radiusButton(
                                                            text: '交接单',
                                                            img:
                                                                "transfer_ticket.png"),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ));
                                  }).toList(),
                                ),
                              ),
                              model.boxList.length > 5
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          showMore = !showMore;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                ScreenUtil().setWidth(20)),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                top: BorderSide(
                                                    width: 1,
                                                    color: Color(0xFFf0f0f0)))),
                                        child: Text(
                                          showMore ? '收起' : '查看更多',
                                          style: TextStyle(
                                              color: DiyColors.heavy_blue),
                                        ),
                                      ))
                                  : Container()
                            ],
                          ))
                  ],
                ),
              );
      },
    );
  }

  void toDetails(SpecimenBoxItem e, SpecimenSendModel model,
      {bool add = false}) async {
    await Future.delayed(Duration(milliseconds: 100));
    if (e.joinIds.length > 1) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => BoxList(
                  joinids: e.joinIds, updateBox: () => widget.updateBox())));
    } else {
      await Navigator.pushNamed(context, RouteName.deliveryDetail, arguments: {
        "id": e.joinIds.first,
        "updateStatus": (DeliveryDetailModel _boxDetail) async {
          widget.updateBox();
        }
      });
    }

    int idx = model.boxList.indexWhere((b) => b.boxNo == e.boxNo);

    /// 该标本箱交接单是否已确认
    bool isAllow = model.boxList[idx].isAllJoinItemConfirm;

    /// 该标本箱在进交接单详情前是否被选中
    bool picked =
        model.boxPicked.map((p) => p.boxNo).toList().contains(e.boxNo);

    /// 若进交接单详情前该标本箱被选中且返回时交接单状态为未确认，则要自动移除被选项
    bool removePicked = !isAllow && picked;

    /// 若通过弹窗提示进入交接单详情且返回时交接单状态为确认，则要自动添加该项标本箱
    bool addPicked = add && isAllow;
    if (idx > -1 && (removePicked || addPicked)) {
      model.addCombineItem(e);
    }
  }
}
