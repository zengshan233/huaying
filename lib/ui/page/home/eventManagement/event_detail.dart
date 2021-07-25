import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName, gradualButton, showMsgToast;
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
              appBar: appBarWithName(context, '事件详情', '外勤:', withName: true),
              body: new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
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
        return Container(
            child: new Column(children: <Widget>[
          _infoFromItem(lable: '反馈类别：', text: eventType),
          _infoFromItem(
              lable: '联系人员：', text: model.eventFeedback?.contactName ?? ""),
          _infoFromItem(
              lable: '联系电话：', text: model.eventFeedback?.contactPhone ?? ""),
          _infoFromItem(
              lable: '送检单位：', text: model.eventFeedback?.hospitalName ?? ""),
          _infoFromItem(
              lable: '反馈时间：', text: model.eventFeedback?.backTime ?? ""),
          _infoFromItem(
              lable: '处理人员：', text: model.eventFeedback?.finalHandleName ?? ""),
          _infoFromItem(
              lable: '备注信息：', text: model.eventFeedback?.remark ?? ""),
          SizedBox(height: ScreenUtil().setHeight(40)),
        ]));
      },
    );
  }

  //单个表单项
  Widget _infoFromItem({String lable, String text}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(50)),
            constraints: BoxConstraints(minWidth: ScreenUtil().setWidth(230)),
            child: Text(
              lable,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(38),
                color: Color(0xFF333333),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(38),
                color: Color(0xFF717171),
              ),
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
        return Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                child,
                eventImgGridView(model.imageList, context: context,
                    selectClick: () {
                  var img = new ImgPicker(
                      maxImages: 5 - model.imageList.length,
                      success: (res) async {
                        res.forEach((item) async {
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
                  selectBottomSheet(context, img);
                }, delCallBack: (index) async {
                  var image = model.imageList[index];
                  model.deleteImage(image.id, image.updateAt).then((value) {
                    if (value) {
                      model.fetchEventImageList(this.widget.eventBackId);
                    }
                  });
                })
              ],
            ));
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(60),
            top: ScreenUtil().setWidth(20),
            bottom: ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: GlobalConfig.borderColor))),
        child: Text(
          '照片列表',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(38),
            color: Color(0xFF333333),
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
        return Container(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(10)),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '回复记录',
                    style: TextStyle(fontSize: ScreenUtil().setSp(38)),
                  ),
                ),
                Offstage(
                    offstage: (model.replyList?.length ?? 0) == 0,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                          top: ScreenUtil().setHeight(40)),
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
                        Container(
                          height: ScreenUtil().setHeight(300),
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(20),
                              horizontal: ScreenUtil().setHeight(20)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1 / ScreenUtil.pixelRatio,
                                color: GlobalConfig.borderColor),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextField(
                            scrollPadding: EdgeInsets.all(0),
                            autofocus: false,
                            maxLines: 10,
                            controller: _replyMessageController,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(36),
                                color: Color.fromRGBO(90, 90, 91, 1),
                                height: 1.4),
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: '请输入回复信息...',
                                contentPadding: EdgeInsets.all(0)),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(76),
                              top: ScreenUtil().setHeight(30)),
                          child: gradualButton('回复', gradual: false,
                              onTap: () async {
                            String backtext = _replyMessageController.text;
                            if (!isRequire(backtext)) {
                              showMsgToast('回复内容不能为空');
                              return;
                            }

                            var userInfo =
                                Provider.of<MineModel>(context, listen: false)
                                    .user
                                    ?.user;
                            EventReply reply = EventReply.fromParams(
                                customerBackId: model.eventFeedback?.id ?? "",
                                backId: userInfo.id,
                                backName: userInfo.name,
                                backText: backtext,
                                dcId: model.eventFeedback?.dcId ?? "",
                                orgId: model.eventFeedback?.orgId ?? "",
                                backTime: DateUtil.formatDate(DateTime.now(),
                                    format: ZyDateFormats.full));
                            await model
                                .submitFeedbackReply(reply)
                                .then((result) {
                              if (result) {
                                dialogDismiss(tempYYDialog);
                                _replyMessageController.clear();
                                model.getEventFeedbackDetail(
                                    this.widget.eventBackId);
                              }
                            });
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
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xFFf5f5f5)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(people,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(34),
                                  color: Color(0xFF666666))),
                          Text(time ?? '',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(34),
                                  color: Color(0xFF999999)))
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
                      child: Text(
                        content,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(34),
                            color: Color.fromRGBO(90, 90, 91, 1)),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
