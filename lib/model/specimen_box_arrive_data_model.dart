import 'dart:convert' show json;

class SpecimenboxArriveDataModel {
  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<SpecimenboxArriveItem> records;

  SpecimenboxArriveDataModel.fromParams(
      {this.pageCount,
      this.pageNumber,
      this.pageSize,
      this.rowsCount,
      this.records});

  factory SpecimenboxArriveDataModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new SpecimenboxArriveDataModel.fromJson(json.decode(jsonStr))
          : new SpecimenboxArriveDataModel.fromJson(jsonStr);

  SpecimenboxArriveDataModel.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']) {
      records.add(recordsItem == null
          ? null
          : new SpecimenboxArriveItem.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}

class SpecimenboxArriveItem {
  String boxNo;
  int boxType;
  String carNumber;
  String combinedBoxAt;
  String combinedBoxUserId;
  String combinedBoxUserName;
  String createAt;
  String dcId;
  String deliveredAt;
  String deliveredId;
  String deliveredName;
  String estimateArriveAt;
  String estimateArriveSiteId;
  String estimateArriveSiteName;
  bool hasIce;
  String id;
  String lineId;
  String lineName;
  String orderNo;
  String orgId;
  String pickUpAt;
  String pickUpId;
  String pickUpName;
  String pickUpRemark;
  String receiveAt;
  String receiveId;
  String receiveName;
  String receiveRemark;
  String receiveSponseAt;
  String receiveSponsorId;
  String receiveSponsorName;
  int receiveStatus;
  String sendSiteId;
  String sendSiteName;
  String senderAt;
  String senderId;
  String senderName;
  String signForAt;
  String signatoryId;
  String signatoryName;
  int status;
  String statusName;
  String timeoutConfirmAt;
  String timeoutConfirmId;
  String timeoutConfirmName;
  String timeoutConfirmRemark;
  int timeoutStatus;
  String transportNo;
  String updateAt;

  SpecimenboxArriveItem(
      {this.boxNo,
      this.boxType,
      this.carNumber,
      this.combinedBoxAt,
      this.combinedBoxUserId,
      this.combinedBoxUserName,
      this.createAt,
      this.dcId,
      this.deliveredAt,
      this.deliveredId,
      this.deliveredName,
      this.estimateArriveAt,
      this.estimateArriveSiteId,
      this.estimateArriveSiteName,
      this.hasIce,
      this.id,
      this.lineId,
      this.lineName,
      this.orderNo,
      this.orgId,
      this.pickUpAt,
      this.pickUpId,
      this.pickUpName,
      this.pickUpRemark,
      this.receiveAt,
      this.receiveId,
      this.receiveName,
      this.receiveRemark,
      this.receiveSponseAt,
      this.receiveSponsorId,
      this.receiveSponsorName,
      this.receiveStatus,
      this.sendSiteId,
      this.sendSiteName,
      this.senderAt,
      this.senderId,
      this.senderName,
      this.signForAt,
      this.signatoryId,
      this.signatoryName,
      this.status,
      this.statusName,
      this.timeoutConfirmAt,
      this.timeoutConfirmId,
      this.timeoutConfirmName,
      this.timeoutConfirmRemark,
      this.timeoutStatus,
      this.transportNo,
      this.updateAt});

  SpecimenboxArriveItem.fromJson(Map<String, dynamic> json) {
    boxNo = json['boxNo'];
    boxType = json['boxType'];
    carNumber = json['carNumber'];
    combinedBoxAt = json['combinedBoxAt'];
    combinedBoxUserId = json['combinedBoxUserId'];
    combinedBoxUserName = json['combinedBoxUserName'];
    createAt = json['createAt'];
    dcId = json['dcId'];
    deliveredAt = json['deliveredAt'];
    deliveredId = json['deliveredId'];
    deliveredName = json['deliveredName'];
    estimateArriveAt = json['estimateArriveAt'];
    estimateArriveSiteId = json['estimateArriveSiteId'];
    estimateArriveSiteName = json['estimateArriveSiteName'];
    hasIce = json['hasIce'];
    id = json['id'];
    lineId = json['lineId'];
    lineName = json['lineName'];
    orderNo = json['orderNo'];
    orgId = json['orgId'];
    pickUpAt = json['pickUpAt'];
    pickUpId = json['pickUpId'];
    pickUpName = json['pickUpName'];
    pickUpRemark = json['pickUpRemark'];
    receiveAt = json['receiveAt'];
    receiveId = json['receiveId'];
    receiveName = json['receiveName'];
    receiveRemark = json['receiveRemark'];
    receiveSponseAt = json['receiveSponseAt'];
    receiveSponsorId = json['receiveSponsorId'];
    receiveSponsorName = json['receiveSponsorName'];
    receiveStatus = json['receiveStatus'];
    sendSiteId = json['sendSiteId'];
    sendSiteName = json['sendSiteName'];
    senderAt = json['senderAt'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    signForAt = json['signForAt'];
    signatoryId = json['signatoryId'];
    signatoryName = json['signatoryName'];
    status = json['status'];
    statusName = json['statusName'];
    timeoutConfirmAt = json['timeoutConfirmAt'];
    timeoutConfirmId = json['timeoutConfirmId'];
    timeoutConfirmName = json['timeoutConfirmName'];
    timeoutConfirmRemark = json['timeoutConfirmRemark'];
    timeoutStatus = json['timeoutStatus'];
    transportNo = json['transportNo'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boxNo'] = this.boxNo;
    data['boxType'] = this.boxType;
    data['carNumber'] = this.carNumber;
    data['combinedBoxAt'] = this.combinedBoxAt;
    data['combinedBoxUserId'] = this.combinedBoxUserId;
    data['combinedBoxUserName'] = this.combinedBoxUserName;
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['deliveredAt'] = this.deliveredAt;
    data['deliveredId'] = this.deliveredId;
    data['deliveredName'] = this.deliveredName;
    data['estimateArriveAt'] = this.estimateArriveAt;
    data['estimateArriveSiteId'] = this.estimateArriveSiteId;
    data['estimateArriveSiteName'] = this.estimateArriveSiteName;
    data['hasIce'] = this.hasIce;
    data['id'] = this.id;
    data['lineId'] = this.lineId;
    data['lineName'] = this.lineName;
    data['orderNo'] = this.orderNo;
    data['orgId'] = this.orgId;
    data['pickUpAt'] = this.pickUpAt;
    data['pickUpId'] = this.pickUpId;
    data['pickUpName'] = this.pickUpName;
    data['pickUpRemark'] = this.pickUpRemark;
    data['receiveAt'] = this.receiveAt;
    data['receiveId'] = this.receiveId;
    data['receiveName'] = this.receiveName;
    data['receiveRemark'] = this.receiveRemark;
    data['receiveSponseAt'] = this.receiveSponseAt;
    data['receiveSponsorId'] = this.receiveSponsorId;
    data['receiveSponsorName'] = this.receiveSponsorName;
    data['receiveStatus'] = this.receiveStatus;
    data['sendSiteId'] = this.sendSiteId;
    data['sendSiteName'] = this.sendSiteName;
    data['senderAt'] = this.senderAt;
    data['senderId'] = this.senderId;
    data['senderName'] = this.senderName;
    data['signForAt'] = this.signForAt;
    data['signatoryId'] = this.signatoryId;
    data['signatoryName'] = this.signatoryName;
    data['status'] = this.status;
    data['statusName'] = this.statusName;
    data['timeoutConfirmAt'] = this.timeoutConfirmAt;
    data['timeoutConfirmId'] = this.timeoutConfirmId;
    data['timeoutConfirmName'] = this.timeoutConfirmName;
    data['timeoutConfirmRemark'] = this.timeoutConfirmRemark;
    data['timeoutStatus'] = this.timeoutStatus;
    data['transportNo'] = this.transportNo;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
