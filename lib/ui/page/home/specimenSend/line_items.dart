import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show gradualButton;
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';

class LineItems extends StatefulWidget {
  WayModel wayList;
  dynamic tempYYDialog;
  Function(String) confirm;
  String line;
  LineItems({this.wayList, this.tempYYDialog, this.confirm, this.line});
  @override
  _LineItems createState() => _LineItems();
}

class _LineItems extends State<LineItems> {
  String _logisticsLine = '';

  @override
  void initState() {
    super.initState();
    if (widget.line != null) {
      _logisticsLine = widget.line;
    }
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Container(
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
              '路线选择',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(44),
                color: Color.fromRGBO(90, 90, 90, 1),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(660),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (c, i) => _listItem(i),
                    childCount: widget.wayList.list.length,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
            child: gradualButton('确定', onTap: () {
              dialogDismiss(widget.tempYYDialog);
              Navigator.pop(context);
              widget.confirm(_logisticsLine);
            }),
          )
        ],
      ),
    );
  }

  //列表单项
  Widget _listItem(index) {
    var item = widget.wayList.list[index];
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
                  _logisticsLine = item.lineName;
                });
              },
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(item.lineName.toString(),
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
                      ImageHelper.wrapAssets(_logisticsLine == item.lineName
                          ? 'record_sg.png'
                          : 'record_sa.png'),
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
