import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarWithName;
import 'package:huayin_logistics/ui/widget/img_picker.dart';
import 'package:huayin_logistics/ui/widget/info_form_item.dart';
import 'package:huayin_logistics/view_model/home/event_model.dart';
import 'package:provider/provider.dart';

class ReceiptDetail extends StatefulWidget {
  final String receiptId;

  const ReceiptDetail({Key key, this.receiptId}) : super(key: key);

  @override
  _ReceiptDetail createState() => _ReceiptDetail();
}

class _ReceiptDetail extends State<ReceiptDetail> {
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
              appBar: appBarWithName(context, '单据详情', '外勤:', withName: true),
              body: new SingleChildScrollView(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _infoFrom(),
                    _backContent(),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    confirm(),
                    SizedBox(height: ScreenUtil().setHeight(80)),
                  ],
                ),
              ),
            ));
      },
      model: EventManagerViewModel(context: context),
      onModelReady: (model) {
        model.getEventFeedbackDetail(widget.receiptId);
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
          InfoFormItem(
              lable: '反馈类别',
              text: eventType,
              rightWidget: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(15),
                      vertical: ScreenUtil().setWidth(10)),
                  decoration: BoxDecoration(
                      color: Color(0xFFd6e6ff),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Text(
                    '未审核',
                    style: TextStyle(color: DiyColors.heavy_blue),
                  ))),
          InfoFormItem(
              lable: '录入时间', text: model.eventFeedback?.backTime ?? ""),
          _backContent(),
          InfoFormItem(
              lable: '标本条码', text: model.eventFeedback?.contactName ?? ""),
          InfoFormItem(
              lable: '送检单位', text: model.eventFeedback?.contactPhone ?? ""),
          InfoFormItem(
              lable: '外勤', text: model.eventFeedback?.hospitalName ?? ""),
          _projects(),
          SizedBox(height: ScreenUtil().setHeight(40)),
        ]));
      },
    );
  }

  Widget _projects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InfoFormItem(lable: '申请项目', text: ""),
        Column(
          children: List(4)
              .map(
                (e) => Container(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setWidth(20),
                      left: ScreenUtil().setWidth(150),
                      right: ScreenUtil().setWidth(250)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: GlobalConfig.borderColor, width: 1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin:
                              EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                          child: Text('基因检测',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: Color.fromRGBO(90, 90, 90, 1),
                              ))),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('仪器法',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: Color.fromRGBO(90, 90, 90, 1),
                              )),
                          Text('血清',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(38),
                                color: Color.fromRGBO(90, 90, 90, 1),
                              ))
                        ],
                      ))
                    ],
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }

  Widget _backContent() {
    return Consumer<EventManagerViewModel>(
      builder: (context, model, child) {
        return Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                child,
                eventImgGridView(model.imageList, selectClick: () {
                  var img = new ImgPicker(
                      maxImages: 5 - model.imageList.length,
                      success: (res) async {
                        await res.forEach((item) async {
                          var image = EventImage.fromParams(
                            imageId: item.id,
                            imageName: item.fileName,
                            imageUrl: item.innerUrl,
                            customerBackId: this.widget.receiptId,
                          );
                          await model.addImage(image);
                        });
                        model.fetchEventImageList(this.widget.receiptId);
                      });
                  selectBottomSheet(context, img);
                }, delCallBack: (index) async {
                  var image = model.imageList[index];
                  model.deleteImage(image.id, image.updateAt).then((value) {
                    if (value) {
                      model.fetchEventImageList(this.widget.receiptId);
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

  Widget confirm() {
    return Container(
      width: ScreenUtil.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteName.receiptConfirm,
                    arguments: {"receiptId": widget.receiptId});
              },
              child: Container(
                width: ScreenUtil().setWidth(1000),
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
                decoration: BoxDecoration(
                    color: DiyColors.heavy_blue,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                alignment: Alignment.center,
                child: Text(
                  '审  核',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
