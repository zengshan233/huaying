import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/receive_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class SpecimenReceiveModel extends ViewStateRefreshListModel<ReceiveListItem> {
  BuildContext context;
  String boxNo;
  bool isRecived;

  SpecimenReceiveModel({this.context, this.boxNo, this.isRecived = false});

  //标本箱操作弹窗提示
  void specimenReceiveOperate({List<String> joinIds, Function callBack}) {
    yyAlertDialogWithDivider(
        tip: '是否确认接收？',
        success: () async {
          await Future.delayed(Duration(milliseconds: 100));
          specimenReceiveOperateData(
            joinIds: joinIds,
          ).then((val) {
            if (val) callBack();
          });
        });
  }

  //标本箱送达操作
  Future<bool> specimenReceiveOperateData({List<String> joinIds}) async {
    KumiPopupWindow pop = PopUtils.showLoading();
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    try {
      await Repository.fetchSpecimenReceiveOperate(
          labId: labId, joinIds: joinIds);
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

  @override
  Future<List<ReceiveListItem>> loadData({int pageNum}) async {
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    String userId = userModel.user?.user?.id;
    var response = await Repository.fetchReceiveData(
        labId: labId,
        boxNo: boxNo,
        userId: userId,
        receiveStatus: isRecived ? 2 : 1,
        pageNumber: pageNum);
    return response == null ? [] : response;
  }
}
