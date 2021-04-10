import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarComon, gradualButton, listTitleDecoration, showMsgToast;
import 'package:huayin_logistics/ui/widget/dialog/custom_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/utils/date_formats.dart';
import 'package:huayin_logistics/view_model/home/event_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventManagement extends StatefulWidget {
  @override
  _EventManagement createState() => _EventManagement();
}

class _EventManagement extends State<EventManagement> {
  int _currentTabIndex = 0;

  TextEditingController _replyMessageController;
  TextEditingController _searchController;

  FocusNode focusNode = new FocusNode();

  EventManagerViewModel viewModel;

  bool showDimSearch = false;
  @override
  void initState() {
    super.initState();
    _replyMessageController = TextEditingController();
    _searchController = TextEditingController();
    focusNode.addListener(() {
      //print('焦点事件'+focusNode.hasFocus.toString());
      setState(() {
        showDimSearch = focusNode.hasFocus;
      });
    });
	viewModel = EventManagerViewModel(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    _replyMessageController.dispose();
    _searchController.dispose();
    focusNode.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          focusNode.unfocus();
        },
        child: Scaffold(
            backgroundColor: Color.fromRGBO(242, 243, 249, 1),
            appBar: appBarComon(context,
                text: '事件管理',
                rightWidget: Container(
                  width: ScreenUtil().setWidth(100),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  child: FlatButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pushNamed(context, RouteName.eventBack);
                    },
                    child:
                        Icon(Icons.add_comment, size: 26, color: Colors.white),
                  ),
                )),
            body: ProviderWidget<EventManagerViewModel>(
                model: viewModel,
                onModelReady: (model) {
                  model.initData();
                },
                builder: (context, model, child) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand, //
                          children: <Widget>[
                            _listContent(model),
                            Positioned(
                              left: 0,
                              top: 0,
                              width: ScreenUtil.screenWidthDp,
                              child: _searchTitle(context, model),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                })));
  }

  Widget _listContent(model) {
    return Container(
          margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(210),
              bottom: ScreenUtil().setHeight(20)),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              PhysicalModel(
                color: Colors.white, //设置背景底色透明
                borderRadius: BorderRadius.all(Radius.circular(10)),
                clipBehavior: Clip.antiAlias, //注意这个属性
                elevation: 4,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      listTitleDecoration(
                          customPadding: EdgeInsets.zero,
                          colors: [
                            Color.fromRGBO(91, 168, 252, 1),
                            Color.fromRGBO(56, 111, 252, 1)
                          ],
                          widget: new Expanded(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                tabItem(text: '全部', index: 0, onTap: () {}),
                                tabItem(text: '待处理', index: 1, onTap: () {}),
                                tabItem(text: '已处理', index: 2, onTap: () {})
                              ],
                            ),
                          )),
                      model.busy ? 
					  Expanded(
						  child: Center(
							  child: CircularProgressIndicator(strokeWidth: 2.0,),
						  ),
					  )
					  : new Expanded(
                        child: SmartRefresher(
                          controller: model.refreshController,
                          enablePullUp: true,
                          child: _listChild(model),
                          header: WaterDropHeader(),
                          onRefresh: model.refresh,
                          onLoading: model.loadMore,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
  }

  //单项列表
  Widget _listChild(model) {
    int count = model.getTotal(_currentTabIndex);
    print("List count:$count");
    return new CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (c, i) => Selector<EventManagerViewModel, EventFeedback>(
                    selector: (context, smodel) {
                      if (count == 0) return null;
                      if (_currentTabIndex == 0) {
                        return smodel.list[i];
                      } else if (_currentTabIndex == 1) {
                        return smodel.pendingList[i];
                      } else {
                        return smodel.doneList[i];
                      }
                    },
                    builder: (context, feedback, child) {
                      print(('No.${i + 1} rebuild'));
                      return _listItem(context, feedback, i, count, model);
                    },
                  ),
              childCount: count),
        )
      ],
    );
  }

  //列表单项
  Widget _listItem(context, feedback, index, count, model) {
    var tempYYDialog;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
        child: new PhysicalModel(
            color: Colors.white, //设置背景底色透明
            borderRadius: index == count - 1
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))
                : BorderRadius.all(Radius.circular(0)),
            clipBehavior: Clip.antiAlias, //注意这个属性
            elevation: 0,
            child: FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.eventDetail,
                    arguments: {"eventBackId": feedback.id});
              },
              highlightColor: Colors.transparent,
              padding: EdgeInsets.all(0),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(34)),
                    constraints: BoxConstraints(
                      minHeight: ScreenUtil().setHeight(266),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: index == count - 1
                              ? BorderSide.none
                              : BorderSide(
                                  color: GlobalConfig.borderColor,
                                  width: 1.5 / ScreenUtil.pixelRatio)),
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          constraints: BoxConstraints(
                              maxWidth: ScreenUtil().setWidth(600)),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                '反馈类别：${eventFeedbackTypeStr(EventFeedbackType.values[feedback.type])}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(38),
                                    color: Color.fromRGBO(90, 90, 90, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(26)),
                              new Text(
                                '${feedback.contactName} ${feedback.backTime}',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  color: Color.fromRGBO(90, 90, 90, 1),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(28)),
                              new Text(
                                '反馈内容：${feedback.backText}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                              feedback.handleStatus != 3
                                  ? '待处理'
                                  : '已处理', //处理中Color.fromRGBO(255, 155,15 , 1)
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: feedback.handleStatus != 3
                                    ? Color.fromRGBO(255, 89, 57, 1)
                                    : Color.fromRGBO(23, 208, 213, 1),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(46)),
                            new PhysicalModel(
                              color: Colors.white, //设置背景底色透明
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              clipBehavior: Clip.antiAlias, //注意这个属性
                              elevation: 0,
                              child: Container(
                                width: ScreenUtil().setWidth(190),
                                height: ScreenUtil().setHeight(72),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Color.fromRGBO(56, 218, 254, 1),
                                      Color.fromRGBO(22, 149, 242, 1)
                                    ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight)),
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    _replyMessageController.clear();
                                    tempYYDialog = yyCustomDialog(
                                        width: ScreenUtil().setWidth(940),
                                        widget: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                  width: ScreenUtil()
                                                      .setWidth(920),
                                                  padding: EdgeInsets.only(
                                                      top: ScreenUtil()
                                                          .setHeight(30),
                                                      bottom: ScreenUtil()
                                                          .setHeight(30),
                                                      left: ScreenUtil()
                                                          .setHeight(30)),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: GlobalConfig
                                                                .borderColor,
                                                            width: 1.5 /
                                                                ScreenUtil
                                                                    .pixelRatio)),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        '回复内容',
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(44),
                                                          color: Color.fromRGBO(
                                                              90, 90, 90, 1),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.grey,
                                                          ),
                                                          onPressed: () {
                                                            focusNode.unfocus();
                                                            dialogDismiss(
                                                                tempYYDialog);
                                                          })
                                                    ],
                                                  )),
                                              Container(
                                                height:
                                                    ScreenUtil().setHeight(300),
                                                margin: EdgeInsets.only(
                                                    top: ScreenUtil()
                                                        .setHeight(30)),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: ScreenUtil()
                                                        .setHeight(20),
                                                    horizontal: ScreenUtil()
                                                        .setHeight(20)),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1 /
                                                          ScreenUtil.pixelRatio,
                                                      color: GlobalConfig
                                                          .borderColor),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: TextField(
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  autofocus: false,
                                                  maxLines: 10,
                                                  maxLength: 100,
                                                  controller:
                                                      _replyMessageController,
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(36),
                                                      color: Color.fromRGBO(
                                                          90, 90, 91, 1),
                                                      height: 1.4),
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.all(0)),
                                                ),
                                              ),
                                              new Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: ScreenUtil()
                                                        .setHeight(40)),
                                                child: gradualButton('确定',
                                                    onTap: () async {
                                                  focusNode.unfocus();
                                                  String backtext =
                                                      _replyMessageController
                                                          .text;
                                                  if (!isRequire(backtext)) {
                                                    showMsgToast('回复内容不能为空');
                                                    return;
                                                  }

                                                  var userInfo =
                                                      Provider.of<MineModel>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          ?.user;
                                                  EventReply reply =
                                                      EventReply.fromParams(
                                                          customerBackId:
                                                              feedback.id,
                                                          backId: userInfo.id,
                                                          backName:
                                                              userInfo.name,
                                                          backText: backtext,
                                                          dcId: feedback.dcId,
                                                          orgId: feedback.orgId,
                                                          backTime: DateUtil.formatDate(DateTime.now(), format: ZyDateFormats.full));
                                                  await model
                                                      .submitFeedbackReply(
                                                          reply)
                                                      .then((result) {
                                                    if (result) {
                                                      dialogDismiss(
                                                          tempYYDialog);
                                                    }
                                                  });
                                                }),
                                              )
                                            ],
                                          ),
                                        ));
                                  },
                                  child: new Text('回复',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(38),
                                          color: Colors.white,
                                          letterSpacing: 1)),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            )));
  }

  //头部搜索栏
  Widget _searchTitle(context, model) {
    Timer dRequst;
    return Container(
        //   height: ScreenUtil().setHeight(700),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(60),
            vertical: ScreenUtil().setHeight(40)),
        child: new Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              width: ScreenUtil.screenWidth,
              //   padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
              child: Row(
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
                            controller: _searchController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: '搜索联系人、反馈内容',
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
                            ),
                            onSubmitted: (search) {
							  model.list.clear();
							  model.keyword = search.toString();
							  model.initData();
                            },
                            onChanged: (search) {
                              if (dRequst != null) {
                                dRequst.cancel();
                              }
                              dRequst = Timer(Duration(milliseconds: 400), () {
								model.list.clear();
								model.keyword = search.toString();
                                model.initData();
                              });
                            },
                            // onTap: () => showSearch(context: context, delegate: SearchBarDelegate(model: model)),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            // (showDimSearch && isRequire(_searchController.text))
            //     ? Positioned(
            //         top: ScreenUtil().setHeight(164),
            //         left: 0,
            //         width:
            //             ScreenUtil.screenWidthDp - ScreenUtil().setWidth(120),
            //         height: ScreenUtil().setHeight(480),
            //         child: new PhysicalModel(
            //             color: Colors.white, //设置背景底色透明
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //             clipBehavior: Clip.antiAlias, //注意这个属性
            //             elevation: 0.4,
            //             child: _searchListChild(model)))
            //     : SizedBox(),
          ],
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
                  color: Color.fromRGBO(90, 90, 91, 1))),
          onPressed: () {
            focusNode.unfocus();
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
            width: ScreenUtil().setWidth(140),
            height: ScreenUtil().setHeight(12),
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
}

// class SearchBarDelegate extends SearchDelegate<EventFeedback> {
//   EventManagerViewModel model;

//   SearchBarDelegate({this.model});

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = "";
//           model.searchData(query);
//         }, //搜索值为空
//       ),
//       IconButton(
//         icon: Icon(Icons.search),
//         onPressed: () {
//           model.searchData(query);
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         icon: AnimatedIcon(
//             icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
//         onPressed: () => close(context, null) //点击时关闭整个搜索页面
//         );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return new CustomScrollView(
//       slivers: <Widget>[
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (c, i) => _listItem(model, i),
//             childCount: model.list.length,
//           ),
//         )
//       ],
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Container();
//   }

//   Widget _listItem(model, index) {
//     EventFeedback feedback = model.searchList[index];
//     return Container(
//         padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(85)),
//         child: new PhysicalModel(
//             color: Colors.white, //设置背景底色透明
//             borderRadius: index == model.searchList.length - 1
//                 ? BorderRadius.only(
//                     bottomLeft: Radius.circular(10),
//                     bottomRight: Radius.circular(10))
//                 : BorderRadius.all(Radius.circular(0)),
//             clipBehavior: Clip.antiAlias, //注意这个属性
//             elevation: 0,
//             child: FlatButton(
//               onPressed: () {},
//               highlightColor: Colors.transparent,
//               padding: EdgeInsets.all(0),
//               child: Container(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
//                 child: Container(
//                     padding: EdgeInsets.symmetric(
//                         vertical: ScreenUtil().setHeight(34)),
//                     constraints: BoxConstraints(
//                       minHeight: ScreenUtil().setHeight(266),
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border(
//                           bottom: index == model.searchList.length - 1
//                               ? BorderSide.none
//                               : BorderSide(
//                                   color: GlobalConfig.borderColor,
//                                   width: 1.5 / ScreenUtil.pixelRatio)),
//                     ),
//                     child: new Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         new Container(
//                           constraints: BoxConstraints(
//                               maxWidth: ScreenUtil().setWidth(600)),
//                           child: new Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               new Text(
//                                 '反馈类别：${eventFeedbackTypeStr(EventFeedbackType.values[feedback.type])}',
//                                 style: TextStyle(
//                                     fontSize: ScreenUtil().setSp(38),
//                                     color: Color.fromRGBO(90, 90, 90, 1),
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               SizedBox(height: ScreenUtil().setHeight(26)),
//                               new Text(
//                                 '${feedback.contactName} ${feedback.backTime}',
//                                 style: TextStyle(
//                                   fontSize: ScreenUtil().setSp(30),
//                                   color: Color.fromRGBO(90, 90, 90, 1),
//                                 ),
//                               ),
//                               SizedBox(height: ScreenUtil().setHeight(28)),
//                               new Text(
//                                 '反馈内容：${feedback.backText}',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                     fontSize: ScreenUtil().setSp(28),
//                                     color: Color.fromRGBO(170, 171, 175, 1),
//                                     height: 1.4),
//                               )
//                             ],
//                           ),
//                         ),
//                         new Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             new Text(
//                               feedback.status != 3
//                                   ? '待处理'
//                                   : '已处理', //处理中Color.fromRGBO(255, 155,15 , 1)
//                               style: TextStyle(
//                                 fontSize: ScreenUtil().setSp(38),
//                                 color: feedback.status != 3
//                                     ? Color.fromRGBO(255, 89, 57, 1)
//                                     : Color.fromRGBO(23, 208, 213, 1),
//                               ),
//                             ),
//                             SizedBox(height: ScreenUtil().setHeight(46)),
//                           ],
//                         )
//                       ],
//                     )),
//               ),
//             )));
//   }
// }
