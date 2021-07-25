import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/model/recorded_code_model.dart';

class RecordedListModel extends ViewStateRefreshListModel {
  String startAt;
  String endAt;
  String barcode;
  String status;
  String labId;
  String recordId;
  BuildContext context;
  RecordedListModel(
      {this.startAt = "",
      this.endAt = "",
      this.barcode = "",
      this.labId,
      this.recordId,
      this.context,
      this.status = '0'});

  @override
  Future<List<RecordedItem>> loadData({int pageNum}) async {
    List<RecordedItem> response;
    try {
      response = await Repository.fetchRecordedBarcodeList(
          labId: labId,
          barCode: barcode,
          recordId: recordId,
          status: status,
          startAt: '$startAt 00:00:00.000',
          endAt: '$endAt 23:59:59.000');
    } catch (e, s) {
      setError(e, s, errState: false);
      showErrorMessage(context);
      return [];
    }
    return response == null ? [] : response;
  }
}
