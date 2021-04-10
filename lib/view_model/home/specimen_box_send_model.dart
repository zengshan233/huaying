import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';

class SpecimenBoxSendModel extends ViewStateModel {
	BuildContext context;
	SpecimenBoxSendModel(this.context);

	var yyDialog;
	//选择路线
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
	Future<bool> specimenSendSubmitData(String boxNo,String specimenAmount,List<Map<String,dynamic>> images,String logisticsLine,String sender,String senderId) async {
		yyDialog = yyProgressDialogBody();
		setBusy();
		try {
		await Repository.fetchSpecimenSendSubmit(boxNo, specimenAmount, images,logisticsLine,sender,senderId);
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
