import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/documentary_take_phone_data_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';

class DocumentaryTakePhoneModel extends ViewStateModel {
	BuildContext context;
	DocumentaryTakePhoneModel(this.context);

	var yyDialog;
	//根据条码号查询信息
	Future<DocumentaryTakePhoneDataModel> documentaryTakePhoneData(String barCode) async {
		yyDialog = yyProgressDialogBody();
		setBusy();
		try {
			var response = await Repository.fetchDocumentaryTakePhoneInfo(barCode);
			//print('响应数据'+response.toString());
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
	//提交数据
	Future<bool> documentaryTakePhoneSubmitData(List<Map<String,dynamic>> list) async {
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
