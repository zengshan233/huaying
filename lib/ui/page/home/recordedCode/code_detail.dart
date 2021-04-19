import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, simpleRecordInput;
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:oktoast/oktoast.dart';

class CodeDetail extends StatefulWidget {
  final RecordedItem item;
  CodeDetail({this.item});
  @override
  _CodeDetailPage createState() => _CodeDetailPage();
}

class _CodeDetailPage extends State<CodeDetail> {
  CodeDetailItem item;
  bool loading = false;
  List<FileUploadItem> _imageList = [];

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
    setState(() {
      loading = true;
    });
    Map response;
    KumiPopupWindow pop = PopUtils.showLoading();
    try {
      response = await Repository.fetchCodeDetail(
        widget.item.applyId,
      );
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
    _boxNoCon.text = response['apply']['barCode'];
    _dateCon.text = response['apply']['barCode'];
    _companyCon.text = response['apply']['inspectionUnitName'];
    setState(() {
      loading = false;
      projects = _projects;
      item = CodeDetailItem(
          number: response['apply']['barCode'],
          specimen: response['apply']['barCode'],
          date: response['apply']['barCode'],
          end: response['apply']['inspectionUnitName'],
          projects: projects,
          pics: [
            'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3644052506,1876986348&fm=26&gp=0.jpg',
            'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3644052506,1876986348&fm=26&gp=0.jpg',
            'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3644052506,1876986348&fm=26&gp=0.jpg',
            'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3644052506,1876986348&fm=26&gp=0.jpg',
            'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3644052506,1876986348&fm=26&gp=0.jpg',
          ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '条码详情', '外勤:', withName: true),
        body: loading
            ? Container()
            : SingleChildScrollView(
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
              hintText: item.specimen,
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
                    children: item.pics
                        .map(
                          (e) => Container(
                            margin: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(40)),
                            width: ScreenUtil().setWidth(158),
                            height: ScreenUtil().setWidth(158),
                            color: Color(0xFFf0f2f5),
                            child: Image.network(e ?? ''),
                          ),
                        )
                        .toList())),
          ],
        ));
  }
}
