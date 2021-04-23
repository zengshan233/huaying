import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/model/site_model.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class SpecimenBoxSendModel extends ViewStateModel {
  BuildContext context;
  SpecimenBoxSendModel(this.context);

  var yyDialog;

  //选择路线
  Future<List<SiteModel>> specimenSendSelectSiteData(String labId) async {
    setBusy();
    try {
      List<SiteModel> response =
          await Repository.fetchArriveSiteList(labId: labId);
      //print('响应数据'+response.toString());
      setIdle();
      return response;
    } catch (e, s) {
      setError(e, s);
      return null;
    }
  }

  //选择站点
  Future<WayModel> specimenSendSelectWayData(String id) async {
    setBusy();
    try {
      var response = await Repository.fetchSpecimenSendSelectWay(id);
      //print('响应数据'+response.toString());
      setIdle();
      return response;
    } catch (e, s) {
      setError(e, s);
      return null;
    }
  }

  //提交数据
  Future<bool> specimenSendSubmitData(
      {Map<String, dynamic> data, String labId}) async {
    yyDialog = yyProgressDialogBody();
    setBusy();
    try {
      await Repository.fetchSpecimenSendSubmit(data: data, labId: labId);
      setIdle();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
      return false;
    }
  }
}
