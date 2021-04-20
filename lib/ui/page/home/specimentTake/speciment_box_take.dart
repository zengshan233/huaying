import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/transfer_picker_model_data.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, listTitleDecoration, showMsgToast;
import 'package:huayin_logistics/view_model/home/transfer_picker_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './teke_item.dart';

class SpecimentBoxTake extends StatefulWidget {
  @override
  _SpecimentBoxTake createState() => _SpecimentBoxTake();
}

class _SpecimentBoxTake extends State<SpecimentBoxTake> {
  List<TransferPickerData> data = [];
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getTransportList());
  }

  getTransportList() {
    MineModel model = Provider.of<MineModel>(context, listen: false);
    String labId = '82858490362716212';
    String userId = model.user.user.id;
    Repository.fetchTransportList(labId: labId, userId: userId);
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
            backgroundColor: Colors.white,
            appBar: appBarWithName(context, '标本箱接收', '外勤:', withName: true),
            body: ProviderWidget<TransferPickerModel>(
                model: TransferPickerModel(context),
                builder: (cContext, model, child) => Column(
                      children: <Widget>[
                        _searchTitle(model),
                        Expanded(child: _listContent(model))
                        // Offstage(
                        //   offstage: data.length > 0,
                        //   child: Container(
                        //     margin: EdgeInsets.only(
                        //         top: ScreenUtil().setHeight(200)),
                        //     child: noDataWidget(text: '请扫描或输入标本箱编号获取信息'),
                        //   ),
                        // ),
                      ],
                    ))));
  }

  Widget _listContent(model) {
    return Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
        child: PhysicalModel(
          color: Color(0xFFf5f5f5), //设置背景底色透明
          clipBehavior: Clip.antiAlias, //注意这个属性
          elevation: 4,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
          child: Container(
            child: Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      tabItem(text: '未接收', index: 0, onTap: () {}),
                      tabItem(text: '已接收', index: 1, onTap: () {})
                    ],
                  ),
                ),
                model.busy
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      )
                    : new Expanded(
                        child: SmartRefresher(
                          controller: RefreshController(),
                          enablePullUp: true,
                          child: ListView.builder(
                              itemCount: 8,
                              itemBuilder: (c, i) => TakeItem(
                                    sender: '李菲菲',
                                    bill: 'B21009',
                                    line: '怀柔线',
                                    end: '东莞2站',
                                    date: '2021-03-11 09:23',
                                    remark: '箱子内有冰敷标本，请注意',
                                    confirm: true,
                                  )),
                          header: WaterDropHeader(),
                        ),
                      )
              ],
            ),
          ),
        ));
  }

  //选择按钮
  Widget tabItem({String text, int index, Function onTap}) {
    return new Expanded(
        child: new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new FlatButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          padding: EdgeInsets.all(0),
          child: new Text(text,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(44),
                  color: index == _currentTabIndex
                      ? Color(0xFF3388ff)
                      : Color(0xFF666666))),
          onPressed: () {
            if (_currentTabIndex != index) {
              setState(() {
                _currentTabIndex = index;
              });
              onTap();
            }
          },
        ),
        new Positioned(
          bottom: 0,
          child: Container(
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setWidth(12),
            decoration: BoxDecoration(
                color: index == _currentTabIndex
                    ? Color.fromRGBO(0, 146, 255, 1)
                    : Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(2))),
          ),
        )
      ],
    ));
  }

  //头部搜索栏
  Widget _searchTitle(model) {
    return Column(
      children: <Widget>[
        Container(
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
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(42),
                                  color: DiyColors.heavy_blue),
                              textInputAction: TextInputAction.search,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ], //只允许输入数字
                              decoration: InputDecoration(
                                  hintText: '请扫描或输入标本箱编号',
                                  hintStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(42),
                                    color: Color.fromRGBO(190, 190, 190, 1),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: ScreenUtil().setWidth(60),
                                    color: Color.fromRGBO(203, 203, 203, 1),
                                  ),
                                  counterText: ''),
                              maxLength: 20,
                              onSubmitted: (v) {
                                int existIndex = data.indexWhere((_element) =>
                                    (_element.boxNo ==
                                        v)); //返回第一个满足条件的元素的index  不存在则返回-1
                                if (existIndex >= 0) {
                                  showMsgToast('该标本箱已存在，请重新输入！');
                                  return;
                                }
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
                                      onPressed: () {
                                        var p = new BarcodeScanner(
                                            success: (String code) {
                                          //print('条形号'+code);
                                          if (code == '-1') return;
                                        });
                                        p.scanBarcodeNormal();
                                      },
                                      child: new Image.asset(
                                        ImageHelper.wrapAssets(
                                            'record_wscan.png'),
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
        ),
        Offstage(
          offstage: data.length <= 0,
          child: listTitleDecoration(title: '标本箱信息', colors: [
            Color.fromRGBO(91, 168, 252, 1),
            Color.fromRGBO(56, 111, 252, 1)
          ]),
        )
      ],
    );
  }
}
