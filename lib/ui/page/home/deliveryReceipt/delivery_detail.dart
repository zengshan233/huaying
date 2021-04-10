import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;

class DeliveryDetail extends StatefulWidget {
  @override
  _DeliveryDetail createState() => _DeliveryDetail();
}

class _DeliveryDetail extends State<DeliveryDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '交接单', '外勤:张三'),
        body: Column(
          children: <Widget>[],
        ));
  }
}
