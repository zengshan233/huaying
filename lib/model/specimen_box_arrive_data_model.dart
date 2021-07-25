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
  String exceptionRemark;
  List<ImageItem> receiveImages;
  List<ImageItem> sendImages;

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
      this.updateAt,
      this.exceptionRemark});

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
    exceptionRemark = json['exceptionRemark'];
    if (json['receiveImages'] != null) {
      receiveImages = new List<ImageItem>();
      json['receiveImages'].forEach((v) {
        receiveImages.add(new ImageItem.fromJson(v));
      });
    }
    if (json['sendImages'] != null) {
      sendImages = new List<ImageItem>();
      json['sendImages'].forEach((v) {
        sendImages.add(new ImageItem.fromJson(v));
      });
    }
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
    data['exceptionRemark'] = this.exceptionRemark;
    if (this.receiveImages != null) {
      data['receiveImages'] =
          this.receiveImages.map((v) => v.toJson()).toList();
    }
    if (this.sendImages != null) {
      data['sendImages'] = this.sendImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageItem {
  String relId;
  String fileId;
  String name;
  String describe;
  String url;
  String thumbnailUrl;
  String thumbnailName;
  String id;
  String dcId;
  String orgId;
  String createAt;
  String updateAt;

  ImageItem(
      {this.relId,
      this.fileId,
      this.name,
      this.describe,
      this.url,
      this.thumbnailUrl,
      this.thumbnailName,
      this.id,
      this.dcId,
      this.orgId,
      this.createAt,
      this.updateAt});

  ImageItem.fromJson(Map<String, dynamic> json) {
    json = json ?? {};
    relId = json['relId'];
    fileId = json['fileId'];
    name = json['name'];
    describe = json['describe'];
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
    thumbnailName = json['thumbnailName'];
    id = json['id'];
    dcId = json['dcId'];
    orgId = json['orgId'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relId'] = this.relId;
    data['fileId'] = this.fileId;
    data['name'] = this.name;
    data['describe'] = this.describe;
    data['url'] = this.url;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['thumbnailName'] = this.thumbnailName;
    data['id'] = this.id;
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
