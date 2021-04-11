import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';

class SpecimenBoxes extends StatefulWidget {
  Function(String) confirm;
  SpecimenBoxes({this.confirm});
  @override
  _SpecimenBoxes createState() => _SpecimenBoxes();
}

class _SpecimenBoxes extends State<SpecimenBoxes> {
  List<SpecimenBoxItem> list = [];
  List<String> itemsPicked = [];
  bool showMore = false;
  @override
  void initState() {
    super.initState();
    getSpecimenBoxes();
  }

  getSpecimenBoxes() async {
    await Future.delayed(Duration(seconds: 1));
    list = [
      SpecimenBoxItem(name: '03号标本箱', ice: true, code: '1'),
      SpecimenBoxItem(name: '04号标本箱', ice: true, code: '2'),
      SpecimenBoxItem(name: '05号标本箱', ice: false, code: '3'),
      SpecimenBoxItem(name: '06号标本箱', ice: false, code: '4'),
      SpecimenBoxItem(name: '07号标本箱', ice: true, code: '5'),
      SpecimenBoxItem(name: '08号标本箱', ice: true, code: '6'),
      SpecimenBoxItem(name: '09号标本箱', ice: false, code: '7'),
      SpecimenBoxItem(name: '11号标本箱', ice: true, code: '8'),
      SpecimenBoxItem(name: '12号标本箱', ice: true, code: '9'),
      SpecimenBoxItem(name: '13号标本箱', ice: false, code: '10'),
      SpecimenBoxItem(name: '14号标本箱', ice: false, code: '11'),
      SpecimenBoxItem(name: '15号标本箱', ice: true, code: '12'),
      SpecimenBoxItem(name: '16号标本箱', ice: false, code: '13'),
      SpecimenBoxItem(name: '17号标本箱', ice: false, code: '14'),
      SpecimenBoxItem(name: '18号标本箱', ice: true, code: '15'),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
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
                        child: Text('${itemsPicked.length}/${list.length}'))),
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
          list.length == 0
              ? Container()
              : Container(
                  child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: list
                            .sublist(0, showMore ? list.length : 5)
                            .map((e) {
                          return InkWell(
                              onTap: () {
                                if (itemsPicked.contains(e.code)) {
                                  itemsPicked.removeWhere((i) => i == e.code);
                                } else {
                                  itemsPicked.add(e.code);
                                }
                                setState(() {});
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
                                                    itemsPicked.contains(e.code)
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
                                            child: Text(e.name,
                                                style: TextStyle(
                                                    color:
                                                        Color(0xFF666666))))),
                                    Expanded(
                                        child: Container(
                                            child: Image.asset(
                                      ImageHelper.wrapAssets(
                                          'ice_${e.ice ? 'on' : 'off'}.png'),
                                      width: ScreenUtil().setWidth(60),
                                      height: ScreenUtil().setWidth(60),
                                    ))),
                                    Expanded(
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
                                    )),
                                  ],
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                    InkWell(
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
                  ],
                ))
        ],
      ),
    );
  }
}
