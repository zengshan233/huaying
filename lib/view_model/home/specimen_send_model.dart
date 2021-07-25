import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/site_model.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/pop_window/kumi_popup_window.dart';
import 'package:huayin_logistics/utils/events_utils.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class SpecimenSendModel extends ViewStateModel {
  BuildContext context;

  MineModel userModel;

  List<SiteModel> _sites = [];

  SiteModel _site;
  WayModelItem _line;
  TextEditingController lineCon = TextEditingController();
  TextEditingController arriveCon = TextEditingController();
  TextEditingController arriveDateCon = TextEditingController();
  TextEditingController sendCon = TextEditingController();
  TextEditingController sendDateCon = TextEditingController();
  TextEditingController licenseCon = TextEditingController();
  TextEditingController transportNoCon = TextEditingController();
  List<SpecimenBoxItem> _boxPicked = [];

  List<SpecimenBoxItem> _boxList = [];
  WayModel _wayList;
  List<SiteModel> get sites => _sites;
  SiteModel get site => _site;
  WayModelItem get line => _line;
  List<SpecimenBoxItem> get boxPicked => _boxPicked;
  List<SpecimenBoxItem> get boxList => _boxList;
  WayModel get wayList => _wayList;

  set boxPicked(List<SpecimenBoxItem> items) {
    _boxPicked = items;
    notifyListeners();
  }

  set line(WayModelItem item) {
    _line = item;
    notifyListeners();
  }

  set site(SiteModel item) {
    _site = item;
    notifyListeners();
  }

  SpecimenSendModel(BuildContext _context) {
    context = _context;
    userModel = Provider.of<MineModel>(context, listen: false);
  }

  Future<bool> getData({bool showLoading = true}) async {
    KumiPopupWindow pop;
    if (showLoading) {
      pop = PopUtils.showLoading();
      setBusy();
    }
    try {
      await getBoxes();
      _sites = await Repository.fetchArriveSiteList(labId: userModel.labId);
      _wayList =
          await Repository.fetchSpecimenSendSelectWay(userModel.user?.user?.id);
      pop?.dismiss?.call(context);
      _boxList.isEmpty ? setEmpty() : setIdle();
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

  Future getBoxes({bool update = false}) async {
    String labId = userModel.labId;
    String userId = userModel.user?.user?.id;
    _boxList = await Repository.fetchSendBoxes(labId: labId, userId: userId);
    if (update) {
      notifyListeners();
    }
  }

  //选择路线
  Future<List<SiteModel>> specimenSendSelectSiteData(String labId) async {
    setBusy();
    try {
      List<SiteModel> response =
          await Repository.fetchArriveSiteList(labId: labId);
      //print('响应数据'+response.toString());
      setIdle();
      return response;
    } catch (e, s) {
      setError(e, s);
      return null;
    }
  }

  //选择站点
  Future<WayModel> specimenSendSelectWayData(String id) async {
    setBusy();
    try {
      var response = await Repository.fetchSpecimenSendSelectWay(id);
      //print('响应数据'+response.toString());
      setIdle();
      return response;
    } catch (e, s) {
      setError(e, s);
      return null;
    }
  }

  void addCombineItem(SpecimenBoxItem item) {
    List<String> _boxNoList = _boxPicked.map((e) => e.boxNo).toList();
    if (_boxNoList.contains(item.boxNo)) {
      _boxPicked.removeWhere((c) => c.boxNo == item.boxNo);
    } else {
      _boxPicked.add(item);
    }
    notifyListeners();
  }

  bool checkData(List<FileUploadItem> imageList) {
    if (_boxPicked.isEmpty) {
      showMsgToast('请选择标本箱！');
      return false;
    }
    if (_line == null) {
      showMsgToast('请选择线路！');
      return false;
    }
    if (arriveCon.text.isEmpty) {
      showMsgToast('请选择到达站点！');
      return false;
    }
    if (arriveDateCon.text.isEmpty) {
      showMsgToast('请选择到达时间！');
      return false;
    }
    if (sendCon.text.isEmpty) {
      showMsgToast('请输入出发站点！');
      return false;
    }
    if (sendDateCon.text.isEmpty) {
      showMsgToast('请选择出发时间！');
      return false;
    }
    if (imageList.isEmpty) {
      showMsgToast('请上传图片！');
      return false;
    }
    if (imageList.length < 2) {
      showMsgToast('请至少上传2张图片！');
      return false;
    }
    return true;
  }

  Future submit(List<FileUploadItem> imageList) async {
    if (!checkData(imageList)) return;
    PopUtils.showLoading();
    List<Map<String, String>> tempList = [];
    for (var x in imageList) {
      Map<String, String> tempMap = {};
      tempMap['fileID'] = x.id;
      tempList.add(tempMap);
    }
    List boxInfo = boxPicked
        .map((e) => {
              'boxId': e.boxId,
              'boxNo': e.boxNo,
              'hasIce': e.ice,
              'joinIds': e.joinIds
            })
        .toList();
    try {
      await Repository.fetchSpecimenSendSubmit(data: {
        "boxInfoList": boxInfo,
        "carNumber": licenseCon.text,
        "estimateArriveAt": arriveDateCon.text + ':00.000',
        "estimateArriveSiteId": _site.id,
        "estimateArriveSiteName": _site.siteName,
        "lineId": _line.id,
        "lineName": _line.lineName,
        "imageIds": imageList.map((e) => e.id).toList(),
        "sendSiteName": sendCon.text,
        "senderAt": sendDateCon.text + ':00.000',
        "senderId": userModel.user?.user?.id,
        "senderName": userModel.user?.user?.name,
        "transportNo": transportNoCon.text
      }, labId: userModel.labId);
    } catch (e, s) {
      PopUtils.dismiss();
      setError(e, s, errState: false);
      showErrorMessage(context);
      return;
    }
    await getBoxes();
    PopUtils.dismiss();
    PopUtils.showNotice(onPop: resetData);
  }

  resetData() {
    lineCon.clear();
    arriveCon.clear();
    arriveDateCon.clear();
    sendCon.clear();
    sendDateCon.clear();
    licenseCon.clear();
    transportNoCon.clear();
    boxPicked = [];
    EventBus.instance.commit(EventKeys.clearImages, {});
    notifyListeners();
  }
}
