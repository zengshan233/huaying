import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show appBarComon, gradualButton, recordCard, recordInput, showMsgToast;
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/img_picker.dart';
import 'package:huayin_logistics/view_model/home/event_model.dart';

class EventBack extends StatefulWidget {
  @override
  _EventBack createState() => _EventBack();
}

class _EventBack extends State<EventBack> {
  List _imageList = new List<FileUploadItem>();

  List<String> data = ['事件投诉', '客户反馈', '物流异常事件'];
  int _eventSelectIndex = 0;

  /// 反馈内容
  TextEditingController _backContentController;

  /// 联系人
  TextEditingController _backContactController;

  /// 联系人电话
  TextEditingController _backTelController;

  /// 医院信息
  TextEditingController _backCompanyController;

  /// 选择的医院信息
  SelectCompanyListItem _companyListItem;

  EventManagerViewModel model;

  @override
  void initState() {
    super.initState();
    _backContentController = TextEditingController();
    _backContactController = TextEditingController();
    _backTelController = TextEditingController();
    _backCompanyController = TextEditingController();
    model = EventManagerViewModel(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    _backContentController.dispose();
    _backContactController.dispose();
    _backTelController.dispose();
    _backCompanyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onTapUp: (detail) {},
      child: Scaffold(
        appBar: appBarComon(context, text: '事件反馈'),
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              SizedBox(
                  width: ScreenUtil.screenWidth,
                  height: ScreenUtil().setHeight(20)),
              _backType(),
              _backContent(),
              _backerInfo(),
              _imgListGrid(),
              SizedBox(height: ScreenUtil().setHeight(40)),
            ],
          ),
        ),
      ),
    );
  }

  //反馈类别
  Widget _backType() {
    return recordCard(
        title: '反馈类别',
        colors: [
          Color.fromRGBO(91, 168, 252, 1),
          Color.fromRGBO(56, 111, 252, 1)
        ],
        contentWidget: new Container(
          height: ScreenUtil().setHeight(460),
          child: _listChild(),
        ));
  }

  //单项列表
  Widget _listChild() {
    return new CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (c, i) => _listItem(i),
            childCount: data.length,
          ),
        ),
      ],
    );
  }

  //列表单项
  Widget _listItem(index) {
    return Container(
        child: new PhysicalModel(
      color: Colors.white, //设置背景底色透明
      borderRadius: index == data.length - 1
          ? BorderRadius.only(
              bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
          : BorderRadius.all(Radius.circular(0)),
      clipBehavior: Clip.antiAlias, //注意这个属性
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
            constraints: BoxConstraints(
              minHeight: ScreenUtil().setHeight(120),
            ),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: GlobalConfig.borderColor,
                      width: 1.5 / ScreenUtil.pixelRatio)),
            ),
            child: new FlatButton(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(4)),
              onPressed: () {
                setState(() {
                  _eventSelectIndex = index;
                });
              },
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(data[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(38),
                          color: Color.fromRGBO(90, 90, 90, 1),
                        )),
                  ),
                  new Container(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(80),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Image.asset(
                      ImageHelper.wrapAssets(index == this._eventSelectIndex
                          ? 'record_sg.png'
                          : 'record_sa.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
            )),
      ),
    ));
  }

  //反馈内容
  Widget _backContent() {
    return recordCard(
      title: '反馈内容',
      colors: [Color.fromRGBO(255, 175, 36, 1), Color.fromRGBO(252, 141, 3, 1)],
      contentWidget: Container(
        height: ScreenUtil().setHeight(300),
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
        padding: EdgeInsets.only(
            left: ScreenUtil().setHeight(20),
            right: ScreenUtil().setHeight(20),
            bottom: ScreenUtil().setHeight(30)),
        child: TextField(
          scrollPadding: EdgeInsets.all(0),
          autofocus: false,
          maxLines: 6,
          maxLength: 500,
          controller: _backContentController,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(36),
              color: Color.fromRGBO(90, 90, 91, 1),
              height: 1.4),
          decoration: InputDecoration(
              hintText: '请详情描述您遇到的问题，以便尽快为您合适处理。',
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(0)),
        ),
      ),
    );
  }

  //反馈人信息
  Widget _backerInfo() {
    return recordCard(
        title: '反馈人信息',
        colors: [
          Color.fromRGBO(91, 168, 252, 1),
          Color.fromRGBO(56, 111, 252, 1)
        ],
        contentWidget: new Column(
          children: <Widget>[
            recordInput(context,
                preText: '联系人',
                hintText: '请输入联系人',
                maxLength: 10,
                onController: _backContactController),
            recordInput(context,
                preText: '联系电话',
                hintText: '请输入联系电话',
                keyType: TextInputType.phone,
                maxLength: 12,
                onController: _backTelController),
            recordInput(context,
                preText: '送检单位',
                hintText: '请选择所属单位',
                enbleInput: false,
                needBorder: false,
                rightWidget: new Image.asset(
                  ImageHelper.wrapAssets('mine_rarrow.png'),
                  width: ScreenUtil().setHeight(40),
                  height: ScreenUtil().setHeight(40),
                ),
                onController: _backCompanyController, onTap: () {
              Navigator.pushNamed(context, RouteName.selectCompany)
                  .then((value) {
                if (value != null) {
                  setState(() {
                    this._companyListItem = value;
                  });
                  _backCompanyController.text =
                      (value as SelectCompanyListItem).custName;
                }
              });
            }),
          ],
        ));
  }

  //上传图片
  Widget _imgListGrid() {
    return recordCard(
        title: '上传照片',
        colors: [
          Color.fromRGBO(42, 192, 255, 1),
          Color.fromRGBO(21, 145, 241, 1)
        ],
        titleRight: new Row(
          children: <Widget>[
            new Image.asset(
              ImageHelper.wrapAssets('record_warn.png'),
              width: ScreenUtil().setHeight(44),
              height: ScreenUtil().setHeight(44),
            ),
            SizedBox(width: ScreenUtil().setWidth(16)),
            new Text('照片要求：最多五张',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: Color.fromRGBO(93, 164, 255, 1)))
          ],
        ),
        contentWidget: new Column(
          children: <Widget>[
            imgGridView(_imageList, selectClick: () {
              var img = new ImgPicker(maxImages: 5 - _imageList.length, success: (res) {
                print('图片列表');
                setState(() => {_imageList = res});
              });
              selectBottomSheet(context, img);
            }, delCallBack: (int index) {
              print('删除成功');
              _imageList.removeAt(index);
              setState(() => {_imageList = _imageList});
            }),
            new Container(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(76)),
              child: gradualButton('提交', onTap: () async {
                if (_checkEventInput()) {
                  EventFeedback feedback = EventFeedback.fromParams();
                  feedback.backText = _backContentController.text;
                  feedback.contactName = _backContactController.text;
                  feedback.contactPhone = _backTelController.text;
                  if (_eventSelectIndex == 0) {
                    feedback.type = EventFeedbackType.Complaint.index;
                  } else if (_eventSelectIndex == 1) {
                    feedback.type = EventFeedbackType.Message.index;
                  } else {
                    feedback.type = EventFeedbackType.Anomaly.index;
                  }
                  feedback.hospitalId = _companyListItem.custId;
                  feedback.hospitalName = _companyListItem.custName;
                  feedback.handleStatus = EventStatus.Untreated.index;

                  if (_imageList.isNotEmpty) {
                    List<EventImage> images = [];
                    _imageList.forEach((item) {
                      EventImage image =
                          EventImage.fromParams(imageId: item.id, imageName: item.fileName, imageUrl: item.innerUrl,);
                      images.add(image);
                    });
                    feedback.images = images;
                  }
                  await model.submitFeedback(feedback).then((result) {
                    if (result) {
                      ///提交成功后
                      showMsgToast('提交成功');
                      clear();
                    }
                  });
                }
              }),
            )
          ],
        ));
  }

  bool _checkEventInput() {
    if (!isRequire(this._backContentController.text)) {
      showMsgToast("请填写反馈内容，反馈内容不能为空");
      return false;
    }

    if (!isRequire(this._backContactController.text)) {
      showMsgToast("请填写联系人，联系人不能为空");
      return false;
    }

    if (!isRequire(this._backTelController.text)) {
      showMsgToast("请填写联系电话，联系电话不能为空");
      return false;
    }

    if (!(isTel(this._backTelController.text) ||
        isPhone(this._backTelController.text))) {
      debugPrint(this._backTelController.text);
      showMsgToast("请正确填写联系电话");
      return false;
    }

    if (!isRequire(this._backCompanyController.text)) {
      showMsgToast("请选择送检单位，送检单位不能为空");
      return false;
    }
    return true;
  }

  void clear() {
    _backCompanyController.clear();
    _backContactController.clear();
    _backContentController.clear();
    _backTelController.clear();
    setState(() {
      _companyListItem = null;
      _eventSelectIndex = 0;
      _imageList = new List<FileUploadItem>();
    });
  }
}
