import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';

class BottomSheetList extends StatefulWidget {
  final String title;
  final List<String> nameList;
  final Function(int) confirm;
  String pickedName;
  BottomSheetList({this.nameList, this.title, this.confirm, this.pickedName});
  @override
  _BottomSheetList createState() => _BottomSheetList();
}

class _BottomSheetList extends State<BottomSheetList>
    with SingleTickerProviderStateMixin {
  String _pickedName;

  AnimationController controller;
  Animation<double> moveUp;
  @override
  void initState() {
    super.initState();
    if (widget.pickedName != null) {
      _pickedName = widget.pickedName;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => initAnimation());
  }

  initAnimation() {
    int maxCount = min(widget.nameList.length, 7) + 1;
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    moveUp = Tween(
            begin: (ScreenUtil().setWidth(-150) * maxCount).toDouble(),
            end: 0.0)
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          moveUp?.value == null
              ? Container()
              : Positioned(
                  left: 0,
                  bottom: moveUp.value,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    child: Column(
                      children: <Widget>[
                        buildHead(),
                        widget.nameList.length <= 7
                            ? Column(
                                children: List.generate(widget.nameList.length,
                                    (i) => _listItem(i)),
                              )
                            : Container(
                                height: ScreenUtil().setWidth(150) * 7,
                                child: CustomScrollView(
                                  slivers: <Widget>[
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (c, i) => _listItem(i),
                                        childCount: widget.nameList.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget buildHead() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      height: ScreenUtil().setWidth(150),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 1, child: Container()),
          Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(widget.title,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(44),
                        color: Color.fromRGBO(90, 90, 90, 1),
                        fontWeight: FontWeight.bold)),
              )),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        controller
                            .reverse()
                            .then((value) => Navigator.pop(context));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(60)),
                        child: Image(
                            color: Colors.black,
                            width: ScreenUtil().setWidth(70),
                            height: ScreenUtil().setWidth(70),
                            image:
                                AssetImage(ImageHelper.wrapAssets("close.png")),
                            fit: BoxFit.fill),
                      ))
                ],
              )),
        ],
      ),
    );
  }

  //列表单项
  Widget _listItem(index) {
    String item = widget.nameList[index];
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        constraints: BoxConstraints(
          minHeight: ScreenUtil().setHeight(100),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: GlobalConfig.borderColor,
                  width: 1.5 / ScreenUtil.pixelRatio)),
        ),
        height: ScreenUtil().setWidth(150),
        child: PhysicalModel(
            color: Colors.white, //设置背景底色透明
            borderRadius: BorderRadius.all(Radius.circular(0)),
            clipBehavior: Clip.antiAlias, //注意这个属性
            elevation: 0,
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(4)),
              onPressed: () {
                setState(() {
                  _pickedName = item;
                });
                controller.reverse().then((value) {
                  Navigator.pop(context);
                  widget.confirm?.call(
                      widget.nameList.indexWhere((n) => n == _pickedName));
                });
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(80)),
                      child: Text(item,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(40),
                            color: Color.fromRGBO(90, 90, 90, 1),
                          )),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(50),
                    height: ScreenUtil().setWidth(50),
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                    child: Image.asset(
                      ImageHelper.wrapAssets(_pickedName == item
                          ? 'select_on.png'
                          : 'select_off.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
            )));
  }
}
