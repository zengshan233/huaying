import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/model/specimen_status_inquiry_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart' show appBarComon, recordCard;
import 'package:huayin_logistics/view_model/home/specimen_status_inquiry_model.dart';


class SpecimenDetails extends StatefulWidget {
	final String specimenStatusId;
	SpecimenDetails({this.specimenStatusId});

	@override
	_SpecimenDetails createState() => _SpecimenDetails();
}

class _SpecimenDetails extends State<SpecimenDetails> {

	SpecimenStatusInquiryDataModelDetail specimenDetailsObj;

	@override
	void initState() {

		super.initState();
  	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			behavior: HitTestBehavior.translucent,
			onTap: () {
				// 触摸收起键盘
				FocusScope.of(context).requestFocus(FocusNode());
			},
			child: Scaffold(
				appBar: appBarComon(context,text:'标本详情'),
				body:new SingleChildScrollView(
					child: new Column(
						children: <Widget>[
							SizedBox(width: ScreenUtil.screenWidth,height: ScreenUtil().setHeight(20)),
							ProviderWidget<SpecimenStatusInquiryModel>(
								model: SpecimenStatusInquiryModel(context:context,inspectionIds:[],itemIds: []),
								onModelReady:(model){
									model.specimenStatusDetailInquiryData(widget.specimenStatusId).then((res){
										if(res!=null){
											Map<String,dynamic> strObj=jsonDecode(res.toString());
											//print(strObj);
											strObj.updateAll((String key,dynamic value){
												return value==null||value==''?'--':value;
											});
											setState(() {
												specimenDetailsObj=SpecimenStatusInquiryDataModelDetail.fromJson(strObj);
											});
										}
									});
								},
								builder: (cContext, model, child){
									return specimenDetailsObj==null?UnconstrainedBox(
										child: Container(
											width: ScreenUtil().setWidth(80),
											height: ScreenUtil().setWidth(80),
											margin: EdgeInsets.only(top:ScreenUtil().setHeight(300)),
											child: CircularProgressIndicator(
												backgroundColor: Colors.grey[200],
												valueColor: AlwaysStoppedAnimation(Color.fromRGBO(38, 181, 247, 1)),
											),
										)
									):_infoFrom();
								}
							),
							SizedBox(height: ScreenUtil().setHeight(40)),
						],
					),
				),
			),
		);
	}

	//信息表单
	Widget _infoFrom(){
		return 	recordCard(
			title:'基本信息',
			colors:[Color.fromRGBO(91, 168, 252, 1),Color.fromRGBO(56, 111, 252, 1)],
			titleRight: new Text(
				'${specimenDetailsObj.statusName}',//待提交 Color.fromRGBO(255, 101,61, 1)，已审核Color.fromRGBO(3, 227,235 , 1)，待核收Color.fromRGBO(0, 155,255 , 1),检测中Color.fromRGBO(255, 144,4,1)
				style: TextStyle(
					fontSize: ScreenUtil().setSp(38),
					color: ((){
						// 1001, "标本录入", "标本录入"
						// 1002, "标本提交", "标本提交"
						// 1003, "内勤接收", "标本检测中"
						// 1004, "实验室接收", "标本检测中"
						// 1005, "部分报告审核", "报告审核"
						// 1006, "报告审核", "报告审核"
						// 1007, "报告打印", "报告打印"
						Color tempColor=Color.fromRGBO(3, 227,235 , 1);
						switch (specimenDetailsObj.status) {
							case 1004:
								tempColor=Color.fromRGBO(255, 144,4,1);	//橙色
								break;
							// case 1001:
							// 	tempColor=Color.fromRGBO(255, 101,61, 1);//淡红	
							// 	break;
							case 1001:
								tempColor=Color.fromRGBO(3, 227,235 , 1);//绿色
								break;
							case 1002:
								tempColor=Color.fromRGBO(3, 227,235 , 1);//绿色
								break;	
							case 1003:
								tempColor=Color.fromRGBO(3, 227,235 , 1);//绿色
								break;		
							case 1006:
								tempColor=Color.fromRGBO(0, 155,255 , 1);//蓝色		
								break;		
							case 1007:
								tempColor=Color.fromRGBO(0, 155,255 , 1);//蓝色		
								break;			
							default:
						}
						return tempColor;
					})(),
				),
			),
			contentWidget: new Column(
				children: <Widget>[
					SizedBox(height: ScreenUtil().setHeight(10)),
					_infoFromItem(lable: '录单日期：',text: '${specimenDetailsObj.recordTime=='--'?'--':specimenDetailsObj.recordTime.substring(0,10)}'),
					_infoFromItem(lable: '条码号：',text: '${specimenDetailsObj.barCode}'),
					_infoFromItem(lable: '送检单位：',text: '${specimenDetailsObj.inspectionUnitName}'),
					_infoFromItem(lable: '就诊类型：',text: '${specimenDetailsObj.visitTypeName}'),
					_infoFromItem(lable: '姓名：',text: '${specimenDetailsObj.name}'),
					_infoFromItem(lable: '性别：',text: '${specimenDetailsObj.sexName}'),
					_infoFromItem(lable: '年龄：',text: '${specimenDetailsObj.age}'),
					_infoFromItem(lable: '手机号：',text: '${specimenDetailsObj.phone}'),
					_infoFromItem(lable: '诊疗卡号：',text: '${specimenDetailsObj.outpatientNumber}'),
					_infoFromItem(lable: '床号：',text: '${specimenDetailsObj.sickbedNumber}'),
					_infoFromItem(lable: '申请医生：',text: '${specimenDetailsObj.applyDoctorName}'),
					_infoFromItem(lable: '医生电话：',text: '${specimenDetailsObj.doctorPhone}'),
					_infoFromItem(lable: '申请科室：',text: '${specimenDetailsObj.departmentName}'),
					_infoFromItem(lable: '病区：',text: '${specimenDetailsObj.wardName}'),
					_infoFromItem(lable: '申请时间：',text: '${specimenDetailsObj.applyDate=='--'?'--':specimenDetailsObj.applyDate.substring(0,10)}'),
					_infoFromItem(lable: '采集时间：',text: '${specimenDetailsObj.collectorTime=='--'?'--':specimenDetailsObj.collectorTime.substring(0,10)}'),
					_infoFromItem(lable: '申请项目：',text: '${specimenDetailsObj.applyItems}'),
					_infoFromItem(lable: '备注：',text: '${specimenDetailsObj.remark}'),
					SizedBox(height: ScreenUtil().setHeight(40)),
				]
			)
		);
	}

	//单个表单项
	Widget _infoFromItem({String lable,String text}){
		return Container(
			padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
			child: Row(
				children: <Widget>[
					Container(
						constraints: BoxConstraints(
							minWidth: ScreenUtil().setWidth(230)
						),
						child: Text(
							lable,
							textAlign: TextAlign.right,
							style: TextStyle(
								fontSize: ScreenUtil().setSp(38),
								color: Color.fromRGBO(201, 201, 201, 1),
							),
						),
					),
					Expanded(
						child: Text(
						text,
						style: TextStyle(
							fontSize: ScreenUtil().setSp(38),
							color: Color.fromRGBO(90, 90, 91, 1),
						),
					),
					)
				],
			),
		);
	}

}
