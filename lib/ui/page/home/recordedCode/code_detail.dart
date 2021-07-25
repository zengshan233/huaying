import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/config/net/api.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/selectProject/item_details.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, inputPreText, simpleRecordInput;
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/ui/widget/image_swiper.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class CodeDetail extends StatefulWidget {
  final RecordedItem item;
  CodeDetail({this.item});
  @override
  _CodeDetailPage createState() => _CodeDetailPage();
}

class _CodeDetailPage extends State<CodeDetail> {
  List<String> _imageList = [];

  TextEditingController _barCodeCon = TextEditingController();
  TextEditingController _boxNoCon = TextEditingController();
  TextEditingController _dateCon = TextEditingController();
  TextEditingController _companyCon = TextEditingController();
  List<CodeProject> projects = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  Future getData() async {
    Map response;
    KumiPopupWindow pop = PopUtils.showLoading();
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    try {
      response = await Repository.fetchCodeDetail(
          applyId: widget.item.applyId, labId: labId);
    } catch (e) {
      DioError err = e;
      PopUtils.toast(err.message);
      pop.dismiss(context);
      return;
    }
    pop.dismiss(context);
    print("itemmmmmmmmmmm ${response['items']}");
    List<CodeProject> _projects = List<CodeProject>.from(response['items'].map(
        (i) => CodeProject(
            id: i['itemId'],
            category: i['sampleTestMethodName'] ?? '',
            name: i['itemName'],
            type: i['itemType'],
            typeName: i['itemTypeName'],
            specimenTypeName: i['specimenTypeName'])));

    _barCodeCon.text = response['apply']['barCode'];
    _boxNoCon.text = widget.item.boxNo;
    _dateCon.text = response['apply']['recordTime'].toString().substring(0, 19);
    _companyCon.text = response['apply']['inspectionUnitName'];
    _imageList = List<String>.from(response['images'].map((i) => i['url']));
    setState(() {
      projects = _projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '条码详情', '外勤:', withName: true),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50),
            child: Column(
              children: <Widget>[
                _baseInfo(context),
                buildProjects(),
                buildPics()
              ],
            )));
  }

  // 基本信息
  Widget _baseInfo(context) {
    return new Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
        child: new Column(
          children: <Widget>[
            simpleRecordInput(
              context,
              preText: '条码号',
              onController: _barCodeCon,
              enbleInput: false,
            ),
            simpleRecordInput(
              context,
              preText: '标本箱号',
              onController: _boxNoCon,
              enbleInput: false,
            ),
            simpleRecordInput(
              context,
              preText: '录入时间',
              onController: _dateCon,
              enbleInput: false,
            ),
            simpleRecordInput(
              context,
              preText: '送检单位',
              onController: _companyCon,
              enbleInput: false,
            ),
          ],
        ));
  }

  Widget buildProjects() {
    return Container(
        color: Colors.white,
        width: ScreenUtil.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                child: inputPreText(preText: '申请项目', isRquire: false)),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: projects
                      .map(
                        (e) => Container(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(50),
                            top: ScreenUtil().setWidth(30),
                            bottom: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(120),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      width: 1, color: Color(0xFFf0f0f0)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(40)),
                                  child: Text(
                                    e.typeName,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(40)),
                                  )),
                              InkWell(
                                onTap: () {
                                  if ([2, 3].contains(e.type)) {
                                    PopUtils.showPop(
                                        opacity: 0.5,
                                        animated: false,
                                        child: ItemDetails(
                                          id: e.id,
                                          type: e.type,
                                        ));
                                  }
                                },
                                child: Container(
                                    width: ScreenUtil().setWidth(500),
                                    child: Text(
                                      e.name,
                                      style: TextStyle(
                                          color: [2, 3].contains(e.type)
                                              ? DiyColors.heavy_blue
                                              : Color.fromRGBO(90, 90, 90, 1),
                                          fontSize: ScreenUtil().setSp(40)),
                                    )),
                              ),
                              Container(
                                  width: ScreenUtil().setWidth(310),
                                  alignment: Alignment.bottomRight,
                                  child: Text(e.specimenTypeName,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40))))
                            ],
                          ),
                        ),
                      )
                      .toList()),
            )
          ],
        ));
  }

  Widget buildPics() {
    return Container(
        width: ScreenUtil.screenWidth,
        color: Colors.white,
        margin: EdgeInsets.only(top: ScreenUtil().setWidth(50)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
              child: inputPreText(preText: '图片', isRquire: false),
            ),
            Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
                child: Wrap(
                    spacing: ScreenUtil().setWidth(60),
                    children: _imageList
                        .map(
                          (e) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ImageSwiper(
                                              index: _imageList
                                                  .indexWhere((i) => i == e),
                                              imgUrls: _imageList,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(40)),
                                width: ScreenUtil().setWidth(158),
                                height: ScreenUtil().setWidth(158),
                                color: Color(0xFFf0f2f5),
                                child: Image.network(
                                  FlavorConfig.instance.imgPre + e,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        )
                        .toList())),
          ],
        ));
  }
}
