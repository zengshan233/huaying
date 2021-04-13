import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show gradualButton;

class SelectItems extends StatefulWidget {
  final String title;
  final List<String> nameList;
  final Function(int) confirm;
  String pickedName;
  SelectItems({this.nameList, this.title, this.confirm, this.pickedName});
  @override
  _SelectItems createState() => _SelectItems();
}

class _SelectItems extends State<SelectItems> {
  String _pickedName;

  @override
  void initState() {
    super.initState();
    if (widget.pickedName != null) {
      _pickedName = widget.pickedName;
    }
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Container(
      width: ScreenUtil().setWidth(940),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(920),
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(30),
                bottom: ScreenUtil().setHeight(30),
                left: ScreenUtil().setHeight(30)),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: GlobalConfig.borderColor,
                      width: 1.5 / ScreenUtil.pixelRatio)),
            ),
            child: Text(
              widget.title ?? '',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(44),
                color: Color.fromRGBO(90, 90, 90, 1),
              ),
            ),
          ),
          widget.nameList.length <= 5
              ? Column(
                  children: List.generate(
                      widget.nameList.length, (i) => _listItem(i)),
                )
              : Container(
                  height: ScreenUtil().setHeight(660),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (c, i) => _listItem(i),
                          childCount: widget.nameList.length,
                        ),
                      ),
                    ],
                  ),
                ),
          new Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
            child: gradualButton('确定', onTap: () {
              Navigator.pop(context);
              widget
                  .confirm(widget.nameList.indexWhere((n) => n == _pickedName));
            }),
          )
        ],
      ),
    );
  }

  //列表单项
  Widget _listItem(index) {
    String item = widget.nameList[index];
    return Container(
        child: new PhysicalModel(
      color: Colors.white, //设置背景底色透明
      borderRadius: BorderRadius.all(Radius.circular(0)),
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
                setState(() {
                  _pickedName = item;
                });
              },
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(item,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color.fromRGBO(90, 90, 90, 1),
                        )),
                  ),
                  new Container(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Image.asset(
                      ImageHelper.wrapAssets(_pickedName == item
                          ? 'select_on.png'
                          : 'select_off.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
            )),
      ),
    ));
  }
}
