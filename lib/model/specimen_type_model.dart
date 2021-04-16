class SpecimenTypeItem {
  String codeNo;
  String colorConfig;
  String createAt;
  String dcId;
  String enName;
  String enShortName;
  String fastCode;
  int featureType;
  String id;
  int isQuote;
  String liableName;
  int liableUserId;
  String name;
  String orgId;
  String outControlDisposeCode;
  String pointCode;
  String qcSummaryCode;
  String remark;
  int resultType;
  int sortOrder;
  String standardCode;
  int status;
  String typeCode;
  String updateAt;

  SpecimenTypeItem(
      {this.codeNo,
      this.colorConfig,
      this.createAt,
      this.dcId,
      this.enName,
      this.enShortName,
      this.fastCode,
      this.featureType,
      this.id,
      this.isQuote,
      this.liableName,
      this.liableUserId,
      this.name,
      this.orgId,
      this.outControlDisposeCode,
      this.pointCode,
      this.qcSummaryCode,
      this.remark,
      this.resultType,
      this.sortOrder,
      this.standardCode,
      this.status,
      this.typeCode,
      this.updateAt});

  SpecimenTypeItem.fromJson(Map<String, dynamic> json) {
    codeNo = json['codeNo'];
    colorConfig = json['colorConfig'];
    createAt = json['createAt'];
    dcId = json['dcId'];
    enName = json['enName'];
    enShortName = json['enShortName'];
    fastCode = json['fastCode'];
    featureType = json['featureType'];
    id = json['id'];
    isQuote = json['isQuote'];
    liableName = json['liableName'];
    liableUserId = json['liableUserId'];
    name = json['name'];
    orgId = json['orgId'];
    outControlDisposeCode = json['outControlDisposeCode'];
    pointCode = json['pointCode'];
    qcSummaryCode = json['qcSummaryCode'];
    remark = json['remark'];
    resultType = json['resultType'];
    sortOrder = json['sortOrder'];
    standardCode = json['standardCode'];
    status = json['status'];
    typeCode = json['typeCode'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codeNo'] = this.codeNo;
    data['colorConfig'] = this.colorConfig;
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['enName'] = this.enName;
    data['enShortName'] = this.enShortName;
    data['fastCode'] = this.fastCode;
    data['featureType'] = this.featureType;
    data['id'] = this.id;
    data['isQuote'] = this.isQuote;
    data['liableName'] = this.liableName;
    data['liableUserId'] = this.liableUserId;
    data['name'] = this.name;
    data['orgId'] = this.orgId;
    data['outControlDisposeCode'] = this.outControlDisposeCode;
    data['pointCode'] = this.pointCode;
    data['qcSummaryCode'] = this.qcSummaryCode;
    data['remark'] = this.remark;
    data['resultType'] = this.resultType;
    data['sortOrder'] = this.sortOrder;
    data['standardCode'] = this.standardCode;
    data['status'] = this.status;
    data['typeCode'] = this.typeCode;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
