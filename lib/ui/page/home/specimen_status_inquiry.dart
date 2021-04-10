import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart' show appBarComon, gradualButton, listTitleDecoration, noDataWidget, showMsgToast, singleProgect;
import 'package:huayin_logistics/ui/widget/data_picker.dart' show showPickerDateRange;
import 'package:huayin_logistics/ui/widget/dialog/custom_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/view_model/home/specimen_status_inquiry_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class SpecimenStatusInquiry extends StatefulWidget {
	final String barCode;
	SpecimenStatusInquiry({this.barCode});

	@override
	_SpecimenStatusInquiry createState() => _SpecimenStatusInquiry();
}

class _SpecimenStatusInquiry extends State<SpecimenStatusInquiry> {
	
	List<String> _selectListData=['录单日期','标本状态','送检单位'];

	int _selectCurrentIndex=0;

	List<String> _itemNameArray=[];//申请项目名称

	List<String> _companyNameArray=[];//送检单位名称

	String _seTimg='';//开始结束时间

	TextEditingController _inputSearchController=TextEditingController();

	var tempDialog; //弹窗

	List<SelectItemRightListItem> _hasSelectItem=[]; //已选择的项目

	@override
	void initState() {
		//print('接收到的参数：'+widget.barCode.toString());
		super.initState();
  	}

	@override
	Widget build(BuildContext context) {
		YYDialog.init(context);
		return GestureDetector(
			behavior: HitTestBehavior.translucent,
			onTap: () {
				// 触摸收起键盘
				FocusScope.of(context).requestFocus(FocusNode());
			},
			child: Scaffold(
				backgroundColor: Color.fromRGBO(242, 243, 249, 1),
				appBar: appBarComon(context,text:'标本状态查询'),
				body:ProviderWidget<SpecimenStatusInquiryModel>(
					model: SpecimenStatusInquiryModel(context:context,inspectionIds:[],itemIds: []),
					onModelReady:(model){
						_inputSearchController.text=widget.barCode.toString();
						model.inputParam=_inputSearchController.text;
						model.initData();
					},
					builder: (cContext, model, child){
						return Column(
							children: <Widget>[
								_searchTitle(model,context),
								Offstage(
									offstage: model.list.length>0,
									child: Container(
										width: ScreenUtil.screenWidth,
										padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
										child: Container(
											decoration: BoxDecoration(
												color: Colors.white,
												borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight:Radius.circular(10))
											),
											padding: EdgeInsets.symmetric(vertical:ScreenUtil().setHeight(100)),
											child: noDataWidget(text: '暂无列表数据'),
										),
									)
								),
								new Expanded(
									child: Offstage(
										offstage: model.list.length<=0,
										child: SmartRefresher(
											controller: model.refreshController,
											header: WaterDropHeader(),
											onRefresh: model.refresh,
											onLoading: model.loadMore,
											enablePullUp: true,
											child: _listChild(model),
										)
									),
								)
							],
						);
					}
				)
			),
		);
	}

	//单项列表
	Widget _listChild(model){
		return new CustomScrollView(
			slivers: <Widget>[
				SliverList(
					delegate: SliverChildBuilderDelegate(
						(c, i) =>_listItem(model,i),
						childCount: model.list.length,
					),
				)
			],
		);
	}

	//列表单项
	Widget _listItem(model,index){
		var item=model.list[index];
		return Container(
			padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
			child: new PhysicalModel(
				color: Colors.white, //设置背景底色透明
				borderRadius: index==model.list.length-1?BorderRadius.only(bottomLeft:Radius.circular(10),bottomRight:Radius.circular(10) ):BorderRadius.all(Radius.circular(0)),
				clipBehavior: Clip.antiAlias, //注意这个属性
				elevation: 0,
				child:FlatButton(
					onPressed: (){
						Navigator.pushNamed(context, RouteName.specimenDetails,arguments: {'specimenStatusId':item.id});
					},
					highlightColor: Colors.transparent,
					padding: EdgeInsets.all(0),
					child: Container(
						padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
						child: Container(
							padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(34)),
							constraints: BoxConstraints(
								minHeight: ScreenUtil().setHeight(266),
							),
							decoration:BoxDecoration(
								border:Border(
									bottom:index==model.list.length-1?BorderSide.none:BorderSide(
										color: GlobalConfig.borderColor,
										width: 1.5/ScreenUtil.pixelRatio
									)
								),
							) ,
							child: new Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									new Container(
										constraints: BoxConstraints(
											maxWidth: ScreenUtil().setWidth(600)
										),
										child: new Column(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											crossAxisAlignment: CrossAxisAlignment.start,
											children: <Widget>[
												new Text(
													'${item.barCode}',
													style: TextStyle(
														fontSize: ScreenUtil().setSp(38),
														color: Color.fromRGBO(90, 90, 90, 1),
														fontWeight: FontWeight.w600
													),
												),
												SizedBox(height: ScreenUtil().setHeight(26)),
												new Text(
													'${item.name==null?'--':item.name}  ${item.sexName==null?'--':item.sexName}  ${item.inspectionUnitName==null?'--':item.inspectionUnitName}',
													maxLines: 1,
													overflow: TextOverflow.ellipsis,
													style: TextStyle(
														fontSize: ScreenUtil().setSp(30),
														color: Color.fromRGBO(90, 90, 90, 1),
													),
												),
												SizedBox(height: ScreenUtil().setHeight(28)),
												new Text(
													'申请项目：${item.applyItems==null?'--':item.applyItems}',
													maxLines: 1,
													overflow: TextOverflow.ellipsis,
													style: TextStyle(
														fontSize: ScreenUtil().setSp(28),
														color: Color.fromRGBO(170, 171,175 , 1),
														height: 1.4
													),
												)
											],
										),
									),
									new Column(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										crossAxisAlignment: CrossAxisAlignment.end,
										children: <Widget>[
											new Text(
												'${item.statusName}',//已分发 Color.fromRGBO(3, 227,235 , 1)，检测中 Color.fromRGBO(255, 144,4,1)，待提交 Color.fromRGBO(255, 101,61, 1)，已审核Color.fromRGBO(3, 227,235 , 1)，待核收Color.fromRGBO(0, 155,255 , 1)
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
														switch (item.status) {
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
											SizedBox(height: ScreenUtil().setHeight(26)),
											new Text(
												'${item.recordTime==null?'--':item.recordTime.substring(0,10)}',
												style: TextStyle(
													fontSize: ScreenUtil().setSp(34),
													color: Color.fromRGBO(90, 90, 90, 1),
												),
											),
										],
									)
								],
							)
						),
					),
				),
			)
		);
	}

	//筛选条件item
	Widget _deressItem({String title,Function selectTap,Widget widget}){
		return Column(
			children: <Widget>[
				Container(
					width: ScreenUtil().setWidth(920),
					height: ScreenUtil().setHeight(136),
					decoration:BoxDecoration(
						border:Border(
							bottom:BorderSide(
								color: GlobalConfig.borderColor,
								width: 1.5/ScreenUtil.pixelRatio
							)
						),
					) ,
					child: FlatButton(
						// color: Colors.red,
						padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(20)),
						onPressed: (){
							selectTap();
						},
						highlightColor: Colors.transparent,
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: <Widget>[
								Text(
									title,
									style: TextStyle(
										fontSize: ScreenUtil().setSp(44),
										color: Color.fromRGBO(90, 90, 90, 1),
									),
								),
								new Image.asset(
									ImageHelper.wrapAssets('mine_rarrow.png'),
									width: ScreenUtil().setHeight(40),
									height: ScreenUtil().setHeight(40),
								),	
							],
						),
					)
					// ),
				),
				Container(
					width: ScreenUtil().setWidth(920),
					padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
					constraints: BoxConstraints(
						minHeight: ScreenUtil().setHeight(136)
					),
					decoration:BoxDecoration(
						border:Border(
							bottom:BorderSide(
								color: GlobalConfig.borderColor,
								width: 1.5/ScreenUtil.pixelRatio
							)
						),
					) ,
					child:widget
				)
			],
		);
	}

	//头部搜索栏
	Widget _searchTitle(model,context){
		return Column(
			children: <Widget>[
				Container(
					width: ScreenUtil.screenWidth,
					height:ScreenUtil().setHeight(210) ,
					padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
					child: new Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							new Expanded(
								child: new PhysicalModel(
									color: Colors.white, //设置背景底色透明
									borderRadius: BorderRadius.all(Radius.circular(10)),
									clipBehavior: Clip.antiAlias, //注意这个属性
									elevation: 0.2,
									child: new Container(
										width: ScreenUtil().setWidth(810),
										height: ScreenUtil().setHeight(110),
										child: new TextField(
											style: TextStyle(
												fontSize: ScreenUtil().setSp(42),
												color: Color.fromRGBO(0, 117, 255, 1)
											),
											controller: _inputSearchController,
											textInputAction:TextInputAction.search,
											decoration: InputDecoration(
												hintText: '请搜索条码号、医院、项目、姓名',
												hintStyle: TextStyle(
													fontSize: ScreenUtil().setSp(42),
													color: Color.fromRGBO(190, 190, 190, 1),
												),
												border: InputBorder.none,
												focusedBorder:InputBorder.none,
												enabledBorder:InputBorder.none,
												prefixIcon: Icon(
													Icons.search,
													size: ScreenUtil().setWidth(60),
													color: Color.fromRGBO(203, 203, 203, 1),					
												),
											),
											onChanged: (v){
												model.inputParam=v.toString();
											},
											onSubmitted: (v){
												model.inputParam=v.toString();
												model.initData();
											},
										),
									)
								),
							),
							new Container(
								width: ScreenUtil().setWidth(140),
								height: ScreenUtil().setHeight(110),
								margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
								child: new FlatButton(
									padding: EdgeInsets.all(0),
									highlightColor: Colors.transparent,
									onPressed: (){
										tempDialog=yyCustomDialog(
											width: ScreenUtil().setWidth(940),
											widget:Container(
												height: ScreenUtil().setHeight(1060),
												child:StatefulBuilder(builder: (context, state) {
													return Column(
														children: <Widget>[
															Expanded(
																child: SingleChildScrollView(
																	child: Column(
																		children: <Widget>[
																			_deressItem(
																				title: '送检单位',
																				selectTap: (){
																					Navigator.pushNamed(context, RouteName.selectCompany).then((value) {
																						//print('接收到的单位返回值：'+value.toString());
																						var tempMap=jsonDecode(value.toString());
																						if(value==null||model.inspectionIds.contains(tempMap['custId']))return;
																						_companyNameArray.add(tempMap['custName']);
																						model.inspectionIds.add(tempMap['custId']);
																					});
																				},
																				widget:Wrap(
																					spacing:ScreenUtil().setWidth(20),
																					runSpacing: ScreenUtil().setHeight(20),
																					children: ((){
																						List<Widget> tempList=[];
																						tempList.clear();
																						for(var i=0,len=_companyNameArray.length;i<len;i++){
																							var x=_companyNameArray[i];
																							tempList.add(
																								singleProgect(
																									x.toString(),
																									key: ObjectKey('index$i'),
																									delTap: (){
																										var curIndex=tempList.indexWhere((e)=>(e.key.toString()==ObjectKey('index$i').toString()));
																										model.inspectionIds.removeAt(curIndex);
																										_companyNameArray.removeAt(curIndex);
																										setState(() {
																											_companyNameArray=_companyNameArray;
																										});
																										state(() {
																											_companyNameArray=_companyNameArray;
																										});
																									}
																								),
																							);
																						}
																						return tempList;
																					})()
																				),
																			),
																			_deressItem(
																				title: '录单日期',
																				selectTap: (){
																					showPickerDateRange(context,(sEime,eTime){
																						if(DateTime.parse(eTime).isBefore(DateTime.parse(sEime))){
																							showMsgToast('开始时间不能大于结束时间！');
																							return;
																						}
																						model.createTime=sEime.toString();
																						model.endTime=eTime.toString();
																						_seTimg=model.createTime+' ~ '+model.endTime;
																						state((){
																							_seTimg=_seTimg;
																						});
																						//print(sEime+'--'+eTime);
																					});
																				},
																				widget:Row(
																					mainAxisAlignment: MainAxisAlignment.spaceBetween,
																					children: <Widget>[
																						Text(
																							'$_seTimg',
																							style: TextStyle(
																								fontSize: ScreenUtil().setSp(44),
																								color: Color.fromRGBO(90, 90, 90, 1),
																							),
																						),
																						Offstage(
																							offstage: _seTimg=='',
																							child: Container(
																								width: ScreenUtil().setWidth(80),
																								height: ScreenUtil().setWidth(80),
																								child: new FlatButton(				
																									padding: EdgeInsets.all(0),
																									onPressed: () {
																										model.createTime='';
																										model.endTime='';
																										state((){
																											_seTimg='';
																										});
																									},
																									child: new Image.asset(
																										ImageHelper.wrapAssets('record_del.png'),
																										width: ScreenUtil().setHeight(50),
																										height: ScreenUtil().setHeight(50),
																									)
																								),
																							),
																						)
																					],
																				)
																			),
																			_deressItem(
																				title: '申请项目',
																				selectTap: (){
																					Navigator.pushNamed(context, RouteName.selectItem,arguments: {'hasSelectItem':_hasSelectItem}).then((value) {
																						//print('接收到的项目返回值：'+value.toString());
																						model.itemIds.clear();
																						_itemNameArray.clear();
																						_hasSelectItem=value;
																						for(var x in jsonDecode(value.toString())){
																							if(model.itemIds.contains(x['id']))continue;
																							model.itemIds.add(x['id']);
																							_itemNameArray.add(x['itemName']);
																						}
																						setState(() {
																							_itemNameArray=_itemNameArray;
																						});
																						state(() {
																							_itemNameArray=_itemNameArray;
																						});
																					});
																				},
																				widget:Wrap(
																					spacing:ScreenUtil().setWidth(20),
																					runSpacing: ScreenUtil().setHeight(20),
																					children: ((){
																						List<Widget> tempList=[];
																						tempList.clear();
																						for(var i=0,len=_itemNameArray.length;i<len;i++){
																							var x=_itemNameArray[i];
																							tempList.add(
																								singleProgect(
																									x.toString(),
																									key: ObjectKey('index$i'),
																									delTap: (){
																										var curIndex=tempList.indexWhere((e)=>(e.key.toString()==ObjectKey('index$i').toString()));
																										model.itemIds.removeAt(curIndex);
																										_itemNameArray.removeAt(curIndex);
																										_hasSelectItem.removeAt(curIndex);
																										setState(() {
																											_itemNameArray=_itemNameArray;
																										});
																										state(() {
																											_itemNameArray=_itemNameArray;
																										});
																									}
																								),
																							);
																						}
																						return tempList;
																					})()
																				),
																			),
																		],
																	),
																),
															),
															new Container(
																padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
																child: gradualButton('确定',onTap: (){
																	_inputSearchController.text='';
																	model.inputParam='';
																	model.initData();
																	dialogDismiss(tempDialog);
																}),
															)
														],
													);
												})
											)
										);
									},
									child: new Image.asset(
										ImageHelper.wrapAssets('record_sx.png'),
										width: ScreenUtil().setWidth(80),
										height: ScreenUtil().setWidth(80)
									),
								),
							)
						],
					),
				),
				listTitleDecoration(
					colors: [Color.fromRGBO(91, 168, 252, 1),Color.fromRGBO(56, 111, 252, 1)],
					widget: FlatButton(
						onPressed: (){
							tempDialog=yyCustomDialog(
								width: ScreenUtil().setWidth(940),
								widget:Container(
									child:StatefulBuilder(builder: (context, state) {
										return Column(
											children: <Widget>[
												Container(
													width: ScreenUtil().setWidth(920),
													padding: EdgeInsets.only(top: ScreenUtil().setHeight(30),bottom: ScreenUtil().setHeight(30),left: ScreenUtil().setHeight(30)),
													decoration:BoxDecoration(
														border:Border(
															bottom:BorderSide(
																color: GlobalConfig.borderColor,
																width: 1.5/ScreenUtil.pixelRatio
															)
														),
													) ,
													child: Text(
														'排序选择',
														style: TextStyle(
															fontSize: ScreenUtil().setSp(44),
															color: Color.fromRGBO(90, 90, 90, 1),
														),
													),
												),
												_selectlistItem(0,state,model),
												_selectlistItem(1,state,model),
												_selectlistItem(2,state,model)
											]
										);
									})	
								)
							);	
						},
						highlightColor: Colors.transparent,
						padding: EdgeInsets.all(0),
						child: Row(
							children: <Widget>[
								Text(
									_selectListData[_selectCurrentIndex].toString(),
									style: TextStyle(
										fontSize: ScreenUtil().setSp(44),
										color: Color.fromRGBO(90, 90, 91, 1)
									),
								),
								SizedBox(width: ScreenUtil().setWidth(16),),
								Image.asset(
									ImageHelper.wrapAssets('record_down.png'),
									width:ScreenUtil().setWidth(40),
									height:ScreenUtil().setWidth(40),
								)
							],
						),
					)
				)
			],
		);
	}

	//列表单项
	Widget _selectlistItem(index,state,model){
		return Container(
			child: new PhysicalModel(
				color: Colors.white, //设置背景底色透明
				borderRadius:BorderRadius.all(Radius.circular(0)),
				clipBehavior: Clip.antiAlias, //注意这个属性
				elevation: 0,
				child: Container(
					padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
					decoration: BoxDecoration(
						color: Colors.white,
					),
					child: Container(
						constraints: BoxConstraints(
							minHeight: ScreenUtil().setHeight(120),
						),
						decoration:BoxDecoration(
							border:Border(
								bottom:BorderSide(
									color: GlobalConfig.borderColor,
									width:index==2?0:1.5/ScreenUtil.pixelRatio
								)
							),
						) ,
						child: new FlatButton(
							padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(4)),
							onPressed: (){
								_selectCurrentIndex=index;
								setState(() {
									_selectCurrentIndex=_selectCurrentIndex;
								});
								state((){
									_selectCurrentIndex=_selectCurrentIndex;
								});
								switch (_selectCurrentIndex) {
								  	case 0:
										model.applyDate=true;
										model.specimenStatusName=false;
										model.inspection=false;
										break;
									case 1:
										model.applyDate=false;
										model.specimenStatusName=true;
										model.inspection=false;
										break;
									case 2:
										model.applyDate=false;
										model.specimenStatusName=false;
										model.inspection=true;
										break;		
								  default:
								}
								model.initData();
								dialogDismiss(tempDialog);
							},
							child: new Row(
								children: <Widget>[
									new Expanded(
										child: new Text(
											_selectListData[index].toString(),
											textAlign: TextAlign.center,
											style:TextStyle(
												fontSize: ScreenUtil().setSp(38),
												color: Color.fromRGBO(90, 90, 90, 1),
											)
										),
									),
									new Container(
										width: ScreenUtil().setWidth(80),
										height: ScreenUtil().setWidth(80),
										margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
										child: Image.asset(
											ImageHelper.wrapAssets(index==_selectCurrentIndex?'record_sg.png':'record_so.png'),
											fit: BoxFit.fitWidth,
										),
									)
								],
							),
						)
					),
				),
			)
		);
	}
}
