import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/select_item_company_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'item_details.dart';

class ProjectList extends StatefulWidget {
  final SelectItemModel model;
  final List<SelectProjectItem> hasSelectItem;
  final Function updateItems;
  ProjectList({this.model, this.hasSelectItem, this.updateItems});
  @override
  _ProjectList createState() => _ProjectList();
}

class _ProjectList extends State<ProjectList>
    with SingleTickerProviderStateMixin {
  List<SelectProjectItem> _hasSelectItem = [];
  FocusNode focusNode = new FocusNode();

  bool showDimSearch = false;

  bool showItems = false;
  TextEditingController sController = TextEditingController();

  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _hasSelectItem = widget.hasSelectItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        _searchTitle(widget.model),
        Expanded(child: _tabViewList(widget.model))
      ],
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
                      textAlignVertical: TextAlignVertical.bottom,
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
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
                        border: OutlineInputBorder(borderSide: BorderSide.none),
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
        ],
      ),
    );
  }

  //tabViewItem
  Widget _tabViewList(model) {
    return model.busy
        ? UnconstrainedBox(
            child: Container(
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(DiyColors.heavy_blue),
            ),
          ))
        : _listChild(model);
  }

  //右边list
  Widget _listChild(SelectItemModel model) {
    return (model.list.length <= 0
        ? Container(
            width: ScreenUtil.screenWidth,
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(100)),
              child: noDataWidget(text: '暂无列表数据'),
            ),
          )
        : SmartRefresher(
            controller: model.refreshController,
            header: WaterDropHeader(),
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            enablePullUp: true,
            enablePullDown: true,
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

  void _judgeItemExist(item) async {
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

    widget.updateItems();
  }

  //列表单项
  Widget _listItem(SelectItemModel model, index) {
    var item = model.list[index];
    var curIndex = _hasSelectItem.indexWhere((e) => (e.id == item.id));
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: GlobalConfig.borderColor,
                  width: 1.5 / ScreenUtil.pixelRatio)),
        ),
        child: new Row(
          children: <Widget>[
            InkWell(
                onTap: () async {
                  if (curIndex < 0) {
                    List<ProjectDetailItem> _list = [];
                    if ([2, 3].contains(item.type)) {
                      _list = await model.loadDetail(item.id);
                      if (_list.isEmpty) {
                        showMsgToast('添加异常，请选择其他项目');
                        return;
                      }
                    }
                    item.detailList = _list;
                    _judgeItemExist(item);
                  } else {
                    _hasSelectItem.removeAt(curIndex);
                  }
                  setState(() {
                    _hasSelectItem = _hasSelectItem;
                  });
                  widget.updateItems();
                },
                child: new Container(
                  width: ScreenUtil().setWidth(80),
                  height: ScreenUtil().setWidth(80),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                  child: Image.asset(
                    ImageHelper.wrapAssets(
                        curIndex < 0 ? 'record_sa.png' : 'record_sg.png'),
                    fit: BoxFit.fitWidth,
                  ),
                )),
            new Expanded(
              child: InkWell(
                onTap: () {
                  if ([2, 3].contains(item.type)) {
                    PopUtils.showPop(
                        opacity: 0.5,
                        animated: false,
                        child: ItemDetails(id: item.id, type: item.type));
                  }
                },
                child: Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(5)),
                                    alignment: Alignment.centerLeft,
                                    child: Text(item.itemName.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(36),
                                          color: [2, 3].contains(item.type)
                                              ? DiyColors.heavy_blue
                                              : Color.fromRGBO(90, 90, 90, 1),
                                        ))),
                                (item.sampleTestMethodName ?? '').isEmpty
                                    ? Container()
                                    : Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(5)),
                                        child: Text(item.sampleTestMethodName,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(36),
                                              color: [2, 3].contains(item.type)
                                                  ? DiyColors.heavy_blue
                                                  : Color.fromRGBO(
                                                      90, 90, 90, 1),
                                            )),
                                      )
                              ],
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(item.codeNo ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    color: Color.fromRGBO(90, 90, 90, 1),
                                  )),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(item.specimenTypeName ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(36),
                                  color: DiyColors.heavy_blue,
                                )))
                      ],
                    ))),
              ),
            ),
          ],
        ));
  }
}
