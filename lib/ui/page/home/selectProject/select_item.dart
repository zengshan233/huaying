import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';

class SelectItem extends StatefulWidget {
  List<SelectItemRightListItem> hasSelectItems = [];
  Key key;
  Function(List<SelectItemRightListItem>) updateItems;
  SelectItem({this.hasSelectItems, this.key, this.updateItems});
  @override
  _SelectItem createState() => _SelectItem(
        hasSelectItems: hasSelectItems,
        key: key,
      );
}

class _SelectItem extends State<SelectItem> {
  List<SelectItemRightListItem> hasSelectItems = [];
  Key key;
  Function updateItems;
  _SelectItem({this.hasSelectItems, this.key, this.updateItems});
  List<SelectItemRightListItem> _hasSelectItem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hasSelectItem = hasSelectItems;
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = _hasSelectItem.length;
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(180) * (itemCount >= 6 ? 6 : itemCount),
      child: ListView(
        children: (() {
          List<Widget> tempList = [];
          for (var x in _hasSelectItem) {
            tempList.add(buildItem(
                item: x,
                key: ObjectKey('$x.id'),
                delTap: () {
                  // focusNode.unfocus();
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

  Widget buildItem(
      {ObjectKey key, SelectItemRightListItem item, Function delTap}) {
    return Container(
        key: key == null ? UniqueKey() : key,
        height: ScreenUtil().setWidth(180),
        child: new PhysicalModel(
          color: Colors.white, //设置背景底色透明
          clipBehavior: Clip.antiAlias, //注意这个属性
          elevation: 0,
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
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
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(4)),
                  onPressed: () {},
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(20),
                                      bottom: ScreenUtil().setWidth(5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(item.itemName.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(38),
                                            color:
                                                Color.fromRGBO(90, 90, 90, 1),
                                          )),
                                      InkWell(
                                          onTap: delTap,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Image.asset(
                                              ImageHelper.wrapAssets(
                                                  'delete.png'),
                                              width: ScreenUtil().setWidth(60),
                                              height: ScreenUtil().setWidth(60),
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ))
                                    ],
                                  )),
                              Container(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(200)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(item.labDeptName.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(38),
                                            color:
                                                Color.fromRGBO(90, 90, 90, 1),
                                          )),
                                      InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                RouteName.specimentSpecimenType,
                                                arguments: {
                                                  'id': item.specimenTypeId
                                                }).then((value) {
                                              if (value != null) {
                                                Map tempMap = value;
                                                int idx =
                                                    _hasSelectItem.indexWhere(
                                                        (i) => i.id == item.id);
                                                _hasSelectItem[idx]
                                                        .specimenTypeId =
                                                    tempMap['id'];
                                                _hasSelectItem[idx]
                                                        .specimenTypeName =
                                                    tempMap['name'];
                                                setState(() {});
                                              }
                                            });
                                          },
                                          child: Container(
                                            child: Text(
                                                item.specimenTypeName
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(38),
                                                  color: DiyColors.heavy_blue,
                                                )),
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
}
