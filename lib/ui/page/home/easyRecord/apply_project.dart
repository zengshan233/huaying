import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/selectProject/item_details.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show inputPreText, radiusButton;
import 'package:huayin_logistics/utils/events_utils.dart';
import 'package:huayin_logistics/utils/popUtils.dart';

class ApplyProject extends StatefulWidget {
  final Function(List<SelectProjectItem>) updateProject;
  ApplyProject({this.updateProject});
  @override
  _ApplyProject createState() => _ApplyProject();
}

class _ApplyProject extends State<ApplyProject> {
  List<SelectProjectItem> _selectedItems = []; //已选择的项目

  @override
  void initState() {
    super.initState();
    EventBus.instance.addListener(EventKeys.clearProjects, (map) {
      _selectedItems = [];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EventBus.instance.removeListener(EventKeys.clearProjects);
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil.screenWidth,
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
          height: ScreenUtil().setHeight(140),
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    inputPreText(preText: '申请项目', isRquire: true),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                      child: Text('已添加${_selectedItems.length}个项目',
                          style: TextStyle(
                              color: Color.fromRGBO(93, 164, 255, 1),
                              fontSize: ScreenUtil().setSp(30))),
                    )
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.selectProject,
                            arguments: {'hasSelectItem': _selectedItems})
                        .then((value) {
                      //print('接收到的项目返回值：'+value.toString());
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedItems = value;
                      });
                      widget.updateProject(_selectedItems);
                    });
                  },
                  child: radiusButton(text: '添加', img: "plus.png"))
            ],
          ),
        ),
        _selectedItems.length <= 5
            ? Column(
                children: _buildList(),
              )
            : Container(
                height: ScreenUtil().setWidth(900),
                child: ListView(
                  children: _buildList(),
                ),
              )
      ],
    );
  }

  List<Widget> _buildList() {
    List<Widget> tempList = _selectedItems
        .map((item) => buildItem(
              data: item,
            ))
        .toList();
    return tempList.reversed.toList();
  }

  Widget buildItem({SelectProjectItem data}) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: GlobalConfig.borderColor,
                  width: 1.5 / ScreenUtil.pixelRatio)),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setWidth(30)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(40)),
              child: Text(
                  data.type == 3
                      ? '套餐'
                      : data.type == 2
                          ? '组合'
                          : '单项',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(data.type == 3 ? 40 : 38),
                    color: Color.fromRGBO(90, 90, 90, 1),
                  )),
            ),
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          if ([2, 3].contains(data.type)) {
                            PopUtils.showPop(
                                opacity: 0.5,
                                animated: false,
                                child: ItemDetails(
                                  item: data,
                                  type: data.type,
                                ));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(10)),
                          child: Text(data.itemName.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: [2, 3].contains(data.type)
                                    ? DiyColors.heavy_blue
                                    : Color.fromRGBO(90, 90, 90, 1),
                              )),
                        ),
                      ),
                      (data.sampleTestMethodName ?? '').isEmpty
                          ? Container()
                          : Text(data.sampleTestMethodName ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: [2, 3].contains(data.type)
                                    ? DiyColors.heavy_blue
                                    : Color.fromRGBO(90, 90, 90, 1),
                              )),
                    ],
                  ),
                )),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          if ([2, 3].contains(data.type)) {
                            return;
                          }
                          Navigator.pushNamed(
                                  context, RouteName.specimentSpecimenType,
                                  arguments: {'id': data.specimenTypeId})
                              .then((value) {
                            if (value != null) {
                              Map tempMap = value;
                              data.specimenTypeId = tempMap['id'];
                              data.specimenTypeName = tempMap['name'];
                              setState(() {});
                            }
                          });
                        },
                        child: Container(
                          child: Text(data.specimenTypeName ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: DiyColors.heavy_blue,
                              )),
                        ))
                  ],
                )),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          _selectedItems
                              .removeWhere((element) => element == data);
                          setState(() {});
                          widget.updateProject(_selectedItems);
                        },
                        child: Container(
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            ImageHelper.wrapAssets('delete.png'),
                            fit: BoxFit.cover,
                          ),
                        ))
                  ],
                ))
          ],
        ));
  }
}
