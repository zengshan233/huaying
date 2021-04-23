class SiteModel {
  String dcId;
  String orgId;
  String siteName;
  int siteType;
  int status;
  String id;
  String createAt;
  String updateAt;

  SiteModel(
      {this.dcId,
      this.orgId,
      this.siteName,
      this.siteType,
      this.status,
      this.id,
      this.createAt,
      this.updateAt});

  SiteModel.fromJson(Map<String, dynamic> json) {
    dcId = json['dcId'];
    orgId = json['orgId'];
    siteName = json['siteName'];
    siteType = json['siteType'];
    status = json['status'];
    id = json['id'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['siteName'] = this.siteName;
    data['siteType'] = this.siteType;
    data['status'] = this.status;
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
