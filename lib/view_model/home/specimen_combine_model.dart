import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class SpecimenCombineModel extends ViewStateModel {
  var yyDialog;
  BuildContext context;

  String labId;
  MineModel userModel;

  TextEditingController customCon = TextEditingController();

  List<SpecimenCombinedItem> _combineList = [];

  List<SpecimenUnusedItem> _boxList = [];

  List<SpecimenCombinedItem> _combineBoxes = [];

  SpecimenUnusedItem _box;

  List<SpecimenCombinedItem> get combineList => _combineList;
  List<SpecimenUnusedItem> get boxList => _boxList;
  List<SpecimenCombinedItem> get combineBoxes => _combineBoxes;
  SpecimenUnusedItem get box => _box;

  set box(SpecimenUnusedItem item) {
    this._box = item;
    notifyListeners();
  }

  SpecimenCombineModel(BuildContext _context) {
    context = _context;
    userModel = Provider.of<MineModel>(context, listen: false);
    labId = userModel.labId;
  }

  Future<bool> getData({bool showLoading = true}) async {
    KumiPopupWindow pop;
    if (showLoading) {
      pop = PopUtils.showLoading();
      setBusy();
    }
    try {
      _combineList = await Repository.fetchCombinedBoxes(
          labId: labId, userId: userModel.user?.user?.id);
      _boxList = await Repository.fetchUnUsedBoxes(
          labId: labId, userId: userModel.user?.user?.id);
      pop?.dismiss?.call(context);
      setIdle();
      return true;
    } catch (e, s) {
      if (showLoading) {
        PopUtils.dismiss();
      }
      setIdle();
      setError(e, s);
      showErrorMessage(context);
      return false;
    }
  }

  //标本箱接收操作
  Future<bool> specimenReceiveOperateData({List<String> joinIds}) async {
    KumiPopupWindow pop = PopUtils.showLoading();
    MineModel userModel = Provider.of<MineModel>(context, listen: false);
    String labId = userModel.labId;
    try {
      await Repository.fetchSpecimenReceiveOperate(
          labId: labId, joinIds: joinIds);
      pop.dismiss(context);
      setIdle();
      return true;
    } catch (e, s) {
      pop.dismiss(context);
      setError(e, s);
      showErrorMessage(context);
      return false;
    }
  }

  void addCombineItem(SpecimenCombinedItem item) {
    if (_combineBoxes.contains(item)) {
      _combineBoxes.removeWhere((c) => c.boxNo == item.boxNo);
    } else {
      _combineBoxes.add(item);
    }
    notifyListeners();
  }

  bool checkData() {
    if (_combineBoxes == null || _combineBoxes.isEmpty) {
      showMsgToast('请选择待合标本箱！', context: context);
      return false;
    }
    if (box == null) {
      showMsgToast('请选择标本箱！', context: context);
      return false;
    }
    return true;
  }

  Future submit() async {
    if (!checkData()) return;
    List items = _combineBoxes
        .map((e) => {"boxNo": e.boxNo, "joinId": e.joinId, "boxId": e.boxId})
        .toList();
    Map<String, dynamic> data = {
      "items": items,
      "userId": userModel.user?.user?.id,
      "userName": userModel.user?.user?.name
    };
    if (box != null) {
      data.addAll({'boxId': box.id, 'boxNo': box.boxNo});
    } else {
      data['boxNo'] = customCon.text;
    }
    PopUtils.showLoading();
    try {
      await Repository.fetchBoxesCombine(data: data, labId: labId);
    } catch (e, s) {
      PopUtils.dismiss();
      setError(e, s, errState: false);
      showErrorMessage(context);
      return;
    }
    await getData(showLoading: false);
    PopUtils.dismiss();
    PopUtils.showNotice(onPop: resetData);
  }

  resetData() {
    customCon.clear();
    _combineBoxes = [];
    _box = null;
    notifyListeners();
  }
}
