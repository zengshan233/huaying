import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';

class EventManagerViewModel extends ViewStateRefreshListModel {
  BuildContext context;
  EventManagerViewModel({this.context}) {
    YYDialog.init(context);
  }

  List<EventFeedback> _pendingList = [];

  List<EventFeedback> _doneList = [];

  /// 查询信息
  List<EventFeedback> _searchList = [];

  /// 详情页数据 / 搜索选中的数据
  EventFeedback _eventFeedback;

  /// 回复列表
  List<EventReply> _replyList = [];

  /// 详情页图片
  List<EventImage> _imageList = [];

  ///处理中
  List<EventFeedback> get pendingList => _pendingList;

  ///已处理
  List<EventFeedback> get doneList => _doneList;

  EventFeedback get eventFeedback => _eventFeedback;

  List<EventReply> get replyList => _replyList;

  List<EventImage> get imageList => _imageList;

  /// 搜索结果
  List<EventFeedback> get searchList => _searchList;

  /// 搜索内容
  String keyword;

  ///处理状态
  int handleStatus;

  var yyDialog;

  int getTotal(int index) {
    if (index == 0) {
      return list.length;
    } else if (index == 1)
      return _pendingList.length;
    else
      return _doneList.length;
  }

  /// 搜索
  Future searchData(String search) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      var response =
          await Repository.fetchEventFeedbackList(0, keyword: search);
      if (response != null) {
        _searchList = response;
      }
      setIdle();
      dialogDismiss(yyDialog);
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
    }
  }

  /// 选择搜索中的结果内容
  Future getSelectFeedbackDetail(int index) async {}

  /// 反馈信息详情查询
  Future getEventFeedbackDetail(String id) async {
    Future.microtask(() {
      yyDialog = yyProgressDialogNoBody();
    });
    setBusy();
    try {
      _eventFeedback = await Repository.fetchEventFeedbackDetail(id);
      _replyList = await Repository.fetchEventReplyList(id);
      _imageList = await Repository.fetchEventImageList(id);
      setIdle();
      dialogDismiss(yyDialog);
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
    }
  }

  /// 删除反馈图片
  Future deleteImage(String id, String updateAt) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      await Repository.fetchDeleteEventImage(id, updateAt);
      setIdle();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
      return false;
    }
  }

  /// 新增反馈图片
  Future addImage(EventImage image) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      await Repository.fetchAddEventImage(image.toJson());
      setIdle();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
      return false;
    }
  }

  /// 刷新反馈图片列表
  Future fetchEventImageList(String id) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      _imageList = await Repository.fetchEventImageList(id);
      setIdle();
      dialogDismiss(yyDialog);
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
    }
  }

  /// 提交反馈信息
  Future submitFeedback(EventFeedback feedback) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      await Repository.fetchAddEventFeedback(feedback.toJson());
      setIdle();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
      return false;
    }
  }

  /// 新增回复内容
  Future submitFeedbackReply(EventReply reply) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      await Repository.fetchAddEventReply(reply.toJson());
      setIdle();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      showErrorMessage(context);
      return false;
    }
  }

  @override
  Future<List> loadData({int pageNum, bool showLoading = false}) async {
    try {
      var response = await Repository.fetchEventFeedbackList(pageNum,
          keyword: keyword, handleStatus: handleStatus);
      // // 过滤数据
      // if (response != null) {
      //   /// 状态为待处理，已回复的数据
      //   _pendingList = response.where((item) {
      //     return item.handleStatus != EventStatus.Done.index;
      //   }).toList();

      //   /// 状态为已处理
      //   _doneList = response.where((item) {
      //     return item.handleStatus == EventStatus.Done.index;
      //   }).toList();
      // }
      return response == null ? [] : response;
    } catch (e, s) {
      setError(e, s);
      showErrorMessage(context);
      return [];
    }
  }
}
