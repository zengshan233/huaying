//import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/specimen_status_inquiry_data_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';


class SpecimenStatusInquiryModel extends ViewStateRefreshListModel {

	BuildContext context;
	
	String inputParam;//搜索框内容
	String createTime;//开始时间
	String endTime;//结束时间
	List<String> inspectionIds;//送检医院id
	List<String> itemIds; //申请项目id
	bool applyDate; //时间排序
	bool inspection; //医院排序
	bool specimenStatusName; //标本状态排序

	SpecimenStatusInquiryModel({
		this.context,
		this.inputParam="",
		this.createTime="",
		this.endTime="",
		this.inspectionIds,
		this.itemIds,
		this.applyDate=true,
		this.inspection=false,
		this.specimenStatusName=false
	});

	//标本状态详情查询
	Future<SpecimenStatusInquiryDataModelDetail> specimenStatusDetailInquiryData(String id) async {
		setBusy();
		try {
			var response = await Repository.fetchSpecimenStatusDetailInquiry(id);
			//print('响应数据'+response.toString());
			setIdle();
			return response;
		} catch (e, s) {
			setError(e, s);
			showErrorMessage(context);
			return null;
		}
	}

	//标本箱分页查询
	@override
	Future<List<SpecimenStatusInquiryDataModelItem>> loadData({int pageNum}) async {
		try{
			var response=await Repository.fetchSpecimenStatusInquiry(
				pageNum,
				inputParam,
				createTime,
				endTime,
				inspectionIds,
				itemIds,
				applyDate,
				inspection,
				specimenStatusName
			);
			return response==null?[]:response;
		}catch(e, s){
			setError(e, s);
			showMsgToast(e.error.toString().substring(10,e.error.toString().length-1),context: context);
			return [];
		}
	}

}

