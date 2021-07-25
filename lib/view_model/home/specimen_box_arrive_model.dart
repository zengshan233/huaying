import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class SpecimenBoxArriveModel
    extends ViewStateRefreshListModel<SpecimenboxArriveItem> {
  BuildContext context;

  String boxNo;

  bool isDelivered;

  SpecimenBoxArriveModel({this.context, this.isDelivered, this.boxNo});

  //标本箱操作弹窗提示
  void specimenArriveOperate(
      {String id,
      String deliveredId,
      String deliveredName,
      Function callBack}) {
    yyAlertDialogWithDivider(
        tip: '是否确认送达？',
        success: () async {
          await Future.delayed(Duration(milliseconds: 100));
          specimenArriveOperateData(
                  deliveredId: deliveredId,
                  deliveredName: deliveredName,
                  id: id)
              .then((val) {
            if (val) callBack();
          });
        });
  }

  //标本箱送达操作
  Future<bool> specimenArriveOperateData(
      {String id, String deliveredId, String deliveredName}) async {
    KumiPopupWindow pop = PopUtils.showLoading();
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    try {
      await Repository.fetchSpecimenArriveOperate(
          labId: labId,
          deliveredId: deliveredId,
          deliveredName: deliveredName,
          id: id);
      pop.dismiss(context);
      setIdle();
      return true;
    } catch (e, s) {
      pop.dismiss(context);
      setError(e, s);
      showErrorMessage(context);
      return false;
    }
  }

  //标本箱分页查询
  @override
  Future<List<SpecimenboxArriveItem>> loadData({int pageNum}) async {
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    List<SpecimenboxArriveItem> response;
    try {
      response = await Repository.fetchTransportData(
          labId: labId, isDelivered: isDelivered, boxNo: boxNo);
    } catch (e, s) {
      setError(e, s, errState: false);
      showErrorMessage(context);
      return [];
    }
    return response == null ? [] : response;
  }
}
