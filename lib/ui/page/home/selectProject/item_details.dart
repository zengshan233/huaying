import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/view_model/home/select_item_company_model.dart';

class ItemDetails extends StatefulWidget {
  final String id;
  final SelectProjectItem item;
  final int type;
  ItemDetails({this.id, this.item, this.type});
  @override
  _ItemDetails createState() => _ItemDetails();
}

class _ItemDetails extends State<ItemDetails> {
  List<ProjectDetailItem> _list = [];

  @override
  void initState() {
    super.initState();
  }

  getData(SelectItemModel model) async {
    if (widget.item != null) {
      _list = widget.item.detailList;
    } else {
      try {
        _list = await model.loadDetail(widget.id);
      } catch (e) {}
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SelectItemModel>(
        model: SelectItemModel(
            context: context, keyword: "", itemType: "1", labDeptId: ""),
        autoDispose: false,
        onBuildReady: (model) async {
          getData(model);
        },
        builder: (cContext, model, child) {
          return Container(
            width: ScreenUtil().setWidth(800),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildHead(),
                Container(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20)),
                              child: Text('项目名称',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    color: Color.fromRGBO(90, 90, 90, 1),
                                  ))),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("编码",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(36),
                                    color: Color.fromRGBO(90, 90, 90, 1),
                                  )),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text("标本类型",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(36),
                                  color: Color.fromRGBO(90, 90, 90, 1),
                                )))
                      ],
                    )),
                Container(
                    height: ScreenUtil().setWidth(150) *
                        (min(max(_list.length, 3), 6)),
                    padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (c, i) => buildItem(_list[i]),
                            childCount: _list.length,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          );
        });
  }

  Widget buildHead() {
    return Container(
      width: ScreenUtil().setWidth(800),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      height: ScreenUtil().setWidth(150),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 1, child: Container()),
          Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text('${widget.type == 3 ? '套餐' : '组合'}详情',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(44),
                        color: Color.fromRGBO(90, 90, 90, 1),
                        fontWeight: FontWeight.bold)),
              )),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(60)),
                        child: Image(
                            color: Colors.black,
                            width: ScreenUtil().setWidth(60),
                            height: ScreenUtil().setWidth(60),
                            image:
                                AssetImage(ImageHelper.wrapAssets("close.png")),
                            fit: BoxFit.fill),
                      ))
                ],
              )),
        ],
      ),
    );
  }

  //列表单项
  Widget buildItem(ProjectDetailItem item) {
    return Container(
        height: ScreenUtil().setWidth(140),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: GlobalConfig.borderColor,
                  width: 1.5 / ScreenUtil.pixelRatio)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  alignment: Alignment.centerLeft,
                  child: Text(item.name.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color.fromRGBO(90, 90, 90, 1),
                      ))),
            ),
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
                      if (widget.item == null) {
                        return;
                      }
                      Navigator.pushNamed(
                              context, RouteName.specimentSpecimenType,
                              arguments: {'id': item.collectSpecimenTypeId})
                          .then((value) {
                        if (value != null) {
                          Map tempMap = value;
                          item.collectSpecimenTypeId = tempMap['id'];
                          item.collectSpecimenTypeName = tempMap['name'];
                          setState(() {});
                        }
                      });
                    },
                    child: Text(item.collectSpecimenTypeName ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: DiyColors.heavy_blue,
                        ))))
          ],
        ));
  }
}
