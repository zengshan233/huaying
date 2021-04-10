import 'dart:convert' show json;

class WayModel {

  List<WayModelItem> list;

  WayModel.fromParams({this.list});

  factory WayModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new WayModel.fromJson(json.decode(jsonStr)) : new WayModel.fromJson(jsonStr);
  
  WayModel.fromJson(jsonRes) {
    list = jsonRes == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes){
            list.add(listItem == null ? null : new WayModelItem.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '$list';
  }
}

class WayModelItem {

  Object fastCode;
  Object remark;
  int sortOrder;
  int status;
  String createAt;
  String dcId;
  String districtId;
  String districtName;
  String id;
  String lineName;
  String orgId;
  String updateAt;

  WayModelItem.fromParams({this.fastCode, this.remark, this.sortOrder, this.status, this.createAt, this.dcId, this.districtId, this.districtName, this.id, this.lineName, this.orgId, this.updateAt});
  
  WayModelItem.fromJson(jsonRes) {
    fastCode = jsonRes['fastCode'];
    remark = jsonRes['remark'];
    sortOrder = jsonRes['sortOrder'];
    status = jsonRes['status'];
    createAt = jsonRes['createAt'];
    dcId = jsonRes['dcId'];
    districtId = jsonRes['districtId'];
    districtName = jsonRes['districtName'];
    id = jsonRes['id'];
    lineName = jsonRes['lineName'];
    orgId = jsonRes['orgId'];
    updateAt = jsonRes['updateAt'];
  }

  @override
  String toString() {
    return '{"fastCode": $fastCode,"remark": $remark,"sortOrder": $sortOrder,"status": $status,"createAt": ${createAt != null?'${json.encode(createAt)}':'null'},"dcId": ${dcId != null?'${json.encode(dcId)}':'null'},"districtId": ${districtId != null?'${json.encode(districtId)}':'null'},"districtName": ${districtName != null?'${json.encode(districtName)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"lineName": ${lineName != null?'${json.encode(lineName)}':'null'},"orgId": ${orgId != null?'${json.encode(orgId)}':'null'},"updateAt": ${updateAt != null?'${json.encode(updateAt)}':'null'}}';
  }
}

