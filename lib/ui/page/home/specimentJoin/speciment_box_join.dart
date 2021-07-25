import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget, simpleRecordInput;
import 'package:huayin_logistics/ui/widget/multi_select.dart';
import 'package:huayin_logistics/view_model/home/specimen_join_model.dart';

class SpecimentBoxJoin extends StatefulWidget {
  @override
  _SpecimentBoxJoin createState() => _SpecimentBoxJoin();
}

class _SpecimentBoxJoin extends State<SpecimentBoxJoin> {
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
            appBar: appBarWithName(context, '标本箱交接', '外勤:', withName: true),
            body: ProviderWidget<SpecimenJoinModel>(
                model: SpecimenJoinModel(context),
                onBuildReady: (SpecimenJoinModel model) {
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
                                child: Text(
                                  '可交接标本箱',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              model.busy
                                  ? Container()
                                  : model.empty
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
                                          child:
                                              noDataWidget(text: '暂无交接标本箱数据'),
                                        )
                                      : Container(
                                          child: Column(
                                            children: (model.joinList ?? [])
                                                .map((e) =>
                                                    buildBoxItem(e, model))
                                                .toList(),
                                          ),
                                        )
                            ],
                          ),
                        ),
                        Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(40),
                                right: ScreenUtil().setWidth(40)),
                            child: simpleRecordInput(context,
                                preText: '接收人',
                                hintText: '(必填)请选择接收人',
                                enbleInput: false,
                                rightWidget: new Image.asset(
                                  ImageHelper.wrapAssets('mine_rarrow.png'),
                                  width: ScreenUtil().setHeight(40),
                                  height: ScreenUtil().setHeight(40),
                                ),
                                onController: model.takeCon, onTap: () {
                              Navigator.pushNamed(
                                      context, RouteName.selectUserList,
                                      arguments: {"item": model.userItem})
                                  .then((value) {
                                if (value != null) {
                                  model.userItem = value;
                                  model.takeCon.text = model.userItem.name;
                                }
                              });
                            })),
                        buildContent(model),
                        confirm(model)
                      ],
                    )))));
  }

  Widget buildBoxItem(SpecimenJoinItem item, SpecimenJoinModel model) {
    return InkWell(
        onTap: () {
          List<SpecimenJoinItem> items = model.boxPicked;
          if (items.contains(item)) {
            items.removeWhere((e) => e == item);
          } else {
            items.add(item);
          }
          model.boxPicked = items;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            children: <Widget>[
              MultiSelect(
                select:
                    model.boxPicked.indexWhere((p) => p.boxNo == item.boxNo) >
                        -1,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(item.boxNo,
                      style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: ScreenUtil().setSp(40)))),
            ],
          ),
        ));
  }

  Widget buildContent(SpecimenJoinModel model) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setWidth(40),
        horizontal: ScreenUtil().setWidth(40),
      ),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('备注信息',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(40),
                    color: Color(0xFF333333))),
          ),
          Expanded(
              child: Container(
            constraints: BoxConstraints(minHeight: ScreenUtil().setWidth(300)),
            child: TextField(
              scrollPadding: EdgeInsets.all(0),
              autofocus: false,
              controller: model.textCon,
              maxLines: 5,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(40),
                color: Color.fromRGBO(90, 90, 91, 1),
              ),
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '请输入备注',
                  hintStyle: TextStyle(color: Color(0xFFcccccc)),
                  contentPadding:
                      EdgeInsets.only(left: ScreenUtil().setWidth(80), top: 0)),
            ),
          ))
        ],
      ),
    );
  }

  Widget confirm(SpecimenJoinModel model) {
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
                  '提  交',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
