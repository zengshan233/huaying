// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDataModel _$LoginDataModelFromJson(Map<String, dynamic> json) {
  return LoginDataModel(
    accountName: json['accountName'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    orgIdList: (json['orgIdList'] as List)?.map((e) => e as int)?.toList(),
    roleList: (json['roleList'] as List)?.map((e) => e as String)?.toList(),
    resourceList:
        (json['resourceList'] as List)?.map((e) => e as String)?.toList(),
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$LoginDataModelToJson(LoginDataModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'orgIdList': instance.orgIdList,
      'roleList': instance.roleList,
      'resourceList': instance.resourceList,
      'token': instance.token,
      'accountName': instance.accountName,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    name: json['name'] as String,
    orgName: json['orgName'] as String,
    shortName: json['shortName'] as String,
    organizId: json['organizId'] as String,
    type: json['type'] as int,
    gender: json['gender'] as int,
    positionName: json['positionName'] as String,
    positionId: json['positionId'] as String,
    remark: json['remark'] as String,
    status: json['status'] as int,
    birthday: json['birthday'] as String,
    age: json['age'] as int,
    idcard: json['idcard'] as String,
    phoneNumber: json['phoneNumber'] as String,
    icon: json['icon'] as String,
    codeNo: json['codeNo'] as String,
    token: json['token'] as String,
    accountId: json['accountId'] as int,
    roleId: json['roleId'] as int,
    roleName: json['roleName'] as String,
    email: json['email'] as String,
    id: json['id'] as String,
    dcId: json['dcId'] as String,
    orgId: json['orgId'] as String,
    createAt: json['createAt'] as String,
    updateAt: json['updateAt'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
      'orgName': instance.orgName,
      'shortName': instance.shortName,
      'organizId': instance.organizId,
      'type': instance.type,
      'gender': instance.gender,
      'positionName': instance.positionName,
      'positionId': instance.positionId,
      'remark': instance.remark,
      'status': instance.status,
      'birthday': instance.birthday,
      'age': instance.age,
      'idcard': instance.idcard,
      'phoneNumber': instance.phoneNumber,
      'icon': instance.icon,
      'codeNo': instance.codeNo,
      'token': instance.token,
      'accountId': instance.accountId,
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'email': instance.email,
      'id': instance.id,
      'dcId': instance.dcId,
      'orgId': instance.orgId,
      'createAt': instance.createAt,
      'updateAt': instance.updateAt,
    };
