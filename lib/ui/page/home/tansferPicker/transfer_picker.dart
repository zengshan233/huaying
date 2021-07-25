import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/tansferPicker/transfer_confirm.dart';
import 'package:huayin_logistics/ui/page/home/tansferPicker/transfer_item.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget;
import 'package:huayin_logistics/ui/widget/scanner.dart';
import 'package:huayin_logistics/utils/device_utils.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/transfer_picker_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransferPicker extends StatefulWidget {
  @override
  _TransferPicker createState() => _TransferPicker();
}

class _TransferPicker extends State<TransferPicker>
    with SingleTickerProviderStateMixin {
  TabController mController;

  TextEditingController sController = TextEditingController();

  List<String> tabList = ['未签收列表', '已签收列表'];

  FocusNode focusNode = new FocusNode();

  bool showDimSearch = false;

  var focusListen;

  @override
  void initState() {
    mController = TabController(
      length: tabList.length,
      vsync: this,
    );
    focusNode.addListener(() {
      //print('焦点事件'+focusNode.hasFocus.toString());
      setState(() {
        showDimSearch = focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(() {});
    mController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          focusNode.unfocus();
        },
        child: Scaffold(
          // 设置为false，防止keyboard弹出时切换tab提示overflow的警告
          resizeToAvoidBottomInset: false,
          appBar: appBarWithName(context, '中转取件', '外勤:', withName: true),
          backgroundColor: Colors.white,
          body: ProviderWidget<TransferPickerModel>(
              model: TransferPickerModel(
                context: context,
                userId: userModel.user?.user?.id,
                labId: userModel.labId,
              ),
              onModelReady: (model) {
                model.initData();
              },
              builder: (cContext, model, child) {
                return Column(
                  children: <Widget>[
                    _searchTitle(model),
                    Expanded(child: _tabViewList(model)),
                  ],
                );
              }),
        ));
  }

  //tabViewItem
  Widget _tabViewList(TransferPickerModel model) {
    return Container(
      color: Color(0xFFf5f5f5),
      child: Column(
        children: <Widget>[
          _topTabBar(model),
          _infoBar(),
          Expanded(
              child: model.busy
                  ? UnconstrainedBox(
                      child: Container(
                      width: ScreenUtil().setWidth(80),
                      height: ScreenUtil().setWidth(80),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            AlwaysStoppedAnimation(DiyColors.heavy_blue),
                      ),
                    ))
                  : _listChild(model))
        ],
      ),
    );
  }

  Widget _infoBar() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '预计到达时间',
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(38)),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '线路',
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(38)),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '标本箱号',
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(38)),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '状态',
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(38)),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '签收',
                    style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(38)),
                  ),
                ))
          ],
        ));
  }

  //右边list
  Widget _listChild(TransferPickerModel model) {
    return model.busy
        ? UnconstrainedBox(
            child: Container(
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(DiyColors.heavy_blue),
            ),
          ))
        : (model.list.length <= 0
            ? Container(
                width: ScreenUtil.screenWidth,
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(100)),
                  child: noDataWidget(text: '暂无列表数据'),
                ),
              )
            : SmartRefresher(
                controller: model.refreshController,
                header: WaterDropHeader(),
                onRefresh: model.refresh,
                onLoading: model.loadMore,
                enablePullUp: true,
                enablePullDown: true,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (c, i) => TransferItem(
                          model: model,
                          item: model.list[i],
                          update: (bool focus) {
                            if (focus) {
                              FocusScope.of(context).requestFocus(focusNode);
                            }
                            setState(() {});
                          },
                        ),
                        childCount: model.list.length,
                      ),
                    ),
                  ],
                ),
              ));
  }

  //tabBar
  Widget _topTabBar(TransferPickerModel model) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(36)), //外层adding,
              child: Container(
                height: ScreenUtil().setHeight(116),
                child: TabBar(
                  onTap: (index) {
                    focusNode.unfocus();
                    model.list.clear();
                    model.isDelivered = index == 1;
                    model.initData();
                  },
                  controller: mController,
                  labelColor: DiyColors.heavy_blue,
                  unselectedLabelColor: Color.fromRGBO(90, 90, 91, 1),
                  indicatorColor: DiyColors.heavy_blue,
                  indicatorWeight: ScreenUtil().setHeight(12),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(44),
                  ),
                  tabs: tabList.map((item) {
                    return Tab(
                      text: item,
                    );
                  }).toList(),
                ),
              )),
        )
      ],
    );
  }

  //头部搜索栏
  Widget _searchTitle(TransferPickerModel model) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil().setHeight(210),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(45)),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new PhysicalModel(
                color: Color(0xFFf5f5f5), //设置背景底色透明
                borderRadius: BorderRadius.all(Radius.circular(6)),
                clipBehavior: Clip.antiAlias, //注意这个属性
                elevation: 0.2,
                child: new Container(
                    height: ScreenUtil().setHeight(110),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          style: TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: ScreenUtil().setSp(42),
                              color: DiyColors.heavy_blue),
                          textInputAction: TextInputAction.search,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                              hintText: '请扫描或输入标本箱编号',
                              hintStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: Color.fromRGBO(190, 190, 190, 1),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              prefixIcon: InkWell(
                                  onTap: () {
                                    search(sController.text, model);
                                  },
                                  child: Icon(
                                    Icons.search,
                                    size: ScreenUtil().setWidth(60),
                                    color: Color.fromRGBO(203, 203, 203, 1),
                                  )),
                              counterText: ''),
                          maxLength: 20,
                          controller: sController,
                          onSubmitted: (v) {
                            search(v, model);
                          },
                        )),
                        Positioned(
                          right: 0,
                          height: ScreenUtil().setHeight(110),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(100),
                                height: ScreenUtil().setHeight(90),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(30)),
                                child: new FlatButton(
                                  padding: EdgeInsets.all(0),
                                  highlightColor: Colors.transparent,
                                  onPressed: () async {
                                    DeviceUtils.scanBarcode(
                                      confirm: (code) {
                                        if (code != null) {
                                          sController.text = code;
                                          search(code, model);
                                        }
                                      },
                                    );
                                  },
                                  child: new Image.asset(
                                    ImageHelper.wrapAssets('record_wscan.png'),
                                    color: Color(0xFF666666),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ))),
          ),
        ],
      ),
    );
  }

  search(String boxNo, TransferPickerModel model) {
    int idx = model.list.indexWhere((l) => l.boxNo == boxNo);
    if (idx > -1 && !model.isDelivered) {
      PopUtils.showPop(
          opacity: 0.5,
          clickDismiss: true,
          child: TransferConfirm(
            item: model.list[idx],
            model: model,
            success: () {
              model.list.removeAt(idx);
              setState(() {});
            },
          ));
    } else {
      model.boxNo = boxNo;
      model.initData();
    }
  }
}
