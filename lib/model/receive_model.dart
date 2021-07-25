import 'dart:convert';

class ReceiveList {
  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<ReceiveListItem> records;

  ReceiveList.fromParams(
      {this.pageCount,
      this.pageNumber,
      this.pageSize,
      this.rowsCount,
      this.records});

  factory ReceiveList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new ReceiveList.fromJson(json.decode(jsonStr))
          : new ReceiveList.fromJson(jsonStr);

  ReceiveList.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']) {
      records.add(recordsItem == null
          ? null
          : new ReceiveListItem.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}

class ReceiveListItem {
  String boxId;
  String boxNo;
  List<String> joinIds;
  String receiveAt;
  String receiveId;
  String receiveName;
  String receiveSponseAt;
  String receiveSponseRemark;
  String receiveSponsorId;
  String receiveSponsorName;
  int receiveStatus;

  ReceiveListItem(
      {this.boxId,
      this.boxNo,
      this.joinIds,
      this.receiveAt,
      this.receiveId,
      this.receiveName,
      this.receiveSponseAt,
      this.receiveSponseRemark,
      this.receiveSponsorId,
      this.receiveSponsorName,
      this.receiveStatus});

  ReceiveListItem.fromJson(Map<String, dynamic> json) {
    boxId = json['boxId'];
    boxNo = json['boxNo'];
    joinIds = json['joinIds'].cast<String>();
    receiveAt = json['receiveAt'];
    receiveId = json['receiveId'];
    receiveName = json['receiveName'];
    receiveSponseAt = json['receiveSponseAt'];
    receiveSponseRemark = json['receiveSponseRemark'];
    receiveSponsorId = json['receiveSponsorId'];
    receiveSponsorName = json['receiveSponsorName'];
    receiveStatus = json['receiveStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boxId'] = this.boxId;
    data['boxNo'] = this.boxNo;
    data['joinIds'] = this.joinIds;
    data['receiveAt'] = this.receiveAt;
    data['receiveId'] = this.receiveId;
    data['receiveName'] = this.receiveName;
    data['receiveSponseAt'] = this.receiveSponseAt;
    data['receiveSponseRemark'] = this.receiveSponseRemark;
    data['receiveSponsorId'] = this.receiveSponsorId;
    data['receiveSponsorName'] = this.receiveSponsorName;
    data['receiveStatus'] = this.receiveStatus;
    return data;
  }
}
