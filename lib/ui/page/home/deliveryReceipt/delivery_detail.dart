import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class DeliveryDetail extends StatelessWidget {
  final String boxNo;
  DeliveryDetail({this.boxNo});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DeliveryDetailPage(
      boxNo: boxNo,
      context: context,
    );
  }
}

class DeliveryDetailPage extends StatefulWidget {
  final String boxNo;
  BuildContext context;
  DeliveryDetailPage({this.boxNo, this.context});
  @override
  _DeliveryDetailPage createState() => _DeliveryDetailPage();
}

class _DeliveryDetailPage extends State<DeliveryDetailPage> {
  @override
  void initState() {
    super.initState();
    getDetail(widget.context);
  }

  getDetail(context) async {
    MineModel model = Provider.of<MineModel>(context);

    /// 先写死
    String labId = '82858490362716212';
    String userId = model.user.user.id;
    var response;
    try {
      response = await Repository.fetchDeliveryId(
          boxNo: widget.boxNo, labId: labId, recordId: userId);
    } catch (e) {
      print('getBoxlist error $e');
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '交接单详情', '外勤:', withName: true),
        body: Column(
          children: <Widget>[],
        ));
  }
}
