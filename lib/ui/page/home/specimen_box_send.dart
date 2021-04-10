import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart' show appBarComon, gradualButton, recordCard, recordInput, showMsgToast, singleProgect;
import 'package:huayin_logistics/ui/widget/dialog/custom_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/img_picker.dart';
import 'package:huayin_logistics/view_model/home/specimen_box_send_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';


class SpecimenBoxSend extends StatefulWidget {
	@override
	_SpecimenBoxSend createState() => _SpecimenBoxSend();
}

class _SpecimenBoxSend extends State<SpecimenBoxSend> {
	List _imageList=new List<FileUploadItem>();

	List _logisticsLineArray=new List<String>();

	List<Widget> _logisticsLineWidgetList=[];

	TextEditingController _specimenCodeController = TextEditingController();
	TextEditingController _specimenNumController = TextEditingController();
	
	WayModel _wayList;

	@override
	void initState() {

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
				appBar: appBarComon(context,text:'标本箱发出',),
				body:new SingleChildScrollView(
					child:ProviderWidget<SpecimenBoxSendModel>(
						model: SpecimenBoxSendModel(context),
						onModelReady:(model){
							var userInfo = Provider.of<MineModel>(context,listen: false).user?.user;
							model.specimenSendSelectWayData(userInfo.id).then((res){
								if(res!=null){
									setState(() {
									  	_wayList=res;
									});
								}
							});
						},
						builder: (cContext, model, child){
							return new Column(
								children: <Widget>[
									SizedBox(width: ScreenUtil.screenWidth,height: ScreenUtil().setHeight(20)),
									_infoFrom(),
									_applyProject(context),
									_imgListGrid(model),
									SizedBox(height: ScreenUtil().setHeight(20)),
								],
							);
						}
					)
				),
			),
		);
	}

	//信息表单
	Widget _infoFrom(){
		return 	recordCard(
			title:'基本信息',
			colors:[Color.fromRGBO(91, 168, 252, 1),Color.fromRGBO(56, 111, 252, 1)],
			contentWidget: new Column(
				children: <Widget>[
					recordInput(
						context,
						onController: _specimenCodeController,
						preText: '标本箱编号',
						hintText:'请扫描或输入标本箱编号',
						maxLength: 20,
						keyType:TextInputType.text,
						rightWidget: new Container(
							width: ScreenUtil().setWidth(100),
							child: new FlatButton(
								//color: Colors.red,
								padding: EdgeInsets.all(0),
								onPressed: (){
									var p=new BarcodeScanner(success:(String code){
										//print('条形号'+code);
										if(code=='-1')return;
										_specimenCodeController.text=code;
									});
									p.scanBarcodeNormal();
								},
								child: new Image.asset(
									ImageHelper.wrapAssets('record_scan.png'),
									width:ScreenUtil().setHeight(80),
									height: ScreenUtil().setHeight(80),
								)
								
							),
						)
					),
					recordInput(
						context,
						onController: _specimenNumController,
						preText: '标本数量',
						hintText:'请输入标本数量',
						keyType:TextInputType.number,
						maxLength: 4,
						needBorder: false
					)
				],
			)
		);
	}

	//申请项目
	Widget _applyProject(BuildContext context){
		var tempYYDialog;
		return 	recordCard(
			title:'线路设置',
			colors:[Color.fromRGBO(255, 175, 36, 1),Color.fromRGBO(252, 141, 3, 1)],
			titleRight: new Container(
				width: ScreenUtil().setWidth(100),
				child: new FlatButton(
					//color: Colors.red,
					padding: EdgeInsets.all(0),
					onPressed: (){
						tempYYDialog=yyCustomDialog(
							width: ScreenUtil().setWidth(940),
							widget:Container(
								child:Column(
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
												'路线选择',
												style: TextStyle(
													fontSize: ScreenUtil().setSp(44),
              										color: Color.fromRGBO(90, 90, 90, 1),
												),
											),
										),
										_listChild(context),
										new Container(
											padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
											child: gradualButton('确定',onTap: (){
												dialogDismiss(tempYYDialog);
												_logisticsLineWidgetList.clear();
												for(var i=0,len=_logisticsLineArray.length;i<len;i++){
													_logisticsLineWidgetList.add(
														singleProgect(
															_logisticsLineArray[i].toString(),
															key:ObjectKey('index$i'),
															delTap: (){
																var curIndex=_logisticsLineWidgetList.indexWhere((e)=>(e.key.toString()==ObjectKey('index$i').toString()));
																_logisticsLineWidgetList.removeAt(curIndex);
																_logisticsLineArray.removeAt(curIndex);
																// print(ObjectKey('index$i').toString());
																// print(_logisticsLineWidgetList);
																setState(() {
																	_logisticsLineWidgetList=_logisticsLineWidgetList;
																	_logisticsLineArray=_logisticsLineArray;
																});
															}
														)
													);
												}
												setState(() {
													_logisticsLineWidgetList=_logisticsLineWidgetList;
												});
											}),
										)
									],
								),
							)
						);
					},
					child: new Image.asset(
						ImageHelper.wrapAssets('record_add.png'),
						width:ScreenUtil().setHeight(80),
						height: ScreenUtil().setHeight(80),
					)
					
				),
			),
			contentWidget: new Container(
				padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(18)),
				constraints: BoxConstraints(
					minHeight: ScreenUtil().setHeight(290),
				),
				alignment: Alignment.topLeft,
				child: new Wrap(
					spacing:ScreenUtil().setWidth(20),
					runSpacing: ScreenUtil().setHeight(20),
					children: _logisticsLineWidgetList
				),
			)
		);	
	}

	//单项列表
	Widget _listChild(BuildContext context){
		return Container(
			height: ScreenUtil().setHeight(660),
			child: CustomScrollView(
				slivers: <Widget>[
					SliverList(
						delegate: SliverChildBuilderDelegate(
							(c, i) =>_listItem(i),
							childCount: _wayList.list.length,
						),
					),
				],
			),
		);
	}

	//列表单项
	Widget _listItem(index){
		var item=_wayList.list[index];
		return StatefulBuilder(builder: (context, state) {
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
										width: 1.5/ScreenUtil.pixelRatio
									)
								),
							) ,
							child: new FlatButton(
								padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(4)),
								onPressed: (){
									if(_logisticsLineArray.contains(item.lineName)){
										_logisticsLineArray.remove(item.lineName);
									}else{
										_logisticsLineArray.add(item.lineName);
									}
									//print(logisticsLineArray.toString());
									state(() {
										_logisticsLineArray=_logisticsLineArray;
									});
								},
								child: new Row(
									children: <Widget>[
										new Expanded(
											child: new Text(
												item.lineName.toString(),
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
												ImageHelper.wrapAssets(_logisticsLineArray.contains(item.lineName)?'record_sg.png':'record_sa.png'),
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
		});
	}

	//校验输入
	bool _checkLoginInput(){
		if(!isRequire(_specimenCodeController.text)){
			showMsgToast('标本箱编号为必填项，请维护！');
			return false;
		}
		if(!isRequire(_specimenNumController.text)){
			showMsgToast('标本数量为必填项，请维护！');
			return false;
		}
		if(_logisticsLineWidgetList.length<=0){
			showMsgToast('请选择线路！');
			return false;
		}
		return true;
	}

	//上传图片
	Widget _imgListGrid(model){
		return 	recordCard(
			title:'上传照片',
			colors:[Color.fromRGBO(42, 192, 255, 1),Color.fromRGBO(21, 145, 241, 1)],
			titleRight:new Row(
				children: <Widget>[
					new Image.asset(
						ImageHelper.wrapAssets('record_warn.png'),
						width:ScreenUtil().setHeight(44),
						height: ScreenUtil().setHeight(44),
					),
					SizedBox(width: ScreenUtil().setWidth(16)),
					new Text(
						'照片要求：最多五张',
						style: TextStyle(
							fontSize: ScreenUtil().setSp(30),
							color: Color.fromRGBO(93, 164, 255, 1)
						)
					)
				],
			),
			contentWidget: new Column(
				children: <Widget>[
					imgGridView(
						_imageList,
						selectClick:(){
							var img=new ImgPicker(	
								maxImages: 5-_imageList.length,			
								success:(res){
									_imageList.addAll(res);
									setState(()=>{
										_imageList=_imageList
									});
								}
							);
							selectBottomSheet(context,img);
						},
						delCallBack: (int index){
							//print('删除成功');
							_imageList.removeAt(index);
							setState(()=>{
								_imageList=_imageList
							});
						}
					),
					new Container(
						padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(76)),
						child: gradualButton('提交',onTap: (){
							if(!_checkLoginInput())return;
							List<Map<String,String>> tempList=[];
							
							for(var x in _imageList){
								Map<String,String> tempMap={};
								// tempMap['name']=x.fileName;
								// tempMap['url']=x.innerUrl;
								tempMap['fileID']=x.id;
								tempList.add(tempMap);
							}
							String tempStr=_logisticsLineArray.join(',');
							var userInfo = Provider.of<MineModel>(context,listen: false).user?.user;
							model.specimenSendSubmitData(
								_specimenCodeController.text,
								_specimenNumController.text,
								tempList,
								tempStr,
								userInfo.name,
								userInfo.id
							).then((val){
								if(val){
									Future.microtask((){
										var yyDialog;
										yyDialog=yyNoticeDialog(text:'提交成功');
										Future.delayed(Duration(milliseconds: 1500), (){
											dialogDismiss(yyDialog);
											_specimenCodeController.text='';
											_specimenNumController.text='';
											_logisticsLineWidgetList.clear();
											_logisticsLineArray.clear();
											_imageList.clear();
											setState(() {
											  	_logisticsLineWidgetList=_logisticsLineWidgetList;
												_imageList=_imageList;
												_logisticsLineArray=_logisticsLineArray;
											});
										});
									});
								}
							});
						}),
					)
				],
			)
		);
	}

}
