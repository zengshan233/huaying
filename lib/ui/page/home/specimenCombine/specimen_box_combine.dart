import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget;
import 'package:huayin_logistics/view_model/home/specimen_combine_model.dart';

import 'combine_item.dart';

class SpecimentBoxCombine extends StatefulWidget {
  @override
  _SpecimentBoxCombine createState() => _SpecimentBoxCombine();
}

class _SpecimentBoxCombine extends State<SpecimentBoxCombine> {
  FocusNode focusNode = FocusNode();

  String searchWordTop = '';
  String searchWordBottom = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            backgroundColor: DiyColors.background_grey,
            appBar: appBarWithName(context, '标本箱合箱', '外勤:', withName: true),
            body: ProviderWidget<SpecimenCombineModel>(
                model: SpecimenCombineModel(context),
                onBuildReady: (SpecimenCombineModel model) {
                  model.getData();
                },
                builder: (context, model, child) => SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(50)),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(50),
                                      vertical: ScreenUtil().setWidth(20)),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(50)),
                                        child: Text('待合标本箱',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Text('已接收的标本箱才能进行合箱操作',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  93, 164, 255, 1),
                                              fontSize: ScreenUtil().setSp(30)))
                                    ],
                                  )),
                              _searchTitle(true),
                              model.busy
                                  ? Container()
                                  : model.combineList.isEmpty
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenUtil().setHeight(10)),
                                          child: noDataWidget(text: '暂无待合标本箱'),
                                        )
                                      : Container(
                                          child: Column(
                                            children: model.combineList
                                                .where((c) => c.boxNo
                                                    .contains(searchWordTop))
                                                .toList()
                                                .map((e) => ReceiveItem(
                                                    update: () =>
                                                        setState(() {}),
                                                    item: e,
                                                    model: model))
                                                .toList(),
                                          ),
                                        )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(50),
                                    vertical: ScreenUtil().setWidth(20)),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '选择标本箱（合并用箱）',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              _searchTitle(false),
                              Container(
                                child: Column(
                                  children: model.boxList
                                      .where((b) =>
                                          b.boxNo.contains(searchWordBottom))
                                      .toList()
                                      .map((e) =>
                                          buildBoxItem(item: e, model: model))
                                      .toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                        confirm(model)
                      ],
                    )))));
  }

  Widget _searchTitle(bool isTop) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
              margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
              child: new Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    child: new PhysicalModel(
                        color: Color(0xFFf5f5f5), //设置背景底色透明
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        clipBehavior: Clip.antiAlias, //注意这个属性
                        elevation: 0.2,
                        child: new Container(
                            height: ScreenUtil().setHeight(110),
                            child: new TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: ScreenUtil().setSp(42),
                                  color: Color.fromRGBO(0, 117, 255, 1)),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: '请输入${isTop ? '待合标本' : '合并用'}箱号',
                                hintStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(42),
                                  color: Color.fromRGBO(190, 190, 190, 1),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: ScreenUtil().setWidth(60),
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                              onChanged: (v) {
                                setState(() {
                                  isTop
                                      ? searchWordTop = v
                                      : searchWordBottom = v;
                                });
                              },
                            ))),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget buildBoxItem({SpecimenUnusedItem item, SpecimenCombineModel model}) {
    return InkWell(
        onTap: () {
          model.box = item;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(35)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            children: <Widget>[
              Container(
                child: Container(
                  width: ScreenUtil().setWidth(55),
                  height: ScreenUtil().setWidth(55),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(60),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.wrapAssets(model.box?.boxNo == item.boxNo
                        ? 'select_on.png'
                        : 'select_off.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(item.boxNo,
                      style: TextStyle(color: Color(0xFF666666)))),
            ],
          ),
        ));
  }

  Widget biuldCustomBox(SpecimenCombineModel model) {
    return InkWell(
        onTap: () async {
          model.box = null;
          await Future.delayed(Duration(milliseconds: 100));
          FocusScope.of(context).requestFocus(focusNode);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            children: <Widget>[
              Container(
                child: Container(
                  width: ScreenUtil().setWidth(55),
                  height: ScreenUtil().setWidth(55),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(60),
                      right: ScreenUtil().setWidth(50)),
                  child: Image.asset(
                    ImageHelper.wrapAssets(
                        model.box == null ? 'select_on.png' : 'select_off.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        enabled: model.box == null,
                        focusNode: focusNode,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(40),
                            color: Color.fromRGBO(0, 117, 255, 1)),
                        decoration: InputDecoration(
                            hintText: '请输入标本箱号',
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                color: Color.fromRGBO(211, 211, 211, 1),
                                height: 1.4),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            counterText: ""),
                        //禁止输入
                        maxLength: 12,
                        controller: model.customCon,
                      ))),
            ],
          ),
        ));
  }

  Widget confirm(SpecimenCombineModel model) {
    return Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                model.submit();
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
                  '确  定',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
