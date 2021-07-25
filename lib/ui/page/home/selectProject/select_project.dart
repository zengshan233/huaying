import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/selectProject/project_list.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;
import 'package:huayin_logistics/view_model/home/select_item_company_model.dart';
import './select_item.dart';

class SelectProject extends StatefulWidget {
  final List<SelectProjectItem> hasSelectItem;
  SelectProject({this.hasSelectItem});
  @override
  _SelectProject createState() => _SelectProject();
}

class _SelectProject extends State<SelectProject>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  List<SelectProjectItem> _hasSelectItem = [];

  FocusNode focusNode = new FocusNode();

  bool showDimSearch = false;

  bool showItems = false;

  var focusListen;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    focusNode.addListener(() {
      //print('焦点事件'+focusNode.hasFocus.toString());
      setState(() {
        showDimSearch = focusNode.hasFocus;
      });
    });
    setState(() {
      _hasSelectItem = widget.hasSelectItem ?? [];
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          focusNode.unfocus();
        },
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop(_hasSelectItem);
            return new Future.value(false);
          },
          child: Scaffold(
              // 设置为false，防止keyboard弹出时切换tab提示overflow的警告
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: appBarWithName(context, '选择申请项目', '',
                  rightWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop(_hasSelectItem);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(40)),
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(30),
                                vertical: ScreenUtil().setWidth(10)),
                            decoration: BoxDecoration(
                                color: DiyColors.heavy_blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            alignment: Alignment.center,
                            child: Text(
                              "确定",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(48),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ))
                    ],
                  )),
              body: ProviderWidget<SelectItemModel>(
                  model: SelectItemModel(
                      context: context,
                      keyword: "",
                      itemType: "1",
                      labDeptId: ""),
                  autoDispose: false,
                  onModelReady: (model) async {
                    await model.initData();
                    setState(() {});
                  },
                  builder: (cContext, model, child) {
                    return Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom),
                        child: Column(
                          children: <Widget>[
                            _topTabBar(),
                            Expanded(
                                child: TabBarView(
                                    controller: tabController,
                                    children: [
                                  SelectItem(
                                    hasSelectItems: _hasSelectItem,
                                    updateItems: (items) {
                                      setState(() {});
                                    },
                                  ),
                                  ProjectList(
                                      model: model,
                                      hasSelectItem: _hasSelectItem,
                                      updateItems: () => setState(() {}))
                                ])),
                          ],
                        ));
                  })),
        ));
  }

  Widget _topTabBar() {
    return Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(36)), //外层adding,
                  child: Container(
                    height: ScreenUtil().setHeight(116),
                    child: TabBar(
                      controller: tabController,
                      labelColor: DiyColors.heavy_blue,
                      unselectedLabelColor: Color.fromRGBO(90, 90, 91, 1),
                      indicatorColor: DiyColors.heavy_blue,
                      indicatorWeight: ScreenUtil().setHeight(12),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(44),
                      ),
                      tabs: [
                        Tab(
                          text: '已选项目 (${_hasSelectItem.length})',
                        ),
                        Tab(
                          text: '选择申请项目',
                        )
                      ],
                    ),
                  )),
            )
          ],
        ));
  }
}
