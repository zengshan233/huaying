import 'dart:convert';

class CodeItem {
  final String date;
  final String billno;
  final String number;
  final String status;
  CodeItem({this.date, this.billno, this.number, this.status});
}

class CodeProject {
  final String id;
  final String name;
  final String category;
  final int type;
  final String typeName;
  final String specimenTypeName;
  CodeProject(
      {this.id,
      this.name,
      this.category,
      this.type,
      this.typeName,
      this.specimenTypeName});
}

class RecordedListResponse {
  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<RecordedItem> records;

  RecordedListResponse.fromParams(
      {this.pageCount,
      this.pageNumber,
      this.pageSize,
      this.rowsCount,
      this.records});

  factory RecordedListResponse(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new RecordedListResponse.fromJson(json.decode(jsonStr))
          : new RecordedListResponse.fromJson(jsonStr);

  RecordedListResponse.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']) {
      records.add(
          recordsItem == null ? null : new RecordedItem.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}

class RecordedItem {
  String dcId;
  String orgId;
  String barcode;
  String applyId;
  String boxNo;
  String joinId;
  String recordAt;
  String recordId;
  String recordName;
  int status;
  Null transportId;
  String statusName;
  String id;
  String createAt;
  String updateAt;

  RecordedItem(
      {this.dcId,
      this.orgId,
      this.barcode,
      this.applyId,
      this.boxNo,
      this.joinId,
      this.recordAt,
      this.recordId,
      this.recordName,
      this.status,
      this.transportId,
      this.statusName,
      this.id,
      this.createAt,
      this.updateAt});

  RecordedItem.fromJson(Map<String, dynamic> json) {
    dcId = json['dcId'];
    orgId = json['orgId'];
    barcode = json['barcode'];
    applyId = json['applyId'];
    boxNo = json['boxNo'];
    joinId = json['joinId'];
    recordAt = json['recordAt'];
    recordId = json['recordId'];
    recordName = json['recordName'];
    status = json['status'];
    transportId = json['transportId'];
    statusName = json['statusName'];
    id = json['id'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['barcode'] = this.barcode;
    data['applyId'] = this.applyId;
    data['boxNo'] = this.boxNo;
    data['joinId'] = this.joinId;
    data['recordAt'] = this.recordAt;
    data['recordId'] = this.recordId;
    data['recordName'] = this.recordName;
    data['status'] = this.status;
    data['transportId'] = this.transportId;
    data['statusName'] = this.statusName;
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
