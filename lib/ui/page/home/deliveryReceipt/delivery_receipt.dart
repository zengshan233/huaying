import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget, showMsgToast;
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/join_list_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DeliveryReceipt extends StatefulWidget {
  @override
  _DeliveryReceipt createState() => _DeliveryReceipt();
}

class _DeliveryReceipt extends State<DeliveryReceipt> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
        backgroundColor: DiyColors.background_grey,
        appBar: appBarWithName(context, '交接单', '外勤:', withName: true),
        body: ProviderWidget<JoinListModel>(
            model: JoinListModel(),
            onModelReady: (model) {
              model.initData();
            },
            builder: (cContext, model, child) {
              return Column(
                children: <Widget>[
                  buildTip(),
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
            }));
  }

  //单项列表
  Widget _listChild(JoinListModel model) {
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

  Widget buildTip() {
    return Container(
      color: Color(0xFFdfeafc),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(30),
          horizontal: ScreenUtil().setWidth(50)),
      child: Row(
        children: <Widget>[
          Image(
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              image: new AssetImage(ImageHelper.wrapAssets("notice.png")),
              fit: BoxFit.fill),
          Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
              child: Text('点击可查看标本箱详情',
                  style: TextStyle(color: DiyColors.heavy_blue)))
        ],
      ),
    );
  }

  Widget buildItem(JoinListItem item) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteName.deliveryDetail, arguments: {
            "id": item.id,
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
                    Text(item.recordDate.substring(0, 10)),
                    Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        child: Row(children: [
                          Text(item.boxNo),
                          GestureDetector(
                            onTap: () {
                              if (item.signForRemark == null) {
                                showMsgToast('暂无备注');
                                return;
                              }
                              PopUtils.showTip(
                                  title: '签收备注',
                                  message: item.signForRemark,
                                  confirmText: '知道了');
                            },
                            child: Image(
                                width: ScreenUtil().setWidth(60),
                                image: new AssetImage(
                                    ImageHelper.wrapAssets("record_warn.png")),
                                fit: BoxFit.fill),
                          )
                        ]))
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                          vertical: ScreenUtil().setWidth(15)),
                      decoration: BoxDecoration(
                          color: item.confirmStatus == 1
                              ? Colors.white
                              : Color(0xFFd6e6ff),
                          border: Border.all(
                              width: item.confirmStatus == 1 ? 1 : 0,
                              color: Color(0xFFf0f0f0)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      alignment: Alignment.center,
                      child: Text(
                        item.confirmStatus == 1 ? '已确认' : '未确认',
                        style: TextStyle(
                            color: item.confirmStatus == 1
                                ? Color(0xFFcccccc)
                                : DiyColors.heavy_blue),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(40),
                          right: ScreenUtil().setWidth(40)),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20),
                          vertical: ScreenUtil().setWidth(15)),
                      decoration: BoxDecoration(
                          color: item.signForStatus == 1
                              ? Colors.white
                              : Color(0xFFd6e6ff),
                          border: Border.all(
                              width: item.signForStatus == 1 ? 1 : 0,
                              color: Color(0xFFf0f0f0)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      alignment: Alignment.center,
                      child: Text(
                        item.signForStatus == 1 ? '已签收' : '未签收',
                        style: TextStyle(
                            color: item.signForStatus == 1
                                ? Color(0xFFcccccc)
                                : DiyColors.heavy_blue),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
