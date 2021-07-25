import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/user_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget;
import 'package:huayin_logistics/view_model/home/select_item_user_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectUserList extends StatefulWidget {
  final UserModel item;
  SelectUserList({this.item});
  @override
  _SelectUserList createState() => _SelectUserList();
}

class _SelectUserList extends State<SelectUserList> {
  UserModel _currentSelectedItem;
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _currentSelectedItem = widget.item;
    }
  }

  @override
  Widget build(BuildContext context) {
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Color(0xFFf5f5f5),
          appBar: appBarWithName(context, '选择交接人', '外勤:', withName: true),
          body: ProviderWidget<SelectUserModel>(
              model: SelectUserModel(labId: labId, context: context),
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
                            enablePullUp: false,
                            enablePullDown: true,
                            child: _listChild(model)),
                      ),
                      // new Container(
                      //   padding: EdgeInsets.only(
                      //       bottom: ScreenUtil().setHeight(76),
                      //       top: ScreenUtil().setHeight(30)),
                      //   child: gradualButton('确定', onTap: () {
                      //     Navigator.of(context).pop(_currentSelectedItem);
                      //   }),
                      // )
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
        ))),
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
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(40),
                        right: ScreenUtil().setWidth(50)),
                    child: Image.asset(
                      ImageHelper.wrapAssets(_currentSelectedItem?.id == item.id
                          ? 'select_on.png'
                          : 'select_off.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  new Container(
                    child: new Text(item.name,
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
                          hintText: '姓名',
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
                            model.name = v.toString();
                            model.initData();
                          });
                        },
                        onSubmitted: (v) {
                          model.name = v;
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
