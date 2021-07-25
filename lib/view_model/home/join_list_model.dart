import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

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
  String labId;
  BuildContext context;
  JoinListModel(BuildContext _context) {
    MineModel userModel = Provider.of<MineModel>(_context, listen: false);
    labId = userModel.labId;
    context = _context;
  }

  @override
  Future<List<JoinListItem>> loadData({int pageNum}) async {
    List<JoinListItem> response;
    try {
      response = await Repository.fetchDeliveryList(
          pageNumber: pageNum, labId: labId, recordId: '118736914412920997');
    } catch (e, s) {
      setError(e, s, errState: false);
      showErrorMessage(context);
      return [];
    }
    return response == null ? [] : response;
  }
}
