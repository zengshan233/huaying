class UserModel {
  String createAt;
  String dcId;
  String id;
  String name;
  String orgId;
  String updateAt;

  UserModel(
      {this.createAt,
      this.dcId,
      this.id,
      this.name,
      this.orgId,
      this.updateAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'];
    dcId = json['dcId'];
    id = json['id'];
    name = json['name'];
    orgId = json['orgId'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['orgId'] = this.orgId;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
