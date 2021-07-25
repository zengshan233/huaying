class JoinItem {
  String dcId;
  String orgId;
  String orderNo;
  String boxNo;
  String boxId;
  String recordDate;
  String recordId;
  String recordName;
  int confirmStatus;
  int signForStatus;
  int transportStatus;
  String combinedBoxUserId;
  String combinedBoxUserName;
  String combinedBoxAt;
  int combinedBoxStatus;
  int receiveStatus;
  String combinedBoxId;
  String combinedBoxNo;
  List<Items> items;
  String id;
  String createAt;
  String updateAt;

  JoinItem(
      {this.dcId,
      this.orgId,
      this.orderNo,
      this.boxNo,
      this.boxId,
      this.recordDate,
      this.recordId,
      this.recordName,
      this.confirmStatus,
      this.signForStatus,
      this.transportStatus,
      this.combinedBoxUserId,
      this.combinedBoxUserName,
      this.combinedBoxAt,
      this.combinedBoxStatus,
      this.receiveStatus,
      this.combinedBoxId,
      this.combinedBoxNo,
      this.items,
      this.id,
      this.createAt,
      this.updateAt});

  JoinItem.fromJson(Map<String, dynamic> json) {
    dcId = json['dcId'];
    orgId = json['orgId'];
    orderNo = json['orderNo'];
    boxNo = json['boxNo'];
    boxId = json['boxId'];
    recordDate = json['recordDate'];
    recordId = json['recordId'];
    recordName = json['recordName'];
    confirmStatus = json['confirmStatus'];
    signForStatus = json['signForStatus'];
    transportStatus = json['transportStatus'];
    combinedBoxUserId = json['combinedBoxUserId'];
    combinedBoxUserName = json['combinedBoxUserName'];
    combinedBoxAt = json['combinedBoxAt'];
    combinedBoxStatus = json['combinedBoxStatus'];
    receiveStatus = json['receiveStatus'];
    combinedBoxId = json['combinedBoxId'];
    combinedBoxNo = json['combinedBoxNo'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    id = json['id'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['orderNo'] = this.orderNo;
    data['boxNo'] = this.boxNo;
    data['boxId'] = this.boxId;
    data['recordDate'] = this.recordDate;
    data['recordId'] = this.recordId;
    data['recordName'] = this.recordName;
    data['confirmStatus'] = this.confirmStatus;
    data['signForStatus'] = this.signForStatus;
    data['transportStatus'] = this.transportStatus;
    data['combinedBoxUserId'] = this.combinedBoxUserId;
    data['combinedBoxUserName'] = this.combinedBoxUserName;
    data['combinedBoxAt'] = this.combinedBoxAt;
    data['combinedBoxStatus'] = this.combinedBoxStatus;
    data['receiveStatus'] = this.receiveStatus;
    data['combinedBoxId'] = this.combinedBoxId;
    data['combinedBoxNo'] = this.combinedBoxNo;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}

class Items {
  String dcId;
  String orgId;
  String joinId;
  String inspectionUnitId;
  String inspectionUnitName;
  int barcodeTotal;
  int status;
  String id;
  String createAt;
  String updateAt;

  Items(
      {this.dcId,
      this.orgId,
      this.joinId,
      this.inspectionUnitId,
      this.inspectionUnitName,
      this.barcodeTotal,
      this.status,
      this.id,
      this.createAt,
      this.updateAt});

  Items.fromJson(Map<String, dynamic> json) {
    dcId = json['dcId'];
    orgId = json['orgId'];
    joinId = json['joinId'];
    inspectionUnitId = json['inspectionUnitId'];
    inspectionUnitName = json['inspectionUnitName'];
    barcodeTotal = json['barcodeTotal'];
    status = json['status'];
    id = json['id'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['joinId'] = this.joinId;
    data['inspectionUnitId'] = this.inspectionUnitId;
    data['inspectionUnitName'] = this.inspectionUnitName;
    data['barcodeTotal'] = this.barcodeTotal;
    data['status'] = this.status;
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
