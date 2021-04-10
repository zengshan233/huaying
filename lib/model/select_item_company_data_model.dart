import 'dart:convert' show json;

class SelectItemLeftMenu {

  List<SelectItemLeftMenuItem> list;

  SelectItemLeftMenu.fromParams({this.list});

  factory SelectItemLeftMenu(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SelectItemLeftMenu.fromJson(json.decode(jsonStr)) : new SelectItemLeftMenu.fromJson(jsonStr);
  
  SelectItemLeftMenu.fromJson(jsonRes) {
    list = jsonRes == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes){
            list.add(listItem == null ? null : new SelectItemLeftMenuItem.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '$list';
  }
}

class SelectItemLeftMenuItem {

  String id;
  String name;

  SelectItemLeftMenuItem.fromParams({this.id, this.name});
  
  SelectItemLeftMenuItem.fromJson(jsonRes) {
    id = jsonRes['id'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"id": ${id != null?'${json.encode(id)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'}}';
  }
}



class SelectItemRightList {

  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<SelectItemRightListItem> records;

  SelectItemRightList.fromParams({this.pageCount, this.pageNumber, this.pageSize, this.rowsCount, this.records});

  factory SelectItemRightList(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SelectItemRightList.fromJson(json.decode(jsonStr)) : new SelectItemRightList.fromJson(jsonStr);
  
  SelectItemRightList.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']){
            records.add(recordsItem == null ? null : new SelectItemRightListItem.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}

class SelectItemRightListItem {

  String createAt;
  String dcId;
  String orgId;
  String remark;
  String updateAt;
  int type;
  bool hasConf;
  String barCode;
  String disciplineId;
  String disciplineName;
  String enShortName;
  String fastCode;
  String id;
  String itemName;
  String labDeptId;
  String labDeptName;
  String specimenTypeId;
  String specimenTypeName;
  String typeName;
  int sortOrder;
  List<String> idList;

  SelectItemRightListItem.fromParams({this.createAt, this.dcId, this.orgId, this.remark, this.updateAt, this.type, this.hasConf, this.barCode, this.disciplineId, this.disciplineName, this.enShortName, this.fastCode, this.id, this.itemName, this.labDeptId, this.labDeptName, this.specimenTypeId, this.specimenTypeName, this.typeName, this.sortOrder,this.idList});

  factory SelectItemRightListItem(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SelectItemRightListItem.fromJson(json.decode(jsonStr)) : new SelectItemRightListItem.fromJson(jsonStr);
  
  SelectItemRightListItem.fromJson(jsonRes) {
    createAt = jsonRes['createAt'];
    dcId = jsonRes['dcId'];
    orgId = jsonRes['orgId'];
    remark = jsonRes['remark'];
    updateAt = jsonRes['updateAt'];
    type = jsonRes['type'];
    hasConf = jsonRes['hasConf'];
    barCode = jsonRes['barCode'];
    disciplineId = jsonRes['disciplineId'];
    disciplineName = jsonRes['disciplineName'];
    enShortName = jsonRes['enShortName'];
    fastCode = jsonRes['fastCode'];
    id = jsonRes['id'];
    itemName = jsonRes['itemName'];
    labDeptId = jsonRes['labDeptId'];
    labDeptName = jsonRes['labDeptName'];
    specimenTypeId = jsonRes['specimenTypeId'];
    specimenTypeName = jsonRes['specimenTypeName'];
    typeName = jsonRes['typeName'];
	sortOrder=jsonRes['sortOrder'];
    idList = jsonRes['idList'] == null ? null : [];

    for (var idListItem in idList == null ? [] : jsonRes['idList']){
            idList.add(idListItem);
    }
  }

  @override
  String toString() {
    return '{"createAt": ${createAt != null?'${json.encode(createAt)}':'null'},"dcId": ${dcId != null?'${json.encode(dcId)}':'null'},"orgId": ${orgId != null?'${json.encode(orgId)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"updateAt": ${updateAt != null?'${json.encode(updateAt)}':'null'},"type": $type,"hasConf": $hasConf,"barCode": ${barCode != null?'${json.encode(barCode)}':'null'},"disciplineId": ${disciplineId != null?'${json.encode(disciplineId)}':'null'},"disciplineName": ${disciplineName != null?'${json.encode(disciplineName)}':'null'},"enShortName": ${enShortName != null?'${json.encode(enShortName)}':'null'},"fastCode": ${fastCode != null?'${json.encode(fastCode)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"itemName": ${itemName != null?'${json.encode(itemName)}':'null'},"labDeptId": ${labDeptId != null?'${json.encode(labDeptId)}':'null'},"labDeptName": ${labDeptName != null?'${json.encode(labDeptName)}':'null'},"specimenTypeId": ${specimenTypeId != null?'${json.encode(specimenTypeId)}':'null'},"specimenTypeName": ${specimenTypeName != null?'${json.encode(specimenTypeName)}':'null'},"typeName": ${typeName != null?'${json.encode(typeName)}':'null'},"sortOrder": $sortOrder,"idList": $idList}';
  }
}



class SelectCompanyList {

  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<SelectCompanyListItem> records;

  SelectCompanyList.fromParams({this.pageCount, this.pageNumber, this.pageSize, this.rowsCount, this.records});

  factory SelectCompanyList(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SelectCompanyList.fromJson(json.decode(jsonStr)) : new SelectCompanyList.fromJson(jsonStr);
  
  SelectCompanyList.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']){
            records.add(recordsItem == null ? null : new SelectCompanyListItem.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}

class SelectCompanyListItem {

  String custName;
  String custId;

  SelectCompanyListItem.fromParams({this.custName, this.custId});
  
  SelectCompanyListItem.fromJson(jsonRes) {
    custName = jsonRes['custName'];
    custId = jsonRes['custId'];
  }

  @override
  String toString() {
    return '{"custName": ${custName != null?'${json.encode(custName)}':'null'},"custId": ${custId != null?'${json.encode(custId)}':'null'}}';
  }
}
