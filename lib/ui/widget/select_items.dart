import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show gradualButton, noDataWidget;

class SelectItems extends StatefulWidget {
  final List<String> nameList;
  String pickedName;
  final Function confirm;
  SelectItems({this.nameList, this.confirm, this.pickedName});
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
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6))),
      child: Column(
        children: <Widget>[
          // widget.nameList.length <= 5
          //     ? Column(
          //         children: List.generate(
          //             widget.nameList.length, (i) => _listItem(i)),
          //       )
          //     :
          Container(
            height: ScreenUtil().setHeight(660),
            child: widget.nameList == null
                ? Center(
                    child: UnconstrainedBox(
                        child: Container(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(DiyColors.heavy_blue),
                    ),
                  )))
                : widget.nameList.isEmpty
                    ? noDataWidget(text: '暂无数据')
                    : CustomScrollView(
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
            // constraints: BoxConstraints(
            //   minHeight: ScreenUtil().setHeight(80),
            // ),
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
                widget.confirm(
                    widget.nameList.indexWhere((n) => n == _pickedName));
              },
              child: new Row(
                children: <Widget>[
                  new Container(
                    width: ScreenUtil().setWidth(50),
                    height: ScreenUtil().setWidth(50),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Image.asset(
                      ImageHelper.wrapAssets(_pickedName == item
                          ? 'select_on.png'
                          : 'select_off.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  new Expanded(
                    child: new Text(item,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color.fromRGBO(90, 90, 90, 1),
                        )),
                  ),
                ],
              ),
            )),
      ),
    ));
  }
}
