import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget, radiusButton, simpleRecordInput;
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/ui/widget/scanner.dart';
import 'package:huayin_logistics/utils/device_utils.dart';
import 'package:huayin_logistics/view_model/home/recorded_list_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

class SpecimenSearch extends StatefulWidget {
  @override
  _SpecimenSearch createState() => _SpecimenSearch();
}

class _SpecimenSearch extends State<SpecimenSearch> {
  TextEditingController _dateControll = TextEditingController(); //日期
  TextEditingController _barCodeControll = TextEditingController(); //条码号
  List<CodeItem> data = [];

  String date = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    MineModel model = Provider.of<MineModel>(context);
    String labId = model.labId;
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            backgroundColor: DiyColors.background_grey,
            appBar: appBarWithName(context, '标本箱查询', '外勤:', withName: true),
            body: ProviderWidget<RecordedListModel>(
                model: RecordedListModel(
                    labId: labId,
                    recordId: model.user.user.id,
                    context: context),
                onModelReady: (model) {},
                builder: (cContext, model, child) {
                  return Column(
                    children: <Widget>[
                      _baseInfo(model),
                      Expanded(
                        child: new Container(
                          child: SmartRefresher(
                              controller: model.refreshController,
                              header: WaterDropHeader(),
                              onRefresh: model.refresh,
                              onLoading: model.loadMore,
                              enablePullUp: true,
                              enablePullDown: true,
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
            child: UnconstrainedBox(
                child: Container(
          width: ScreenUtil().setWidth(80),
          height: ScreenUtil().setWidth(80),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(DiyColors.heavy_blue),
          ),
        ))),
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
                  onTap: () async {
                    DeviceUtils.scanBarcode(
                      confirm: (code) {
                        if (code != null) {
                          _barCodeControll.text = code;
                          model.barcode = _barCodeControll.text;
                          model.initData();
                        }
                      },
                    );
                  },
                  child: radiusButton(text: '扫码', img: "scan.png")),
            ),
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
              DateTimeRangePicker(
                  startText: "起始日期",
                  endText: "截止日期",
                  doneText: "确定",
                  cancelText: "取消",
                  interval: 5,
                  initialStartTime: DateTime.now(),
                  initialEndTime: DateTime.now(),
                  mode: DateTimeRangePickerMode.date,
                  onConfirm: (start, end) {
                    String _start = start.toString().split(' ').first;
                    String _end = end.toString().split(' ').first;
                    if (_start == _end) {
                      _dateControll.text = _start;
                    } else {
                      _dateControll.text = '$_start ~ $_end';
                    }
                    model.startAt = _start.toString();
                    model.endAt = _end.toString();
                    model.initData();
                  }).showPicker(context);
            }),
          ],
        ));
  }

  Widget buildItem(RecordedItem item) {
    return Container();
  }
}
