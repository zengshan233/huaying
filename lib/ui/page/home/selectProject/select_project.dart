import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/view_model/home/select_item_company_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import './select_item.dart';

class SelectProject extends StatefulWidget {
  final List<SelectItemRightListItem> hasSelectItem;
  SelectProject({this.hasSelectItem});
  @override
  _SelectProject createState() => _SelectProject();
}

class _SelectProject extends State<SelectProject>
    with SingleTickerProviderStateMixin {
  TextEditingController sController = TextEditingController();

  SelectItemLeftMenu _leftMenuList; //左侧菜单列表

  List<SelectItemRightListItem> _hasSelectItem = [];

  // String _itemType='1';//切换头部tab 单项1  组合2  套餐3

  FocusNode focusNode = new FocusNode();

  bool showDimSearch = false;

  var focusListen;

  @override
  void initState() {
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
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setWidth(40)),
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
                onModelReady: (model) {
                  model.initData();
                },
                builder: (cContext, model, child) {
                  return Column(
                    children: <Widget>[
                      _searchTitle(model),
                      Expanded(child: _tabViewList(model)),
                    ],
                  );
                }),
            bottomSheet: SolidBottomSheet(
              toggleVisibilityOnTap: true,
              maxHeight: ScreenUtil().setWidth(1000),
              headerBar: Container(
                color: Color(0xFFf0f2f5),
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Container()),
                    Expanded(
                        child: Container(
                            alignment: Alignment.center, child: Text('已选项目'))),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              body: Container(
                color: Colors.white,
                height: ScreenUtil().setWidth(1000),
                child: ListView(
                  children: (() {
                    List<Widget> tempList = [];
                    for (var x in _hasSelectItem) {
                      tempList.add(SelectItem(
                          item: x,
                          key: ObjectKey('$x.id'),
                          delTap: () {
                            focusNode.unfocus();
                            var curIndex = tempList.indexWhere((e) =>
                                (e.key.toString() ==
                                    ObjectKey('$x.id').toString()));
                            _hasSelectItem.removeAt(curIndex);
                            setState(() {
                              _hasSelectItem = _hasSelectItem;
                            });
                          }));
                    }
                    return tempList.map((e) => e).toList();
                  })(),
                ),
              ),
            ),
          ),
        ));
  }

  //tabViewItem
  Widget _tabViewList(model) {
    return model.busy && _leftMenuList?.list == null
        ? UnconstrainedBox(
            child: Container(
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation(Color.fromRGBO(38, 181, 247, 1)),
            ),
          ))
        : _listChild(model);
  }

  //右边list
  Widget _listChild(SelectItemModel model) {
    return model.busy
        ? UnconstrainedBox(
            child: Container(
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation(Color.fromRGBO(38, 181, 247, 1)),
            ),
          ))
        : (model.list.length <= 0
            ? SizedBox()
            : SmartRefresher(
                controller: model.refreshController,
                header: WaterDropHeader(),
                onRefresh: model.refresh,
                onLoading: model.loadMore,
                enablePullUp: true,
                enablePullDown: false,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (c, i) => _listItem(model, i),
                        childCount: model.list.length,
                      ),
                    ),
                  ],
                ),
              ));
  }

  void _judgeItemExist(item) {
    int count = 0;
    if (item.type == 1) {
      //选择单项，和已选择的组合idlist进行比较
      for (var i = 0, len = _hasSelectItem.length; i < len; i++) {
        var zObj = _hasSelectItem[i];
        if (zObj.type != 1) {
          var idArray = zObj.idList == null ? [] : zObj.idList;
          if (idArray.contains(item.id)) {
            count++;
            yyAlertDialogWithDivider(
                tip:
                    "${zObj.typeName}'${zObj.itemName}'中已存在${item.typeName}'${item.itemName}'，确认再次添加？",
                success: () {
                  _hasSelectItem.add(item);
                  setState(() {
                    _hasSelectItem = _hasSelectItem;
                  });
                });
            break;
          }
        }
      }
    } else {
      //选择组合
      var tIdArray = item.idList == null ? [] : item.idList;
      for (var i = 0, len = _hasSelectItem.length; i < len; i++) {
        //遍历已选择数据
        var tObj = _hasSelectItem[i];
        if (tObj.type == 1) {
          //与已选择单项比
          if (tIdArray.contains(tObj.id)) {
            count++;
            yyAlertDialogWithDivider(
                tip: "已存在${tObj.typeName}'${tObj.itemName}'，确认再次添加？",
                success: () {
                  _hasSelectItem.add(item);
                  setState(() {
                    _hasSelectItem = _hasSelectItem;
                  });
                });
            break;
          }
        } else {
          //与已选择组合比较
          var lIdArray = tObj.idList == null ? [] : tObj.idList;
          int tempConut = 0;
          for (var i = 0, len = tIdArray.length; i < len; i++) {
            var str = tIdArray[i];
            if (lIdArray.contains(str)) {
              count++;
              tempConut++;
              yyAlertDialogWithDivider(
                  tip:
                      "${item.typeName}'${item.itemName}'中与已选择的${tObj.typeName}'${tObj.itemName}'存在重复单项，确认再次添加？",
                  success: () {
                    _hasSelectItem.add(item);
                    setState(() {
                      _hasSelectItem = _hasSelectItem;
                    });
                  });
              break;
            }
          }
          if (tempConut > 0) break; //终止外层for循环
        }
      }
    }
    if (count == 0) {
      //没有重复项处理
      _hasSelectItem.add(item);
    }
  }

  //列表单项
  Widget _listItem(SelectItemModel model, index) {
    var item = model.list[index];
    var curIndex = _hasSelectItem.indexWhere((e) => (e.id == item.id));
    return Container(
        child: new PhysicalModel(
      color: Colors.white, //设置背景底色透明
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
                if (curIndex < 0) {
                  _judgeItemExist(item);
                  //_hasSelectItem.add(item);
                } else {
                  _hasSelectItem.removeAt(curIndex);
                }
                setState(() {
                  _hasSelectItem = _hasSelectItem;
                });
              },
              child: new Row(
                children: <Widget>[
                  new Container(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Image.asset(
                      ImageHelper.wrapAssets(
                          curIndex < 0 ? 'record_sa.png' : 'record_sg.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  new Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(40),
                          right: ScreenUtil().setWidth(80)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(
                                  bottom: ScreenUtil().setWidth(5)),
                              child: Text(item.itemName.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(38),
                                    color: Color.fromRGBO(90, 90, 90, 1),
                                  ))),
                          Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(item.labDeptName.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(38),
                                    color: Color.fromRGBO(90, 90, 90, 1),
                                  )),
                              Text(item.specimenTypeName.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(38),
                                    color: Color.fromRGBO(90, 90, 90, 1),
                                  ))
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    ));
  }

  //头部搜索栏
  Widget _searchTitle(SelectItemModel model) {
    Timer dRequst;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
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
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Color.fromRGBO(0, 117, 255, 1)),
                      focusNode: focusNode,
                      controller: sController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: '请输入项目名称、助记符',
                        hintStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(42),
                          color: Color.fromRGBO(190, 190, 190, 1),
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
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
                          model.keyword = v.toString();
                          model.list.clear();
                          model.initData();
                        });
                      },
                      onSubmitted: (v) {
                        model.keyword = v.toString();
                        model.list.clear();
                        model.initData();
                      }),
                )),
          ),
          (showDimSearch && isRequire(sController.text))
              ? Positioned(
                  top: ScreenUtil().setHeight(164),
                  left: 0,
                  width: ScreenUtil.screenWidthDp - ScreenUtil().setWidth(180),
                  height: ScreenUtil().setHeight(480),
                  child: new PhysicalModel(
                      color: Colors.white, //设置背景底色透明
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      clipBehavior: Clip.antiAlias, //注意这个属性
                      elevation: 0.4,
                      child: _listChild(model)))
              : SizedBox(),
        ],
      ),
    );
  }
}
