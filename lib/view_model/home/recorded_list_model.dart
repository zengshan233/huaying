import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/model/recorded_code_model.dart';

class RecordedListModel extends ViewStateRefreshListModel {
  String date;
  String barcode;
  String status;
  String labId;
  String recordId;

  RecordedListModel(
      {this.date = "",
      this.barcode = "",
      this.labId,
      this.recordId,
      this.status = '1'});

  @override
  Future<List<RecordedItem>> loadData({int pageNum}) async {
    bool isSearch = barcode.isNotEmpty || date.isNotEmpty;
    var response;
    if (isSearch) {
      RecordedItem item = await Repository.fetchRecordedBarcode(
          labId: labId,
          barCode: barcode,
          recordId: recordId,
          status: status,
          recordAt: date);
      response = [item];
    } else {
      response = await Repository.fetchRecordedBarcodeList(
        labId: labId,
        recordId: recordId,
        status: status,
      );
    }
    return response == null ? [] : response;
  }
}
