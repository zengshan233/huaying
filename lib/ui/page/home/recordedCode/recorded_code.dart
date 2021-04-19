import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget, radiusButton, simpleRecordInput;
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/view_model/home/recorded_list_model.dart';
import 'package:huayin_logistics/ui/widget/datePicker/flutter_cupertino_date_picker.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'code_detail.dart';

class RecordedCode extends StatefulWidget {
  @override
  _RecordedCode createState() => _RecordedCode();
}

class _RecordedCode extends State<RecordedCode> {
  TextEditingController _dateControll = TextEditingController(); //日期
  TextEditingController _barCodeControll = TextEditingController(); //条码号
  List<CodeItem> data = [];

  String date = '';

  List taps = [
    {'name': '未发出', 'status': '0'},
    {'name': '已发出', 'status': '1'},
    {'name': '已签收', 'status': '2'}
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    MineModel model = Provider.of<MineModel>(context);
    String labId = '82858490362716212';
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            backgroundColor: DiyColors.background_grey,
            appBar: appBarWithName(context, '已录条码', '外勤:', withName: true),
            body: ProviderWidget<RecordedListModel>(
                model: RecordedListModel(
                  labId: labId,
                  recordId: model.user.user.id,
                ),
                onModelReady: (model) {
                  model.initData();
                },
                builder: (cContext, model, child) {
                  return Column(
                    children: <Widget>[
                      _baseInfo(model),
                      buildTaps(model),
                      Expanded(
                        child: new Container(
                          child: SmartRefresher(
                              controller: model.refreshController,
                              header: WaterDropHeader(),
                              onRefresh: model.refresh,
                              onLoading: model.loadMore,
                              enablePullUp: true,
                              enablePullDown: false,
                              child: _listChild(model)),
                        ),
                      )
                    ],
                  );
                })));
  }

  //单项列表
  Widget _listChild(RecordedListModel model) {
    if (model.busy)
      return Container(
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        ),
      );
    if (model.list.isEmpty)
      return Container(
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(100)),
          child: noDataWidget(text: '暂无列表数据'),
        ),
      );
    else {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (c, i) => buildItem(model.list[i]),
              childCount: model.list.length,
            ),
          ),
        ],
      );
    }
  }

  // 基本信息
  Widget _baseInfo(RecordedListModel model) {
    return new Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
        child: new Column(
          children: <Widget>[
            simpleRecordInput(context,
                preText: '日    期',
                hintText: '请选择日期',
                enbleInput: false,
                onController: _dateControll,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ), onTap: () {
              DatePicker.showDatePicker(context,
                  locale: DateTimePickerLocale.zh_cn,
                  onConfirm: (DateTime dateTime, List<int> days) async {
                _dateControll.text = dateTime.toString().split(' ').first;
                model.date = dateTime.toString();
                model.initData();
              });
            }),
            simpleRecordInput(
              context,
              preText: '条码号',
              hintText: '请扫描或输入条码号',
              keyType: TextInputType.visiblePassword,
              onController: _barCodeControll,
              maxLength: 12,
              onSubmitted: (value) {
                model.barcode = _barCodeControll.text;
                model.initData();
              },
              rightWidget: InkWell(
                  onTap: () {
                    var p = new BarcodeScanner(success: (String code) {
                      //print('条形码'+code);
                      if (code == '-1') return;
                      _barCodeControll.text = code;
                    });
                    p.scanBarcodeNormal();
                  },
                  child: radiusButton(text: '扫码', img: "scan.png")),
            ),
          ],
        ));
  }

  Widget buildTaps(RecordedListModel model) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: taps.map((e) {
          bool isPicked = e['status'] == model.status;
          return InkWell(
              onTap: () {
                model.status = e['status'];
                model.initData();
              },
              child: Container(
                child: Column(children: [
                  Text(
                    e['name'],
                    style: TextStyle(
                        color: isPicked
                            ? DiyColors.heavy_blue
                            : Color(0xFFcccccc)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                    height: 2,
                    width: ScreenUtil().setWidth(100),
                    color: isPicked ? DiyColors.heavy_blue : Colors.transparent,
                  )
                ]),
              ));
        }).toList(),
      ),
    );
  }

  Widget buildItem(RecordedItem item) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteName.recordedCodeDetail,
              arguments: {
                "item": item,
              });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(item.recordAt.split(' ').first),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                      child: Text(item.boxNo),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        item.barcode,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(20),
                          right: ScreenUtil().setWidth(10)),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                          vertical: ScreenUtil().setWidth(15)),
                      alignment: Alignment.center,
                      child: Text(item.statusName),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                      alignment: Alignment.center,
                      child: new Image(
                          color: Colors.black,
                          width: ScreenUtil().setWidth(60),
                          height: ScreenUtil().setWidth(60),
                          image: new AssetImage(
                              ImageHelper.wrapAssets("right_more.png")),
                          fit: BoxFit.fill),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
