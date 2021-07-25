import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';

class DocumentaryTakePhoneModel extends ViewStateModel {
  BuildContext context;
  DocumentaryTakePhoneModel(this.context);

  var yyDialog;
  //根据条码号查询信息
  Future<Map> documentaryTakePhoneData(
      {BuildContext context,
      String barCode,
      String labId,
      String recordId}) async {
    KumiPopupWindow pop = PopUtils.showLoading();
    try {
      Map response = await Repository.fetchDocumentaryTakePhoneInfo(barCode);
      RecordedItem item = await Repository.fetchRecordedBarcode(
          labId: labId, barCode: barCode, recordId: recordId);
      response['boxNo'] = item?.boxNo;
      setIdle();
      pop.dismiss(context);
      return response;
    } catch (e, s) {
      PopUtils.dismiss();
      setError(e, s);
      showErrorMessage(context);
      return null;
    }
  }

  //提交数据
  Future<bool> documentaryTakePhoneSubmitData(
      List<Map<String, dynamic>> list) async {
    yyDialog = yyProgressDialogBody();
    setBusy();
    try {
      await Repository.fetchDocumentaryTakePhoneSubmit(list);
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
