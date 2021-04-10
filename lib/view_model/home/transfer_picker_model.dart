import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/model/transfer_picker_model_data.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';


class TransferPickerModel extends ViewStateModel {

	BuildContext context;

	TransferPickerModel(this.context);

  	var yyDialog;
	//查询标本信息
	Future<TransferPickerData> transferPickerInquiry(String boxNo) async {
		yyDialog = yyProgressDialogBody(text: '查询中...');
		setBusy();
		try {
			var response=await Repository.fetchTransferPickerInquiry(boxNo);
			setIdle();
			dialogDismiss(yyDialog);
			return response;
		} catch (e, s) {
			dialogDismiss(yyDialog);
			setError(e, s);
			showErrorMessage(context);
			return null;
		}
	}
	//标本箱操作
	Future<bool> pickerOrCancelPicker(String id,String updateAt,String driverContactNumber,String nodeHandlerId,String nodeHandlerName,String status) async {
		yyDialog = yyProgressDialogBody();
		setBusy();
		try {
			await Repository.fetchPickerOrCancelPicker(id,updateAt,driverContactNumber,nodeHandlerId,nodeHandlerName,status);
			setIdle();
			dialogDismiss(yyDialog);
			return true;
		} catch (e, s) {
			dialogDismiss(yyDialog);
			setError(e, s);
			showErrorMessage(context);
			return false;
		}
	}

}

