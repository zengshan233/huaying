import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/site_model.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class TransferPickerModel
    extends ViewStateRefreshListModel<SpecimenboxArriveItem> {
  BuildContext context;

  String labId;

  String boxNo;

  String userId;

  String lineId;

  bool isDelivered;

  TransferPickerModel(
      {this.context,
      this.labId,
      this.boxNo,
      this.userId,
      this.lineId,
      this.isDelivered = false});

  var yyDialog;
  //获取选择项目左侧菜单
  Future<List<WayModelItem>> selectItemLeftMenuData() async {
    setBusy();
    try {
      WayModel response = await Repository.fetchSpecimenSendSelectWay(userId);
      setIdle();
      return response.list;
    } catch (e, s) {
      print("selectItemLeftMenuData error $e ");
      setError(e, s);
      showErrorMessage(context);
      return null;
    }
  }

  //标本箱操作弹窗提示
  void specimenExceptionOperate(
      {String itemId, String confirmRemark, Function callBack}) async {
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    var userInfo = userModel.user?.user;
    KumiPopupWindow pop = PopUtils.showLoading();
    try {
      await Repository.fetchSpecimenExceptionOperate(
          labId: userModel.labId,
          confirmId: userInfo.id,
          confirmName: userInfo.name,
          confirmRemark: confirmRemark,
          id: itemId);
    } catch (e, s) {
      pop.dismiss(context);
      setError(e, s);
      showErrorMessage(context);
      return;
    }
    pop.dismiss(context);
    setIdle();
    callBack();
  }

  @override
  Future<List<SpecimenboxArriveItem>> loadData({int pageNum}) async {
    List<SpecimenboxArriveItem> response;
    try {
      response = await Repository.fetchTransportListData(
          labId: labId,
          pickUpId: userId,
          boxNo: boxNo,
          lineId: lineId,
          isDelivered: isDelivered);
    } catch (e, s) {
      setError(e, s, errState: false);
      showErrorMessage(context);
      return [];
    }
    return response == null ? [] : response;
  }
}
