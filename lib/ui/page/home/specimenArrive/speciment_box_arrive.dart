import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/transfer_picker_model_data.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, listTitleDecoration, noDataWidget;
import 'package:huayin_logistics/ui/widget/scanner.dart';
import 'package:huayin_logistics/utils/device_utils.dart';
import 'package:huayin_logistics/view_model/home/specimen_box_arrive_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'arrive_item.dart';

class SpecimenBoxArrive extends StatefulWidget {
  @override
  _SpecimenBoxArrive createState() => _SpecimenBoxArrive();
}

class _SpecimenBoxArrive extends State<SpecimenBoxArrive> {
  List<TransferPickerData> data = [];
  int _currentTabIndex = 0;
  TextEditingController searchCon = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: appBarWithName(context, '标本箱送达', '外勤:', withName: true),
            body: ProviderWidget<SpecimenBoxArriveModel>(
                model: SpecimenBoxArriveModel(
                    context: context, isDelivered: false),
                onModelReady: (model) {
                  model.initData();
                },
                builder: (cContext, model, child) => Column(
                      children: <Widget>[
                        _searchTitle(model),
                        Expanded(child: _listContent(model))
                      ],
                    ))));
  }

  Widget _listContent(SpecimenBoxArriveModel model) {
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
                      tabItem(
                          text: '未送达',
                          index: 0,
                          onTap: () {
                            model.isDelivered = false;
                            model.initData();
                          }),
                      tabItem(
                          text: '已送达',
                          index: 1,
                          onTap: () {
                            model.isDelivered = true;
                            model.initData();
                          })
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
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(200)),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey[200],
                            valueColor:
                                AlwaysStoppedAnimation(DiyColors.heavy_blue),
                          ),
                        ))),
                      )
                    : Expanded(
                        child: new Container(
                          child: SmartRefresher(
                              controller: model.refreshController,
                              header: WaterDropHeader(),
                              onRefresh: model.refresh,
                              onLoading: model.loadMore,
                              enablePullUp: true,
                              enablePullDown: true,
                              child: _listChild(model)),
                        ),
                      )
              ],
            ),
          ),
        ));
  }

  //单项列表
  Widget _listChild(SpecimenBoxArriveModel model) {
    if (model.busy)
      return Container(
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: Center(
            child: UnconstrainedBox(
                child: Container(
          width: ScreenUtil().setWidth(80),
          height: ScreenUtil().setWidth(80),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
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
              (c, i) => ArriveItem(model: model, item: model.list[i]),
              childCount: model.list.length,
            ),
          ),
        ],
      );
    }
  }

  //选择按钮
  Widget tabItem({String text, int index, Function onTap}) {
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
            if (_currentTabIndex != index) {
              setState(() {
                _currentTabIndex = index;
              });
              onTap();
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

  //头部搜索栏
  Widget _searchTitle(SpecimenBoxArriveModel model) {
    Timer dRequst;
    return Column(
      children: <Widget>[
        Container(
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
                        height: ScreenUtil().setHeight(110),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              style: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: ScreenUtil().setSp(42),
                                  color: DiyColors.heavy_blue),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                  hintText: '请扫描或输入标本箱编号',
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
                                  counterText: ''),
                              maxLength: 20,
                              controller: searchCon,
                              onChanged: (v) {
                                if (dRequst != null) {
                                  dRequst.cancel();
                                }
                                dRequst =
                                    Timer(Duration(milliseconds: 400), () {
                                  model.boxNo = v.toString();
                                  model.initData();
                                });
                              },
                              onSubmitted: (v) {
                                model.boxNo = v;
                                model.initData();
                              },
                            )),
                            Positioned(
                              right: 0,
                              height: ScreenUtil().setHeight(110),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(100),
                                    height: ScreenUtil().setHeight(90),
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(30)),
                                    child: new FlatButton(
                                      padding: EdgeInsets.all(0),
                                      highlightColor: Colors.transparent,
                                      onPressed: () async {
                                        DeviceUtils.scanBarcode(
                                          confirm: (code) {
                                            if (code != null) {
                                              searchCon.text = code;
                                              model.boxNo = code;
                                              model.initData();
                                            }
                                          },
                                        );
                                      },
                                      child: new Image.asset(
                                        ImageHelper.wrapAssets(
                                            'record_wscan.png'),
                                        color: Color(0xFF666666),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ))),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: data.length <= 0,
          child: listTitleDecoration(title: '标本箱信息', colors: [
            Color.fromRGBO(91, 168, 252, 1),
            Color.fromRGBO(56, 111, 252, 1)
          ]),
        )
      ],
    );
  }
}
