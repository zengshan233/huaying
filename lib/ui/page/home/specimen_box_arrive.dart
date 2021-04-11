import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarComon, listTitleDecoration, noDataWidget, showMsgToast;
import 'package:huayin_logistics/view_model/home/specimen_box_arrive_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SpecimenBoxArrive extends StatefulWidget {
  @override
  _SpecimenBoxArrive createState() => _SpecimenBoxArrive();
}

class _SpecimenBoxArrive extends State<SpecimenBoxArrive> {
  @override
  void initState() {
    super.initState();
  }

  int _activeIndex = -1;

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    var userInfo = Provider.of<MineModel>(context, listen: false).user?.user;
    return ProviderWidget<SpecimenBoxArriveModel>(
        model: SpecimenBoxArriveModel(
            context: context, deliveryDriverId: userInfo.id),
        onModelReady: (model) {
          model.initData();
        },
        builder: (cContext, model, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
                backgroundColor: Color.fromRGBO(242, 243, 249, 1),
                appBar: appBarComon(context, text: '标本箱送达'),
                body: new Column(
                  children: <Widget>[
                    _searchTitle(model),
                    Offstage(
                      offstage: model.list.length > 0,
                      child: Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(200)),
                        child: noDataWidget(text: '请扫描或输入标本箱编号获取信息'),
                      ),
                    ),
                    new Expanded(
                      child: Offstage(
                          offstage: model.list.length <= 0,
                          child: SmartRefresher(
                            controller: model.refreshController,
                            header: WaterDropHeader(),
                            onRefresh: model.refresh,
                            onLoading: model.loadMore,
                            enablePullUp: true,
                            child: _listChild(model),
                          )),
                    )
                  ],
                )),
          );
        });
  }

  //单项列表
  Widget _listChild(model) {
    return new CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (c, i) => _listItem(model, i),
            childCount: model.list.length,
          ),
        )
      ],
    );
  }

  //列表单项
  Widget _listItem(model, index) {
    var item = model.list[index];
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: new PhysicalModel(
          color: Colors.white, //设置背景底色透明
          borderRadius: index == model.list.length - 1
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))
              : BorderRadius.all(Radius.circular(0)),
          clipBehavior: Clip.antiAlias, //注意这个属性
          elevation: 0,
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
            decoration: BoxDecoration(
              color: _activeIndex == index
                  ? Color.fromRGBO(56, 219, 254, 0.1)
                  : Colors.white,
            ),
            child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(34)),
                constraints: BoxConstraints(
                  minHeight: ScreenUtil().setHeight(266),
                ),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: index == model.list.length - 1
                          ? BorderSide.none
                          : BorderSide(
                              color: GlobalConfig.borderColor,
                              width: 1.5 / ScreenUtil.pixelRatio)),
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      constraints:
                          BoxConstraints(maxWidth: ScreenUtil().setWidth(600)),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            '标本箱编号：${item.boxNo}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: Color.fromRGBO(90, 90, 90, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(26)),
                          new Text(
                            '发出时间：${item.senderTime == null ? '--' : item.senderTime.substring(0, 19)}',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color.fromRGBO(90, 90, 90, 1),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(28)),
                          new Text(
                            '所属线路：${item.logisticsLine}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                color: Color.fromRGBO(170, 171, 175, 1),
                                height: 1.4),
                          )
                        ],
                      ),
                    ),
                    new Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                        child: new PhysicalModel(
                          color: Colors.white, //设置背景底色透明
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          clipBehavior: Clip.antiAlias, //注意这个属性
                          elevation: 0,
                          child: Container(
                              width: ScreenUtil().setWidth(190),
                              height: ScreenUtil().setHeight(72),
                              decoration: BoxDecoration(
                                  gradient: RadialGradient(colors: [
                                Color.fromRGBO(42, 192, 255, 1),
                                Color.fromRGBO(21, 145, 241, 1)
                              ], center: Alignment.topLeft, radius: 1)),
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  var userInfo = Provider.of<MineModel>(context,
                                          listen: false)
                                      .user
                                      ?.user;
                                  model.specimenArriveOperate(
                                      item.id,
                                      item.updateAt,
                                      userInfo.phoneNumber,
                                      userInfo.id,
                                      userInfo.name, () {
                                    model.list.removeAt(index);
                                    showMsgToast('送达成功！', context: context);
                                  });
                                },
                                child: new Text('送达',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(38),
                                        color: Colors.white,
                                        letterSpacing: 1)),
                              )),
                        ))
                  ],
                )),
          ),
        ));
  }

  //查询标本箱
  void specimenArriveInquiryByBoxNo(model, {String boxNo}) {
    model.specimenArriveInquiryByBoxNoData(boxNo).then((res) {
      if (res != null) {
        int existIndex = model.list.indexWhere((_element) =>
            (_element.boxNo == boxNo)); //返回第一个满足条件的元素的index  不存在则返回-1
        // print('存在情况');
        // print(existIndex);
        if (existIndex < 0) {
          model.list.insert(0, res);
        } else {
          model.list
            ..removeAt(existIndex)
            ..insert(0, res);
        }
        setState(() {
          _activeIndex = 0;
        });
      }
    });
  }

  //头部搜索栏
  Widget _searchTitle(model) {
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil().setHeight(210),
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
                            color: Color.fromRGBO(0, 117, 255, 1)),
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
                          specimenArriveInquiryByBoxNo(model, boxNo: v);
                        },
                      ),
                    )),
              ),
              new Container(
                width: ScreenUtil().setWidth(140),
                height: ScreenUtil().setHeight(110),
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: new FlatButton(
                  padding: EdgeInsets.all(0),
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    var p = new BarcodeScanner(success: (String code) {
                      //print('条形号'+code);
                      if (code == '-1') return;
                      specimenArriveInquiryByBoxNo(model, boxNo: code);
                    });
                    p.scanBarcodeNormal();
                  },
                  child: new Image.asset(
                    ImageHelper.wrapAssets('record_wscan.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
            ],
          ),
        ),
        Offstage(
          offstage: model.list.length <= 0,
          child: listTitleDecoration(title: '标本箱信息', colors: [
            Color.fromRGBO(91, 168, 252, 1),
            Color.fromRGBO(56, 111, 252, 1)
          ]),
        )
      ],
    );
  }
}
