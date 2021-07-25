import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/check_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget;
import 'package:huayin_logistics/view_model/home/check_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReceiptCheck extends StatefulWidget {
  @override
  _ReceiptCheck createState() => _ReceiptCheck();
}

class _ReceiptCheck extends State<ReceiptCheck> {
  int _currentTabIndex = 2;

  TextEditingController _replyMessageController;
  TextEditingController _searchController;

  FocusNode focusNode = new FocusNode();

  CheckModel viewModel;

  bool showDimSearch = false;
  @override
  void initState() {
    super.initState();
    _replyMessageController = TextEditingController();
    _searchController = TextEditingController();
    focusNode.addListener(() {
      setState(() {
        showDimSearch = focusNode.hasFocus;
      });
    });
    viewModel = CheckModel(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    _replyMessageController.dispose();
    _searchController.dispose();
    focusNode.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          focusNode.unfocus();
        },
        child: Scaffold(
            backgroundColor: Color.fromRGBO(242, 243, 249, 1),
            appBar: appBarWithName(context, '单据审核', '外勤:', withName: true),
            body: ProviderWidget<CheckModel>(
                model: viewModel,
                onBuildReady: (model) {
                  model.initData();
                },
                builder: (context, model, child) {
                  return _listContent(model);
                })));
  }

  Widget _listContent(model) {
    return Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
        child: PhysicalModel(
          color: Color(0xFFf5f5f5), //设置背景底色透明
          clipBehavior: Clip.antiAlias, //注意这个属性
          elevation: 4,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
          child: Container(
            child: Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      tabItem(text: '待审核', index: 2, model: model),
                      tabItem(text: '已审核', index: 3, model: model),
                      tabItem(text: '已驳回', index: 4, model: model)
                    ],
                  ),
                ),
                model.busy
                    ? Expanded(
                        child: Center(
                            child: UnconstrainedBox(
                                child: Container(
                          width: ScreenUtil().setWidth(80),
                          height: ScreenUtil().setWidth(80),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey[200],
                            valueColor:
                                AlwaysStoppedAnimation(DiyColors.heavy_blue),
                          ),
                        ))),
                      )
                    : new Expanded(
                        child: SmartRefresher(
                          controller: model.refreshController,
                          enablePullUp: true,
                          child: _listChild(model),
                          header: WaterDropHeader(),
                          onRefresh: model.refresh,
                          onLoading: model.loadMore,
                        ),
                      )
              ],
            ),
          ),
        ));
  }

  //单项列表
  Widget _listChild(model) {
    int count = model.getTotal(_currentTabIndex);
    if (model.list.isEmpty)
      return Container(
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(100)),
          child: noDataWidget(text: '暂无列表数据'),
        ),
      );
    else {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (c, i) => Selector<CheckModel, CheckItem>(
                      selector: (context, smodel) {
                        if (count == 0) return null;
                        return smodel.list[i];
                      },
                      builder: (context, feedback, child) {
                        return _listItem(context, feedback, i, count, model);
                      },
                    ),
                childCount: count),
          )
        ],
      );
    }
  }

  //列表单项
  Widget _listItem(
      context, CheckItem item, int index, int count, CheckModel model) {
    var tempYYDialog;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
        child: new PhysicalModel(
            color: Colors.white, //设置背景底色透明
            borderRadius: BorderRadius.all(Radius.circular(6)),
            clipBehavior: Clip.antiAlias, //注意这个属性
            elevation: 0,
            child: FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.receiptDetail,
                    arguments: {
                      "receiptId": item.id,
                      "status": item.aloneRecordStatus,
                      "applyId": item.applyId,
                      "updateList": () {
                        model.list.removeWhere((l) => l == item);
                        setState(() {});
                      }
                    });
              },
              highlightColor: Colors.transparent,
              padding: EdgeInsets.all(0),
              child: Container(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(34)),
                  constraints: BoxConstraints(
                    minHeight: ScreenUtil().setHeight(266),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: GlobalConfig.borderColor, width: 1)),
                        ),
                        padding:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(30)),
                              child: Text(
                                '标本条码：${item.barCode}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(38),
                                    color: Color(0xFF666666),
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(30)),
                              child: Text(
                                checkStatus[item.aloneRecordStatus] ??
                                    '', //处理中Color.fromRGBO(255, 155,15 , 1)
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(38),
                                  color: item.aloneRecordStatus == 2
                                      ? Color(0xFF6196ff)
                                      : Color(0xFF9f9f9f),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(30),
                              top: ScreenUtil().setWidth(20)),
                          child: Text('送检单位：${item.inspectionUnitName}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(38),
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w400))),
                      Container(
                          margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(30),
                              left: ScreenUtil().setWidth(30),
                              top: ScreenUtil().setWidth(20)),
                          child: Text('申请项目：${item.itemNames ?? ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(38),
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w400))),
                      item.aloneRecordStatus == 2
                          ? Container(
                              width: ScreenUtil.screenWidth,
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(20),
                                  right: ScreenUtil().setWidth(30)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: ScreenUtil().setWidth(190),
                                        height: ScreenUtil().setHeight(72),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: DiyColors.heavy_blue),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil()
                                                    .setWidth(100)))),
                                        alignment: Alignment.center,
                                        child: Text('审核',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(38),
                                                color: DiyColors.heavy_blue,
                                                letterSpacing: 1)),
                                      )),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            )));
  }

  //选择按钮
  Widget tabItem({String text, int index, CheckModel model}) {
    return new Expanded(
        child: new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new FlatButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          padding: EdgeInsets.all(0),
          child: new Text(text,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(44),
                  color: index == _currentTabIndex
                      ? Color(0xFF3388ff)
                      : Color(0xFF666666))),
          onPressed: () {
            focusNode.unfocus();
            if (_currentTabIndex != index) {
              setState(() {
                _currentTabIndex = index;
              });
              model.aloneRecordStatus = index;
              model.initData();
            }
          },
        ),
        new Positioned(
          bottom: 0,
          child: Container(
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setWidth(12),
            decoration: BoxDecoration(
                color: index == _currentTabIndex
                    ? Color.fromRGBO(0, 146, 255, 1)
                    : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(2))),
          ),
        )
      ],
    ));
  }
}
