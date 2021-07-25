import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/utils/popUtils.dart';

import 'item_details.dart';

class SelectItem extends StatefulWidget {
  List<SelectProjectItem> hasSelectItems = [];
  Key key;
  Function(List<SelectProjectItem>) updateItems;
  SelectItem({this.hasSelectItems, this.key, this.updateItems});
  @override
  _SelectItem createState() => _SelectItem(
        hasSelectItems: hasSelectItems,
        updateItems: updateItems,
        key: key,
      );
}

class _SelectItem extends State<SelectItem> {
  List<SelectProjectItem> hasSelectItems = [];
  Key key;
  Function(List<SelectProjectItem>) updateItems;
  _SelectItem({this.hasSelectItems, this.key, this.updateItems});
  List<SelectProjectItem> _hasSelectItem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hasSelectItem = hasSelectItems;
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = _hasSelectItem.length;
    int detailItemCount = 0;

    _hasSelectItem.forEach((s) {
      s.detailList.forEach((d) {
        detailItemCount += 1;
      });
    });
    if (itemCount == 0) {
      return Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [noDataWidget(text: '暂未选择项目')],
        ),
      );
    }
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(180) * (itemCount >= 6 ? 6 : itemCount) +
          (detailItemCount * ScreenUtil().setWidth(50)),
      child: ListView(
        children: (() {
          List<Widget> tempList = [];
          for (var x in _hasSelectItem) {
            tempList.add(buildItem(
                item: x,
                key: ObjectKey('$x.id'),
                delTap: () {
                  print("tempList $tempList");
                  var curIndex = tempList.indexWhere((e) =>
                      (e.key.toString() == ObjectKey('$x.id').toString()));
                  _hasSelectItem.removeAt(curIndex);
                  setState(() {});
                  updateItems(_hasSelectItem);
                }));
          }
          return tempList.map((e) => e).toList();
        })(),
      ),
    );
  }

  //列表单项
  Widget buildItem({ObjectKey key, SelectProjectItem item, Function delTap}) {
    return Container(
        key: key,
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: GlobalConfig.borderColor,
                  width: 1.5 / ScreenUtil.pixelRatio)),
        ),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: InkWell(
                  onTap: () {
                    if ([2, 3].contains(item.type)) {
                      PopUtils.showPop(
                          opacity: 0.5,
                          animated: false,
                          child: ItemDetails(
                            item: item,
                            type: item.type,
                          ));
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
                                                fontSize:
                                                    ScreenUtil().setSp(36),
                                                color: Color.fromRGBO(
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
                              child: InkWell(
                                  onTap: () {
                                    if ([2, 3].contains(item.type)) {
                                      return;
                                    }
                                    Navigator.pushNamed(context,
                                        RouteName.specimentSpecimenType,
                                        arguments: {
                                          'id': item.specimenTypeId
                                        }).then((value) {
                                      if (value != null) {
                                        Map tempMap = value;
                                        int idx = _hasSelectItem
                                            .indexWhere((i) => i.id == item.id);
                                        _hasSelectItem[idx].specimenTypeId =
                                            tempMap['id'];
                                        _hasSelectItem[idx].specimenTypeName =
                                            tempMap['name'];
                                        setState(() {});
                                      }
                                    });
                                  },
                                  child: Text(item.specimenTypeName ?? "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(36),
                                        color: DiyColors.heavy_blue,
                                      ))))
                        ],
                      )))),
            ),
            InkWell(
                onTap: delTap,
                child: Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    ImageHelper.wrapAssets('delete.png'),
                    width: ScreenUtil().setWidth(60),
                    height: ScreenUtil().setWidth(60),
                    fit: BoxFit.scaleDown,
                  ),
                )),
          ],
        ));
  }
}
