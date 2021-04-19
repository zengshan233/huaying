import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';

class JoinListResponse {
  int rowsCount;
  int pageNumber;
  int pageSize;
  int pageCount;
  List<JoinListItem> records;

  JoinListResponse(
      {this.rowsCount,
      this.pageNumber,
      this.pageSize,
      this.pageCount,
      this.records});

  JoinListResponse.fromJson(Map<String, dynamic> json) {
    rowsCount = json['rowsCount'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    pageCount = json['pageCount'];
    if (json['records'] != null) {
      records = new List<JoinListItem>();
      json['records'].forEach((v) {
        records.add(new JoinListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowsCount'] = this.rowsCount;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['pageCount'] = this.pageCount;
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JoinListModel extends ViewStateRefreshListModel {
  @override
  Future<List<JoinListItem>> loadData({int pageNum}) async {
    List<JoinListItem> response;
    response = await Repository.fetchDeliveryList(
        labId: '82858490362716212', recordId: '118736914412920997');
    return response == null ? [] : response;
  }
}
