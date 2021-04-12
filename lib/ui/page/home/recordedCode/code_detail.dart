import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, simpleRecordInput;
import 'package:huayin_logistics/model/recorded_code_model.dart';

class CodeDetail extends StatefulWidget {
  final String id;
  CodeDetail({this.id});
  @override
  _CodeDetailPage createState() => _CodeDetailPage();
}

class _CodeDetailPage extends State<CodeDetail> {
  CodeDetailItem item;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
      item = CodeDetailItem(
          number: '20210313001',
          specimen: '002号标本箱',
          date: '2021-03-13 16:18',
          end: '广东省第二人民医院',
          projects: [
            CodeProject(category: '仪器法', name: 'IGH基因断裂检测', type: '组织样本'),
            CodeProject(category: '仪器法', name: 'IGH基因断裂检测', type: '组织样本'),
            CodeProject(category: '仪器法', name: 'IGH基因断裂检测', type: '组织样本'),
            CodeProject(category: '仪器法', name: 'IGH基因断裂检测', type: '组织样本'),
            CodeProject(category: '仪器法', name: 'IGH基因断裂检测', type: '组织样本'),
          ],
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
              hintText: item.number,
              enbleInput: false,
            ),
            simpleRecordInput(
              context,
              preText: '标本箱号',
              hintText: item.specimen,
              enbleInput: false,
            ),
            simpleRecordInput(
              context,
              preText: '录入时间',
              hintText: item.date,
              enbleInput: false,
            ),
            simpleRecordInput(
              context,
              preText: '送检单位',
              hintText: item.end,
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
                  children: item.projects
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
