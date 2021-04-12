import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/transfer_picker_model_data.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, listTitleDecoration, noDataWidget, showMsgToast;
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/view_model/home/transfer_picker_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class TransferPicker extends StatefulWidget {
  @override
  _TransferPicker createState() => _TransferPicker();
}

class _TransferPicker extends State<TransferPicker> {
  List<TransferPickerData> data = [];

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
            backgroundColor: Colors.white,
            appBar: appBarWithName(context, '中转取件', '外勤:', withName: true),
            body: ProviderWidget<TransferPickerModel>(
                model: TransferPickerModel(context),
                builder: (cContext, model, child) => Column(
                      children: <Widget>[
                        _searchTitle(model),
                        Offstage(
                          offstage: data.length > 0,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(200)),
                            child: noDataWidget(text: '请扫描或输入标本箱编号获取信息'),
                          ),
                        ),
                        new Expanded(
                            child: Offstage(
                          offstage: data.length <= 0,
                          child: _listChild(model, context: context),
                        )),
                      ],
                    ))));
  }

  //单项列表
  Widget _listChild(model, {BuildContext context}) {
    return new CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (c, i) => _listItem(model, index: i, context: context),
            childCount: data.length,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: ScreenUtil().setHeight(40))),
      ],
    );
  }

  //列表单项
  Widget _listItem(model, {int index, BuildContext context}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: new PhysicalModel(
          color: Colors.white, //设置背景底色透明
          borderRadius: index == data.length - 1
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
              color: Colors.white,
            ),
            child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(34)),
                constraints: BoxConstraints(
                  minHeight: ScreenUtil().setHeight(266),
                ),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: index == data.length - 1
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
                            "标本箱编号：${data[index].boxNo.toString()}",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: Color.fromRGBO(90, 90, 90, 1),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(26)),
                          new Text(
                            '发出时间：${data[index].senderTime == null ? '--' : data[index].senderTime.substring(0, 19)}',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color.fromRGBO(90, 90, 90, 1),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(28)),
                          new Text(
                            '所属线路：${data[index].logisticsLine}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                color: Color.fromRGBO(170, 171, 175, 1),
                                height: 1.4),
                          )
                        ],
                      ),
                    ),
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          data[index].statusName.toString(),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(38),
                            color: data[index].status == 1
                                ? Color.fromRGBO(3, 227, 235, 1)
                                : Color.fromRGBO(255, 141, 1, 1),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(46)),
                        Offstage(
                          offstage: (data[index].status != 1 &&
                              data[index].status != 2),
                          child: new PhysicalModel(
                            color: Colors.white, //设置背景底色透明
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            clipBehavior: Clip.antiAlias, //注意这个属性
                            elevation: 0,
                            child: Container(
                              width: ScreenUtil().setWidth(190),
                              height: ScreenUtil().setHeight(72),
                              decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                      colors: data[index].status == 1
                                          ? [
                                              Color.fromRGBO(8, 240, 155, 1),
                                              Color.fromRGBO(3, 227, 235, 1)
                                            ]
                                          : [
                                              Color.fromRGBO(255, 174, 35, 1),
                                              Color.fromRGBO(255, 141, 1, 1)
                                            ],
                                      center: Alignment.topLeft,
                                      radius: 1)),
                              child: data[index].status == 1
                                  ? FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        pickerOrCancel(model,
                                            status: '2',
                                            index: index,
                                            context: context);
                                      },
                                      child: new Text('取件',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(38),
                                              color: Colors.white,
                                              letterSpacing: 1)),
                                    )
                                  : FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        var tempDialog;
                                        tempDialog = yyAlertDialogWithDivider(
                                            tip: "确认是否取消，取消之后该标本箱状态会退为已发出！",
                                            success: () {
                                              dialogDismiss(tempDialog);
                                              pickerOrCancel(model,
                                                  status: '1',
                                                  index: index,
                                                  context: context);
                                            });
                                      },
                                      child: new Text('取消取件',
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(38),
                                            color: Colors.white,
                                          )),
                                    ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ),
        ));
  }

  //查询标本箱
  void specimenInquiry(model, {String boxNo}) {
    model.transferPickerInquiry(boxNo).then((res) {
      if (res != null) {
        int existIndex = data.indexWhere((_element) =>
            (_element.boxNo == boxNo)); //返回第一个满足条件的元素的index  不存在则返回-1
        // print('存在情况');
        // print(existIndex);
        if (existIndex < 0) {
          data.add(res);
        } else {
          data[existIndex] = res;
        }
        setState(() {
          data = data;
        });
      }
    });
  }

  //取件或取消取件操作
  void pickerOrCancel(model, {String status, int index, BuildContext context}) {
    //1取消取件 2取件
    var item = data[index];
    var userInfo = Provider.of<MineModel>(context, listen: false).user?.user;
    model
        .pickerOrCancelPicker(item.id, item.updateAt, userInfo.phoneNumber,
            userInfo.id, userInfo.name, status)
        .then((val) {
      if (val) {
        if (status == '2') {
          showMsgToast('取件成功！');
        }
        Future.delayed(Duration(milliseconds: 200), () {
          specimenInquiry(model, boxNo: item.boxNo);
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
                                specimenInquiry(model, boxNo: v);
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
                                          specimenInquiry(model, boxNo: code);
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
