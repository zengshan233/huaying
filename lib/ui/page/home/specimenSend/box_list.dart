import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/join_list_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, noDataWidget;
import 'package:huayin_logistics/view_model/home/specimen_box_join_list.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BoxList extends StatefulWidget {
  final List<String> joinids;
  final Function updateBox;
  BoxList({this.joinids, this.updateBox});
  @override
  _BoxList createState() => _BoxList();
}

class _BoxList extends State<BoxList> {
  @override
  Widget build(BuildContext context) {
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Color(0xFFf5f5f5),
          appBar: appBarWithName(context, '交接单', '外勤:', withName: true),
          body: ProviderWidget<SpecimenJoinListModel>(
              model: SpecimenJoinListModel(
                  labId: labId, ids: widget.joinids, context: context),
              onModelReady: (model) {
                model.initData();
              },
              builder: (cContext, model, child) {
                return Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(30),
                        horizontal: ScreenUtil().setWidth(150),
                      ),
                      child: Text(
                        '标本箱',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(44)),
                      ),
                    ),
                    Expanded(
                      child: new Container(
                        child: SmartRefresher(
                            controller: model.refreshController,
                            header: WaterDropHeader(),
                            onRefresh: model.refresh,
                            enablePullUp: false,
                            enablePullDown: true,
                            child: _listChild(model)),
                      ),
                    )
                  ],
                );
              })),
    );
  }

  //单项列表
  Widget _listChild(SpecimenJoinListModel model) {
    if (model.busy)
      return Container(
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
        child: Center(
            child: UnconstrainedBox(
                child: Container(
          width: ScreenUtil().setWidth(80),
          height: ScreenUtil().setWidth(80),
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
              (c, i) => _listItem(i, model),
              childCount: model.list.length,
            ),
          ),
        ],
      );
    }
  }

  //列表单项
  Widget _listItem(index, SpecimenJoinListModel model) {
    JoinItem item = model.list[index];
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(150)),
              alignment: Alignment.center,
              child:
                  Text(item.boxNo, style: TextStyle(color: Color(0xFF666666)))),
          Container(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(150),
                  top: ScreenUtil().setWidth(20),
                  bottom: ScreenUtil().setWidth(20)),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.deliveryDetail,
                      arguments: {
                        "id": item.id,
                        "updateStatus": (_boxDetail) async {
                          widget.updateBox();
                        }
                      });
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: radiusButton(
                            text: '交接单', img: "transfer_ticket.png"),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
