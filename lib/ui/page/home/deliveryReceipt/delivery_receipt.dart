import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;
import 'package:huayin_logistics/model/delivery_model.dart';

class DeliveryReceipt extends StatefulWidget {
  @override
  _DeliveryReceipt createState() => _DeliveryReceipt();
}

class _DeliveryReceipt extends State<DeliveryReceipt> {
  List<DeliveryItem> data = [];

  bool loading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    loading = true;
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      data = [
        DeliveryItem(
            date: '2021-02-13', billno: '02号标本箱', confirm: true, check: true),
        DeliveryItem(
            date: '2021-02-13', billno: '03号标本箱', confirm: false, check: true),
        DeliveryItem(
            date: '2021-02-13', billno: '04号标本箱', confirm: true, check: false),
        DeliveryItem(
            date: '2021-02-13', billno: '05号标本箱', confirm: false, check: false),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '交接单', '外勤:张三'),
        body: Column(
          children: <Widget>[
            buildTip(),
            Expanded(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (c, index) {
                      return buildItem(data[index]);
                    }))
          ],
        ));
  }

  Widget buildTip() {
    return Container(
      color: Color(0xFFdfeafc),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(30),
          horizontal: ScreenUtil().setWidth(50)),
      child: Row(
        children: <Widget>[
          Image(
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              image: new AssetImage(ImageHelper.wrapAssets("notice.png")),
              fit: BoxFit.fill),
          Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
              child: Text('点击可查看标本箱详情',
                  style: TextStyle(color: DiyColors.heavy_blue)))
        ],
      ),
    );
  }

  Widget buildItem(DeliveryItem item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(item.date),
                Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                    child: Row(children: [
                      Text(item.billno),
                      Image(
                          width: ScreenUtil().setWidth(60),
                          image: new AssetImage(
                              ImageHelper.wrapAssets("record_warn.png")),
                          fit: BoxFit.fill)
                    ]))
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20),
                      vertical: ScreenUtil().setWidth(15)),
                  decoration: BoxDecoration(
                      color: item.confirm ? Colors.white : Color(0xFFd6e6ff),
                      border: Border.all(
                          width: item.confirm ? 1 : 0,
                          color: Color(0xFFf0f0f0)),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  alignment: Alignment.center,
                  child: Text(
                    item.confirm ? '已确认' : '未确认',
                    style: TextStyle(
                        color: item.confirm
                            ? Color(0xFFcccccc)
                            : DiyColors.heavy_blue),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(40),
                      right: ScreenUtil().setWidth(40)),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20),
                      vertical: ScreenUtil().setWidth(15)),
                  decoration: BoxDecoration(
                      color: item.check ? Colors.white : Color(0xFFd6e6ff),
                      border: Border.all(
                          width: item.check ? 1 : 0, color: Color(0xFFf0f0f0)),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  alignment: Alignment.center,
                  child: Text(
                    item.check ? '已签收' : '未签收',
                    style: TextStyle(
                        color: item.check
                            ? Color(0xFFcccccc)
                            : DiyColors.heavy_blue),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
