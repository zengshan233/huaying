import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, simpleRecordInput;
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:oktoast/oktoast.dart';

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
    String labId = '82858490362716212';
    try {
      response = await Repository.fetchCodeDetail(
          applyId: widget.item.applyId, labId: labId);
    } catch (e) {
      showToast(e.toString());
      pop.dismiss(context);
      return;
    }
    pop.dismiss(context);
    List<CodeProject> _projects = List<CodeProject>.from(response['items'].map(
        (i) => CodeProject(
            category: i['labName'],
            name: i['itemName'],
            type: i['specimenTypeName'])));

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: ScreenUtil.screenWidth,
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                child: Text('申请项目')),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: projects
                      .map((e) => Container(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(50),
                              top: ScreenUtil().setWidth(20),
                              bottom: ScreenUtil().setWidth(20),
                              right: ScreenUtil().setWidth(150),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 1, color: Color(0xFFf0f0f0)))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(20)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(50)),
                                    child: Text(e.name)),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(50)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(e.category),
                                        Text(e.type)
                                      ],
                                    ))
                              ],
                            ),
                          ))
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
                child: Text('图   片')),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _imageList
                        .map(
                          (e) => GestureDetector(
                              onTap: () {
                                ImagePickers.previewImage(
                                    FlavorConfig.instance.imgPre + e);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(40)),
                                width: ScreenUtil().setWidth(158),
                                height: ScreenUtil().setWidth(158),
                                color: Color(0xFFf0f2f5),
                                child: Image.network(
                                    FlavorConfig.instance.imgPre + e),
                              )),
                        )
                        .toList())),
          ],
        ));
  }
}
