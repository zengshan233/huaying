class SpecimentBox {
  String dcId;
  String orgId;
  String lineId;
  String lineName;
  String lineCodeNo;
  String boxNo;
  String recordId;
  String recordName;
  String id;
  String createAt;
  String updateAt;

  SpecimentBox(
      {this.dcId,
      this.orgId,
      this.lineId,
      this.lineName,
      this.lineCodeNo,
      this.boxNo,
      this.recordId,
      this.recordName,
      this.id,
      this.createAt,
      this.updateAt});

  SpecimentBox.fromJson(Map<String, dynamic> json) {
    dcId = json['dcId'];
    orgId = json['orgId'];
    lineId = json['lineId'];
    lineName = json['lineName'];
    lineCodeNo = json['lineCodeNo'];
    boxNo = json['boxNo'];
    recordId = json['recordId'];
    recordName = json['recordName'];
    id = json['id'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['lineId'] = this.lineId;
    data['lineName'] = this.lineName;
    data['lineCodeNo'] = this.lineCodeNo;
    data['boxNo'] = this.boxNo;
    data['recordId'] = this.recordId;
    data['recordName'] = this.recordName;
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
