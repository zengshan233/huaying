import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget;
import 'package:huayin_logistics/view_model/home/select_item_company_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectCompany extends StatefulWidget {
  final SelectCompanyListItem item;
  SelectCompany({this.item});
  @override
  _SelectCompany createState() => _SelectCompany();
}

class _SelectCompany extends State<SelectCompany> {
  SelectCompanyListItem _currentSelectedItem;
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _currentSelectedItem = widget.item;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Color(0xFFf5f5f5),
          appBar: appBarWithName(context, '选择送检单位', ''),
          body: ProviderWidget<SelectCompanyModel>(
              model: SelectCompanyModel(custName: "", context: context),
              onModelReady: (model) {
                model.initData();
              },
              builder: (cContext, model, child) {
                return Column(
                  children: <Widget>[
                    _searchTitle(model),
                    Expanded(
                      child: new Container(
                        child: SmartRefresher(
                            controller: model.refreshController,
                            header: WaterDropHeader(),
                            onRefresh: model.refresh,
                            onLoading: model.loadMore,
                            enablePullUp: true,
                            enablePullDown: false,
                            child: _listChild(model)),
                      ),
                    )
                  ],
                );
              })),
    );
  }

  //单项列表
  Widget _listChild(model) {
    if (model.busy)
      return Container(
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: Center(
          child: UnconstrainedBox(
              child: Container(
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(DiyColors.heavy_blue),
            ),
          )),
        ),
      );
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
              (c, i) => _listItem(i, model),
              childCount: model.list.length,
            ),
          ),
        ],
      );
    }
  }

  //列表单项
  Widget _listItem(index, model) {
    var item = model.list[index];
    return Container(
        child: new PhysicalModel(
      color: Colors.white, //设置背景底色透明
      borderRadius: BorderRadius.all(Radius.circular(0)),
      clipBehavior: Clip.antiAlias, //注意这个属性
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
            constraints: BoxConstraints(
              minHeight: ScreenUtil().setHeight(120),
            ),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: GlobalConfig.borderColor,
                      width: 1.5 / ScreenUtil.pixelRatio)),
            ),
            child: new FlatButton(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(4)),
              onPressed: () {
                setState(() {
                  _currentSelectedItem = item;
                });
                Navigator.of(context).pop(_currentSelectedItem);
              },
              child: new Row(
                children: <Widget>[
                  new Container(
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setWidth(60),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Image.asset(
                      ImageHelper.wrapAssets(
                          _currentSelectedItem?.custId == item.custId
                              ? 'select_on.png'
                              : 'select_off.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  new Expanded(
                    child: new Text(item.custName.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color.fromRGBO(90, 90, 90, 1),
                        )),
                  ),
                ],
              ),
            )),
      ),
    ));
  }

  //头部搜索栏
  Widget _searchTitle(model) {
    Timer dRequst;
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          width: ScreenUtil.screenWidth,
          height: ScreenUtil().setHeight(210),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(45)),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new PhysicalModel(
                    color: Color(0xFFf5f5f5), //设置背景底色透明
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    clipBehavior: Clip.antiAlias, //注意这个属性
                    elevation: 0.2,
                    child: new Container(
                      width: ScreenUtil().setWidth(810),
                      height: ScreenUtil().setHeight(110),
                      child: new TextField(
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontSize: ScreenUtil().setSp(42),
                            color: Color.fromRGBO(0, 117, 255, 1)),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: '请搜索医院名称',
                          hintStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(42),
                            color: Color.fromRGBO(190, 190, 190, 1),
                          ),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
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
                          if (dRequst != null) {
                            dRequst.cancel();
                          }
                          dRequst = Timer(Duration(milliseconds: 400), () {
                            model.custName = v.toString();
                            model.initData();
                          });
                        },
                        onSubmitted: (v) {
                          model.custName = v.toString();
                          model.initData();
                        },
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
