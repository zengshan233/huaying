import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class RecrodModel extends ViewStateModel {
  BuildContext context;
  RecrodModel(this.context);

  var yyDialog;

  //提交数据
  Future<bool> recordSavaSubmitData(List<Map<String, dynamic>> list) async {
    yyDialog = yyProgressDialogBody();
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    setBusy();
    try {
      await Repository.fetchRecordSavaSubmit(list, labId);
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

  //批量录单判断条号编码是否存在
  Future<List<dynamic>> judgeSpecimenCodeExistData(String barCodes) async {
    yyDialog = yyProgressDialogBody();
    setBusy();
    try {
      List<dynamic> response =
          await Repository.fetchJudgeSpecimenCodeExist(barCodes);
      setIdle();
      dialogDismiss(yyDialog);
      return response;
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
      return null;
    }
  }
}
