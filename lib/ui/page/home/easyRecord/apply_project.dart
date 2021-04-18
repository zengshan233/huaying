import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart' show radiusButton;

class ApplyProject extends StatefulWidget {
  final Function(List<Map<String, String>>) updateProject;
  ApplyProject({this.updateProject});
  @override
  _ApplyProject createState() => _ApplyProject();
}

class _ApplyProject extends State<ApplyProject> {
  List<Map<String, String>> _projectItemArray = [];

  List<SelectItemRightListItem> _hasSelectItem = []; //已选择的项目

  @override
  void initState() {
    super.initState();
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
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                      child: Text('申请项目',
                          style: TextStyle(
                              color: DiyColors.normal_black,
                              fontSize: ScreenUtil().setSp(40))),
                    ),
                    Text('已添加${_projectItemArray.length}个项目',
                        style: TextStyle(
                            color: Color.fromRGBO(93, 164, 255, 1),
                            fontSize: ScreenUtil().setSp(30)))
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.selectItem,
                            arguments: {'hasSelectItem': _hasSelectItem})
                        .then((value) {
                      //print('接收到的项目返回值：'+value.toString());
                      if (value == null) {
                        return;
                      }
                      _projectItemArray.clear();
                      _hasSelectItem = value;
                      for (var x in jsonDecode(value.toString())) {
                        if (_projectItemArray
                            .any((e) => e['itemId'] == x['id'])) continue;
                        Map<String, String> tempObj = {};
                        tempObj['barCode'] = x['barCode'];
                        tempObj['enShortName'] = x['enShortName'];
                        tempObj['itemId'] = x['id'];
                        tempObj['itemName'] = x['itemName'];
                        tempObj['itemType'] = x['type'].toString();
                        tempObj['itemTypeName'] = x['typeName'];
                        tempObj['labId'] = x['labDeptId'];
                        tempObj['labName'] = x['labDeptName'];
                        tempObj['professionalGroupId'] = x['disciplineId'];
                        tempObj['professionalGroupName'] = x['disciplineName'];
                        tempObj['specimenType'] = x['specimenTypeId'];
                        tempObj['specimenTypeName'] = x['specimenTypeName'];
                        tempObj['sortOrder'] = x['sortOrder'].toString();
                        _projectItemArray.add(tempObj);
                      }
                      setState(() {});
                      widget.updateProject(_projectItemArray);
                    });
                  },
                  child: radiusButton(text: '添加', img: "plus.png"))
            ],
          ),
        ),
        _projectItemArray.length <= 5
            ? Column(
                children: _buildList(),
              )
            : Container(
                height: ScreenUtil().setHeight(700),
                child: ListView(
                  children: _buildList(),
                ),
              )
      ],
    );
  }

  List<Widget> _buildList() {
    print('_projectItemArray $_projectItemArray');
    List<Widget> tempList = [];
    tempList.clear();
    for (var i = 0, len = _projectItemArray.length; i < len; i++) {
      var x = _projectItemArray[i];
      tempList.add(
        _buildSingleProgect(i, x['itemName'].toString(), x['specimenTypeName'],
            x['specimenType'],
            key: ObjectKey('index$i'), delTap: () {
          var curIndex = tempList.indexWhere(
              (e) => (e.key.toString() == ObjectKey('index$i').toString()));
          _projectItemArray.removeAt(curIndex);
          _hasSelectItem.removeAt(curIndex);
          setState(() {
            _projectItemArray = _projectItemArray;
          });
          widget.updateProject(_projectItemArray);
        }),
      );
    }
    return tempList.reversed.toList();
  }

  //单个体检项目
  Widget _buildSingleProgect(
      int index, String text, String specimenTypeName, String specimenId,
      {Function delTap, Key key}) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil().setHeight(140),
      color: Colors.white,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(600)),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(90)),
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: DiyColors.normal_black,
                    fontSize: ScreenUtil().setSp(40))),
          ),
          Container(
            child: Row(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteName.specimentSpecimenType,
                          arguments: {'id': specimenId}).then((value) {
                        if (value != null) {
                          Map tempMap = value;
                          _projectItemArray[index]['specimenType'] =
                              tempMap['id'];
                          _projectItemArray[index]['specimenTypeName'] =
                              tempMap['name'];
                          setState(() {});
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(90)),
                      child: Text(specimenTypeName ?? '',
                          style: TextStyle(
                              color: DiyColors.heavy_blue,
                              fontSize: ScreenUtil().setSp(40))),
                    )),
                Container(
                  width: ScreenUtil().setHeight(80),
                  height: ScreenUtil().setHeight(60),
                  child: new FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        delTap?.call();
                      },
                      child: new Image.asset(
                        ImageHelper.wrapAssets('delete.png'),
                        width: ScreenUtil().setHeight(50),
                        height: ScreenUtil().setHeight(50),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
