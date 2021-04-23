import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';

class SpecimenBoxes extends StatefulWidget {
  List<SpecimenBoxItem> list;
  Function(List<SpecimenBoxItem>) confirm;
  SpecimenBoxes({this.confirm, this.list});
  @override
  _SpecimenBoxes createState() => _SpecimenBoxes();
}

class _SpecimenBoxes extends State<SpecimenBoxes> {
  List<SpecimenBoxItem> itemsPicked = [];
  bool showMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    int minCount = min(5, widget.list.length);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                            '${itemsPicked.length}/${widget.list.length}'))),
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
          widget.list.length == 0
              ? Container()
              : Container(
                  child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: widget.list
                            .sublist(
                                0, showMore ? widget.list.length : minCount)
                            .map((e) {
                          return InkWell(
                              onTap: () {
                                if (itemsPicked.contains(e)) {
                                  itemsPicked
                                      .removeWhere((i) => i.boxNo == e.boxNo);
                                } else {
                                  itemsPicked.add(e);
                                }
                                setState(() {});
                                widget.confirm?.call(itemsPicked);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(15)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        top: BorderSide(
                                            width: 1,
                                            color: Color(0xFFf0f0f0)))),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                          Container(
                                            child: Container(
                                              width: ScreenUtil().setWidth(80),
                                              height: ScreenUtil().setWidth(80),
                                              margin: EdgeInsets.only(
                                                  left: ScreenUtil()
                                                      .setWidth(20)),
                                              child: Image.asset(
                                                ImageHelper.wrapAssets(
                                                    itemsPicked.contains(e)
                                                        ? 'record_sg.png'
                                                        : 'record_so.png'),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          )
                                        ])),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(e.boxNo,
                                                style: TextStyle(
                                                    color:
                                                        Color(0xFF666666))))),
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
                                              width: ScreenUtil().setWidth(60),
                                              height: ScreenUtil().setWidth(60),
                                            )))),
                                    Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RouteName.deliveryDetail,
                                            arguments: {
                                              "id": e.joinIds.first,
                                            });
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: radiusButton(
                                                  text: '交接单',
                                                  img: "transfer_ticket.png"),
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
                    widget.list.length > 5
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                showMore = !showMore;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(20)),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                          width: 1, color: Color(0xFFf0f0f0)))),
                              child: Text(
                                showMore ? '收起' : '查看更多',
                                style: TextStyle(color: DiyColors.heavy_blue),
                              ),
                            ))
                        : Container()
                  ],
                ))
        ],
      ),
    );
  }
}
