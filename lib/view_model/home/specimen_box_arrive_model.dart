import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';


class SpecimenBoxArriveModel extends ViewStateRefreshListModel {

	BuildContext context;
	
	String deliveryDriverId;

	SpecimenBoxArriveModel({this.context,this.deliveryDriverId});

  	var yyDialog;
	//标本箱编号查询标本箱信息
	Future<SpecimenboxArriveItem> specimenArriveInquiryByBoxNoData(String boxNo) async {
		yyDialog = yyProgressDialogBody(text: '查询中...');
		setBusy();
		try {
			var response=await Repository.fetchSpecimenArriveInquiryByBoxNo(boxNo);
			dialogDismiss(yyDialog);
			setIdle();
			if(response.status!=2&&response.status!=1){
				showMsgToast(
					'该标本箱状态为${response.statusName}', 
					context: context
				);
				return null;
			}
			return response;
		} catch (e,s) {
			dialogDismiss(yyDialog);
			setError(e, s);
			showErrorMessage(context);
			return null;
		}
	}

	//标本箱操作弹窗提示
	void specimenArriveOperate(String id,String updateAt,String driverContactNumber,String nodeHandlerId,String nodeHandlerName,Function callBack){
		yyAlertDialogWithDivider(tip: '是否确认送达？',success: () async{
			await Future.delayed(Duration(milliseconds: 100));
			specimenArriveOperateData(id,updateAt,driverContactNumber,nodeHandlerId,nodeHandlerName).then((val){
				if(val)callBack();
			});
		});
	}

	//标本箱送达操作
	Future<bool> specimenArriveOperateData(String id,String updateAt,String driverContactNumber,String nodeHandlerId,String nodeHandlerName) async {
		yyDialog = yyProgressDialogBody();
		setBusy();
		try {
			await Repository.fetchSpecimenArriveOperate(id,updateAt,driverContactNumber,nodeHandlerId,nodeHandlerName);
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

	//标本箱分页查询
	@override
	Future<List<SpecimenboxArriveItem>> loadData({int pageNum}) async {
		var response=await Repository.fetchSpecimenArriveInquiryByPage(deliveryDriverId,pageNum);
		return response==null?[]:response;
	}

}

