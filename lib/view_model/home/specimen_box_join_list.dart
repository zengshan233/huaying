import 'package:flutter/widgets.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/join_list_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';

class SpecimenJoinListModel extends ViewStateRefreshListModel<JoinItem> {
  String labId;
  List<String> ids;
  BuildContext context;
  SpecimenJoinListModel({this.labId, this.ids, this.context});

  @override
  Future<List<JoinItem>> loadData({int pageNum}) async {
    List<JoinItem> response;
    try {
      response = await Repository.fetchJoinList(labId: labId, ids: ids);
    } catch (e, s) {
      setError(e, s, errState: false);
      showErrorMessage(context);
      return [];
    }
    return response == null ? [] : response;
  }
}
