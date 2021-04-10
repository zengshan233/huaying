import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';

class SelectItem extends StatelessWidget {
  SelectItemRightListItem item;
  Function delTap;
  Key key;
  SelectItem({this.item, this.delTap, this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: key == null ? UniqueKey() : key,
        child: new PhysicalModel(
          color: Colors.white, //设置背景底色透明
          clipBehavior: Clip.antiAlias, //注意这个属性
          elevation: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30),
                vertical: ScreenUtil().setWidth(20)),
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
                                      right: ScreenUtil().setWidth(150)),
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
                                      Text(item.specimenTypeName.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(38),
                                            color:
                                                Color.fromRGBO(90, 90, 90, 1),
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
