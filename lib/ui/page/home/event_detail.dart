import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarComon, gradualButton, recordCard, showMsgToast;
import 'package:huayin_logistics/ui/widget/dialog/custom_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/img_picker.dart';
import 'package:huayin_logistics/utils/date_formats.dart';
import 'package:huayin_logistics/view_model/home/event_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class EventDetail extends StatefulWidget {
  final String eventBackId;

  const EventDetail({Key key, this.eventBackId}) : super(key: key);

  @override
  _EventDetail createState() => _EventDetail();
}

class _EventDetail extends State<EventDetail> {
  EventFeedback feedback;
  TextEditingController _replyMessageController;
  @override
  void initState() {
    super.initState();
    _replyMessageController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _replyMessageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<EventManagerViewModel>(
      builder: (context, model, child) {
        return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: appBarComon(context, text: '事件详情'),
              body: new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    SizedBox(
                        width: ScreenUtil.screenWidth,
                        height: ScreenUtil().setHeight(20)),
                    _infoFrom(),
                    _backContent(),
                    _backChat(),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                  ],
                ),
              ),
            ));
      },
      model: EventManagerViewModel(context: context),
      onModelReady: (model) {
        model.getEventFeedbackDetail(widget.eventBackId);
      },
    );
  }

  //信息表单
  Widget _infoFrom() {
    return Consumer<EventManagerViewModel>(
      builder: (context, model, child) {
        var eventType = model.eventFeedback != null
            ? eventFeedbackTypeStr(
                EventFeedbackType.values[model.eventFeedback.type])
            : "--";
        var eventStatus = model.eventFeedback != null
            ? eventStatusStr(
                EventStatus.values[model.eventFeedback.handleStatus])
            : "";
        return recordCard(
            title: '基本信息',
            colors: [
              Color.fromRGBO(91, 168, 252, 1),
              Color.fromRGBO(56, 111, 252, 1)
            ],
            titleRight: new Text(
              eventStatus, //已处理Color.fromRGBO(23, 208,213,1)，处理中Color.fromRGBO(255, 155,15 , 1)
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(38),
                  color: EventStatus
                              .values[model.eventFeedback?.handleStatus ?? 0] ==
                          EventStatus.Done
                      ? Color.fromRGBO(23, 208, 213, 1)
                      : Color.fromRGBO(255, 155, 15, 1)),
            ),
            contentWidget: new Column(children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(10)),
              _infoFromItem(lable: '反馈类别：', text: eventType),
              _infoFromItem(
                  lable: '联系人员：', text: model.eventFeedback?.contactName ?? ""),
              _infoFromItem(
                  lable: '联系电话：',
                  text: model.eventFeedback?.contactPhone ?? ""),
              _infoFromItem(
                  lable: '送检单位：',
                  text: model.eventFeedback?.hospitalName ?? ""),
              _infoFromItem(
                  lable: '反馈时间：', text: model.eventFeedback?.backTime ?? ""),
              SizedBox(height: ScreenUtil().setHeight(40)),
            ]));
      },
    );
  }

  //单个表单项
  Widget _infoFromItem({String lable, String text}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
      child: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(minWidth: ScreenUtil().setWidth(230)),
            child: Text(
              lable,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(38),
                color: Color.fromRGBO(201, 201, 201, 1),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(38),
                  color: Color.fromRGBO(90, 90, 91, 0.8),
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  //反馈类容
  Widget _backContent() {
    return Consumer<EventManagerViewModel>(
      builder: (context, model, child) {
        return recordCard(
            title: '反馈内容',
            colors: [
              Color.fromRGBO(255, 175, 36, 1),
              Color.fromRGBO(252, 141, 3, 1)
            ],
            contentWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: ScreenUtil().setHeight(30)),
                Text(
                  model.eventFeedback?.backText ?? "",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(34),
                      color: Color.fromRGBO(90, 90, 91, 1),
                      height: 1.4),
                ),
                child,
                eventImgGridView(model.imageList, selectClick: () {
                  var img = new ImgPicker(maxImages: 5 - model.imageList.length, success: (res) async{
                    await res.forEach((item) async {
                      var image = EventImage.fromParams(
                      imageId: item.id,
                      imageName: item.fileName,
                      imageUrl: item.innerUrl,
                      customerBackId: this.widget.eventBackId,
                      );
                      await model.addImage(image);
                    });
                    model.fetchEventImageList(this.widget.eventBackId);
                  });
                  print('图片列表');
                  selectBottomSheet(context, img);
                }, delCallBack: (index) async {
                  var image = model.imageList[index];
                  model.deleteImage(image.id, image.updateAt).then((value) {
                    if (value) {
                      model.fetchEventImageList(this.widget.eventBackId);
                    }
                  });
                })
                // Container(
                //     margin: EdgeInsetsDirectional.only(
                //         top: ScreenUtil().setHeight(20)),
                //     height: ScreenUtil().setHeight(640),
                //     child: GridView.builder(
                //       gridDelegate:
                //           SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 3,
                //         childAspectRatio: 1,
                //         mainAxisSpacing: ScreenUtil().setHeight(20),
                //         crossAxisSpacing: 6,
                //       ),
                //       itemCount: model.imageList.length,
                //       itemBuilder: (context, index) {
                //         return Image.network(
                //           '${FlavorConfig.instance.imgPre}${model.imageList[index].imageUrl}',
                //           height: ScreenUtil().setHeight(240),
                //           fit: BoxFit.fill,
                //         );
                //       },
                //     ))
              ],
            ));
      },
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1 / ScreenUtil.pixelRatio,
                    color: GlobalConfig.borderColor))),
        child: Text(
          '照片列表',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(44),
            color: Color.fromRGBO(90, 90, 91, 1),
          ),
        ),
      ),
    );
  }

  //回复列表
  Widget _backChat() {
    return Consumer<EventManagerViewModel>(
      builder: (context, model, child) {
        var tempYYDialog;
        return recordCard(
            title: '回复列表',
            colors: [
              Color.fromRGBO(42, 192, 255, 1),
              Color.fromRGBO(21, 145, 241, 1)
            ],
            contentWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                    offstage: (model.replyList?.length ?? 0) == 0,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                          top: ScreenUtil().setHeight(20)),
                      height: ScreenUtil().setHeight(640),
                      child: new CustomScrollView(
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (c, i) => _backChatItem(
                                  people: model.replyList[i].backName,
                                  time: model.replyList[i].backTime,
                                  content: model.replyList[i].backText),
                              childCount: model.replyList?.length ?? 0,
                            ),
                          ),
                        ],
                      ),
                    )),
                Offstage(
                    offstage: EventStatus
                            .values[model.eventFeedback?.handleStatus ?? 0] ==
                        EventStatus.Done, //已处理隐藏
                    child: Column(
                      children: <Widget>[
                        //   Container(
                        //     height: ScreenUtil().setHeight(300),
                        //     margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: ScreenUtil().setHeight(20),
                        //         horizontal: ScreenUtil().setHeight(20)),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(
                        //           width: 1 / ScreenUtil.pixelRatio,
                        //           color: GlobalConfig.borderColor),
                        //       borderRadius: BorderRadius.all(Radius.circular(10)),
                        //     ),
                        //     child: TextField(
                        //       scrollPadding: EdgeInsets.all(0),
                        //       autofocus: false,
                        //       maxLines: 10,
                        //       maxLength: 200,
                        //       style: TextStyle(
                        //           fontSize: ScreenUtil().setSp(36),
                        //           color: Color.fromRGBO(90, 90, 91, 1),
                        //           height: 1.4),
                        //       decoration: InputDecoration(
                        //           enabledBorder: InputBorder.none,
                        //           focusedBorder: InputBorder.none,
                        //           contentPadding: EdgeInsets.all(0)),
                        //     ),
                        //   ),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(76),
                              top: ScreenUtil().setHeight(30)),
                          child: gradualButton('回复', onTap: () async {
                            _replyMessageController.clear();
                            tempYYDialog = yyCustomDialog(
                                width: ScreenUtil().setWidth(940),
                                widget: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          width: ScreenUtil().setWidth(920),
                                          padding: EdgeInsets.only(
                                              top: ScreenUtil().setHeight(30),
                                              bottom:
                                                  ScreenUtil().setHeight(30),
                                              left: ScreenUtil().setHeight(30)),
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: GlobalConfig
                                                        .borderColor,
                                                    width: 1.5 /
                                                        ScreenUtil.pixelRatio)),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                '回复内容',
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(44),
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
                                                    dialogDismiss(tempYYDialog);
                                                  })
                                            ],
                                          )),
                                      Container(
                                        height: ScreenUtil().setHeight(300),
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(30)),
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                ScreenUtil().setHeight(20),
                                            horizontal:
                                                ScreenUtil().setHeight(20)),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1 / ScreenUtil.pixelRatio,
                                              color: GlobalConfig.borderColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: TextField(
                                          scrollPadding: EdgeInsets.all(0),
                                          autofocus: false,
                                          maxLines: 10,
                                          maxLength: 100,
                                          controller: _replyMessageController,
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(36),
                                              color:
                                                  Color.fromRGBO(90, 90, 91, 1),
                                              height: 1.4),
                                          decoration: InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.all(0)),
                                        ),
                                      ),
                                      new Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                ScreenUtil().setHeight(40)),
                                        child: gradualButton('确定',
                                            onTap: () async {
                                          String backtext =
                                              _replyMessageController.text;
                                          if (!isRequire(backtext)) {
                                            showMsgToast('回复内容不能为空');
                                            return;
                                          }

                                          var userInfo = Provider.of<MineModel>(
                                                  context,
                                                  listen: false)
                                              .user
                                              ?.user;
                                          EventReply reply = EventReply
                                              .fromParams(
                                                  customerBackId:
                                                      model.eventFeedback?.id ??
                                                          "",
                                                  backId: userInfo.id,
                                                  backName: userInfo.name,
                                                  backText: backtext,
                                                  dcId: model.eventFeedback
                                                          ?.dcId ??
                                                      "",
                                                  orgId: model.eventFeedback
                                                          ?.orgId ??
                                                      "",
                                                  backTime: DateUtil.formatDate(
                                                      DateTime.now(),
                                                      format:
                                                          ZyDateFormats.full));
                                          await model
                                              .submitFeedbackReply(reply)
                                              .then((result) {
                                            if (result) {
                                              dialogDismiss(tempYYDialog);
                                              model.getEventFeedbackDetail(
                                                  this.widget.eventBackId);
                                            }
                                          });
                                        }),
                                      )
                                    ],
                                  ),
                                ));
                          }),
                        ),
                      ],
                    ))
              ],
            ));
      },
    );
  }

  //回复列表单项
  Widget _backChatItem(
      {String headImg, String people, String time, String content}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1 / ScreenUtil.pixelRatio,
                  color: GlobalConfig.borderColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new PhysicalModel(
            shape: BoxShape.circle,
            color: Colors.white,
            clipBehavior: Clip.antiAlias, //注意这个属性
            elevation: 4,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
            child: new Container(
              width: ScreenUtil().setWidth(130),
              height: ScreenUtil().setWidth(130),
              padding: EdgeInsets.all(4),
              child: new Image.asset(
                  ImageHelper.wrapAssets(
                      headImg == null ? 'mine_dheader.png' : headImg),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: '回复人员：',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(34),
                            color: Color.fromRGBO(210, 210, 201, 1)),
                        children: [
                          TextSpan(
                            text: people,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(34),
                                color: Color.fromRGBO(90, 90, 91, 1)),
                          )
                        ]),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(30)),
                  RichText(
                    text: TextSpan(
                        text: '回复时间：',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(34),
                            color: Color.fromRGBO(210, 210, 201, 1)),
                        children: [
                          TextSpan(
                            text: time,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(34),
                                color: Color.fromRGBO(90, 90, 91, 1)),
                          )
                        ]),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(30)),
                  Text(
                    content,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(34),
                        color: Color.fromRGBO(90, 90, 91, 1)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
