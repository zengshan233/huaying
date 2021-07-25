import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/check_data_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class CheckModel extends ViewStateRefreshListModel<CheckItem> {
  BuildContext context;
  CheckModel({this.context}) {
    YYDialog.init(context);
    userModel = Provider.of<MineModel>(context, listen: false);
  }

  /// 详情页数据 / 搜索选中的数据
  CheckDetailData _checkDetail;

  CheckDetailData get checkDetail => _checkDetail;

  MineModel userModel;

  ///处理状态
  int aloneRecordStatus = 2;

  var yyDialog;

  int getTotal(int index) {
    return list.length;
  }

  /// 单据详情查询
  Future getCheckDetail(String id) async {
    Future.microtask(() {
      yyDialog = yyProgressDialogNoBody();
    });
    setBusy();
    try {
      _checkDetail =
          await Repository.fetchCheckDetail(id: id, labId: userModel.labId);
      setIdle();
      dialogDismiss(yyDialog);
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
    }
  }

  //审核通过
  Future adopt(String applyId, String remark, {Function success}) async {
    yyDialog = yyProgressDialogNoBody();

    setBusy();
    try {
      await Repository.fetchCheckAdopt(labId: userModel.labId, data: {
        "applyId": applyId,
        "operate": userModel.user.user.name,
        "operatorId": userModel.user.user.id,
        "remark": remark
      });
      setIdle();
      dialogDismiss(yyDialog);
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
      return false;
    }
    var dialog;
    dialog = yyNoticeDialog(text: '通过成功');
    await Future.delayed(Duration(milliseconds: 1500));
    dialogDismiss(dialog);
    success?.call();
  }

  //审核驳回
  Future refuse(String applyId, String remark, {Function success}) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      await Repository.fetchCheckRefuse(labId: userModel.labId, data: {
        "applyId": applyId,
        "operate": userModel.user.user.name,
        "operatorId": userModel.user.user.id,
        "remark": remark
      });
      setIdle();
      dialogDismiss(yyDialog);
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
      return false;
    }
    var dialog;
    dialog = yyNoticeDialog(text: '驳回成功');
    await Future.delayed(Duration(milliseconds: 1500));
    dialogDismiss(dialog);
    success?.call();
  }

  @override
  Future<List<CheckItem>> loadData(
      {int pageNum, bool showLoading = false}) async {
    try {
      var response = await Repository.fetchCheckList(pageNum, userModel.labId,
          aloneRecordStatus: aloneRecordStatus);
      return response == null ? [] : response;
    } catch (e, s) {
      setError(e, s);
      showErrorMessage(context);
      return [];
    }
  }
}
