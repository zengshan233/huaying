import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/model/login_data_model.dart';
import 'package:huayin_logistics/model/user_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class SpecimenJoinModel extends ViewStateModel {
  BuildContext context;

  String labId;
  MineModel userModel;

  TextEditingController takeCon = TextEditingController();
  TextEditingController textCon = TextEditingController();

  List<SpecimenJoinItem> _joinList;
  UserModel _userItem;

  List<SpecimenJoinItem> _boxPicked = [];
  List<SpecimenJoinItem> get joinList => _joinList;
  UserModel get userItem => _userItem;
  List<SpecimenJoinItem> get boxPicked => _boxPicked;

  set userItem(UserModel item) {
    this._userItem = item;
    notifyListeners();
  }

  set boxPicked(List<SpecimenJoinItem> items) {
    this._boxPicked = items;
    notifyListeners();
  }

  SpecimenJoinModel(BuildContext _context) {
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
      _joinList = await Repository.fetchJoinBoxes(
          labId: labId, userId: userModel.user?.user?.id);
      pop?.dismiss?.call(context);
      _joinList.isEmpty ? setEmpty() : setIdle();
      return true;
    } catch (e, s) {
      pop?.dismiss?.call(context);
      if (showLoading) {
        PopUtils.dismiss();
      }
      setIdle();
      setError(e, s);
      showErrorMessage(context);

      return false;
    }
  }

  bool checkData() {
    if (_boxPicked.isEmpty) {
      showMsgToast('标本箱不可为空！', context: context);
      return false;
    }
    if (_userItem == null) {
      showMsgToast('接收人不可为空！', context: context);
      return false;
    }
    return true;
  }

  Future submit() async {
    if (!checkData()) return;
    PopUtils.showLoading();
    Map<String, dynamic> data = {
      "joinIdsList": _boxPicked.map((e) => e.joinIds).toList(),
      "receiveId": _userItem.id,
      "receiveName": _userItem.name,
      "receiveRemark": textCon.text,
      "receiveSponsorId": userModel.user?.user?.id,
      "receiveSponsorName": userModel.user?.user?.name
    };
    try {
      await Repository.fetchBoxesJoin(labId: labId, data: data);
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
    textCon.clear();
    takeCon.clear();
    _userItem = null;
    notifyListeners();
  }
}
