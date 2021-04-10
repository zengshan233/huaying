import 'package:json_annotation/json_annotation.dart';

part 'login_data_model.g.dart';

@JsonSerializable()
class LoginDataModel {
  User user;
  @JsonKey(nullable: true)
  List<int> orgIdList;
  @JsonKey(nullable: true)
  List<String> roleList;
  @JsonKey(nullable: true)
  List<String> resourceList;
  String token;
  String accountName;

  LoginDataModel(
      {this.accountName,
      this.user,
      this.orgIdList,
      this.roleList,
      this.resourceList,
      this.token});

  factory LoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$LoginDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataModelToJson(this);
}

@JsonSerializable()
class User {
  String name;
  @JsonKey(nullable: true)
  String orgName;
  @JsonKey(nullable: true)
  String shortName;
  @JsonKey(nullable: true)
  String organizId;
  @JsonKey(nullable: true)
  int type;
  @JsonKey(nullable: true)
  int gender;
  @JsonKey(nullable: true)
  String positionName;
  @JsonKey(nullable: true)
  String positionId;
  @JsonKey(nullable: true)
  String remark;
  int status;
  @JsonKey(nullable: true)
  String birthday;
  @JsonKey(nullable: true)
  int age;
  @JsonKey(nullable: true)
  String idcard;
  @JsonKey(nullable: true)
  String phoneNumber;
  @JsonKey(nullable: true)
  String icon;
  @JsonKey(nullable: true)
  String codeNo;
  @JsonKey(nullable: true)
  String token;
  @JsonKey(nullable: true)
  int accountId;
  @JsonKey(nullable: true)
  int roleId;
  @JsonKey(nullable: true)
  String roleName;
  @JsonKey(nullable: true)
  String email;
  String id;
  @JsonKey(nullable: true)
  String dcId;
  String orgId;
  @JsonKey(nullable: true)
  String createAt;
  String updateAt;

  User(
      {this.name,
      this.orgName,
      this.shortName,
      this.organizId,
      this.type,
      this.gender,
      this.positionName,
      this.positionId,
      this.remark,
      this.status,
      this.birthday,
      this.age,
      this.idcard,
      this.phoneNumber,
      this.icon,
      this.codeNo,
      this.token,
      this.accountId,
      this.roleId,
      this.roleName,
      this.email,
      this.id,
      this.dcId,
      this.orgId,
      this.createAt,
      this.updateAt});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
