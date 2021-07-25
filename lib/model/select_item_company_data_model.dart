import 'dart:convert' show json;

class SelectItemLeftMenu {
  List<SelectItemLeftMenuItem> list;

  SelectItemLeftMenu.fromParams({this.list});

  factory SelectItemLeftMenu(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new SelectItemLeftMenu.fromJson(json.decode(jsonStr))
          : new SelectItemLeftMenu.fromJson(jsonStr);

  SelectItemLeftMenu.fromJson(jsonRes) {
    list = jsonRes == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes) {
      list.add(listItem == null
          ? null
          : new SelectItemLeftMenuItem.fromJson(listItem));
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
    return '{"id": ${id != null ? '${json.encode(id)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }
}

class SelectItemRightList {
  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<SelectProjectItem> records;

  SelectItemRightList.fromParams(
      {this.pageCount,
      this.pageNumber,
      this.pageSize,
      this.rowsCount,
      this.records});

  factory SelectItemRightList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new SelectItemRightList.fromJson(json.decode(jsonStr))
          : new SelectItemRightList.fromJson(jsonStr);

  SelectItemRightList.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']) {
      records.add(recordsItem == null
          ? null
          : new SelectProjectItem.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}

class SelectProjectItem {
  String createAt;
  String dcId;
  String orgId;
  String remark;
  String codeNo;
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
  String sampleTestMethodName;
  List<String> idList;
  List<ProjectDetailItem> detailList;

  SelectProjectItem.fromParams(
      {this.createAt,
      this.dcId,
      this.orgId,
      this.remark,
      this.codeNo,
      this.updateAt,
      this.type,
      this.hasConf,
      this.barCode,
      this.disciplineId,
      this.disciplineName,
      this.enShortName,
      this.fastCode,
      this.id,
      this.itemName,
      this.labDeptId,
      this.labDeptName,
      this.specimenTypeId,
      this.specimenTypeName,
      this.typeName,
      this.sortOrder,
      this.sampleTestMethodName,
      this.detailList,
      this.idList});

  factory SelectProjectItem(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new SelectProjectItem.fromJson(json.decode(jsonStr))
          : new SelectProjectItem.fromJson(jsonStr);

  SelectProjectItem.fromJson(jsonRes) {
    createAt = jsonRes['createAt'];
    dcId = jsonRes['dcId'];
    orgId = jsonRes['orgId'];
    remark = jsonRes['remark'];
    codeNo = jsonRes['codeNo'];
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
    sortOrder = jsonRes['sortOrder'];
    sampleTestMethodName = jsonRes['sampleTestMethodName'];
    idList = jsonRes['idList'] == null ? null : [];

    for (var idListItem in idList == null ? [] : jsonRes['idList']) {
      idList.add(idListItem);
    }
  }

  Map<String, dynamic> toItemJson() {
    Map<String, dynamic> json = {
      "barCode": this.barCode,
      "itemId": this.id,
      "itemName": this.itemName,
      "itemType": this.type,
      "itemTypeName": this.typeName,

      /// 先写死
      "labId": '82858490362716212',

      /// 先写死
      "labName": '广州华银医学检验中心有限公司',
      "specimenType": this.specimenTypeId,
      "specimenTypeName": this.specimenTypeName,
      "sampleTestMethodName": this.sampleTestMethodName,
    };
    if (this.enShortName != null) {
      json['enShortName'] = enShortName;
    }
    if (this.sortOrder != null) {
      json['sortOrder'] = sortOrder;
    }
    if (this.labDeptId != null) {
      json['professionalGroupId'] = labDeptId;
    }
    if (this.labDeptName != null) {
      json['professionalGroupName'] = labDeptName;
    }
    if (this.codeNo != null) {
      json['codeNo'] = codeNo;
    }
    return json;
  }

  @override
  String toString() {
    return '{"createAt": ${createAt != null ? '${json.encode(createAt)}' : 'null'},"dcId": ${dcId != null ? '${json.encode(dcId)}' : 'null'},"orgId": ${orgId != null ? '${json.encode(orgId)}' : 'null'},"remark": ${remark != null ? '${json.encode(remark)}' : 'null'},"updateAt": ${updateAt != null ? '${json.encode(updateAt)}' : 'null'},"type": $type,"hasConf": $hasConf,"barCode": ${barCode != null ? '${json.encode(barCode)}' : 'null'},"disciplineId": ${disciplineId != null ? '${json.encode(disciplineId)}' : 'null'},"disciplineName": ${disciplineName != null ? '${json.encode(disciplineName)}' : 'null'},"enShortName": ${enShortName != null ? '${json.encode(enShortName)}' : 'null'},"fastCode": ${fastCode != null ? '${json.encode(fastCode)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"itemName": ${itemName != null ? '${json.encode(itemName)}' : 'null'},"labDeptId": ${labDeptId != null ? '${json.encode(labDeptId)}' : 'null'},"labDeptName": ${labDeptName != null ? '${json.encode(labDeptName)}' : 'null'},"specimenTypeId": ${specimenTypeId != null ? '${json.encode(specimenTypeId)}' : 'null'},"specimenTypeName": ${specimenTypeName != null ? '${json.encode(specimenTypeName)}' : 'null'},"typeName": ${typeName != null ? '${json.encode(typeName)}' : 'null'},"sortOrder": $sortOrder,"idList": $idList ,"sampleTestMethodName": ${sampleTestMethodName != null ? '${json.encode(sampleTestMethodName)}' : 'null'}}';
  }
}

class ProjectDetailItem {
  String parentId;
  String childId;
  String standCodeNo;
  String name;
  int itemType;
  String shortName;
  String enName;
  String enShortName;
  String sampleTestMethodId;
  String disciplineId;
  String disciplineName;
  String sampleTypeId;
  String collectSpecimenTypeId;
  String collectSpecimenTypeName;
  int allowQuantity;
  String price;
  String labDeptId;
  String labDeptName;
  String itemId;
  int sortOrder;
  String codeNo;
  int forSex;
  int itemCategory;
  String id;
  String dcId;
  String orgId;
  String createAt;
  String updateAt;

  ProjectDetailItem(
      {this.parentId,
      this.childId,
      this.standCodeNo,
      this.name,
      this.itemType,
      this.shortName,
      this.enName,
      this.enShortName,
      this.sampleTestMethodId,
      this.disciplineId,
      this.disciplineName,
      this.sampleTypeId,
      this.collectSpecimenTypeId,
      this.collectSpecimenTypeName,
      this.allowQuantity,
      this.price,
      this.labDeptId,
      this.labDeptName,
      this.itemId,
      this.sortOrder,
      this.codeNo,
      this.forSex,
      this.itemCategory,
      this.id,
      this.dcId,
      this.orgId,
      this.createAt,
      this.updateAt});

  ProjectDetailItem.fromJson(Map<String, dynamic> json) {
    parentId = json['parentId'];
    childId = json['childId'];
    standCodeNo = json['standCodeNo'];
    name = json['name'];
    itemType = json['itemType'];
    shortName = json['shortName'];
    enName = json['enName'];
    enShortName = json['enShortName'];
    sampleTestMethodId = json['sampleTestMethodId'];
    disciplineId = json['disciplineId'];
    disciplineName = json['disciplineName'];
    sampleTypeId = json['sampleTypeId'];
    collectSpecimenTypeId = json['collectSpecimenTypeId'];
    collectSpecimenTypeName = json['collectSpecimenTypeName'];
    allowQuantity = json['allowQuantity'];
    price = json['price'];
    labDeptId = json['labDeptId'];
    labDeptName = json['labDeptName'];
    itemId = json['itemId'];
    sortOrder = json['sortOrder'];
    codeNo = json['codeNo'];
    forSex = json['forSex'];
    itemCategory = json['itemCategory'];
    id = json['id'];
    dcId = json['dcId'];
    orgId = json['orgId'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }
  Map<String, dynamic> toItemJson() {
    Map<String, dynamic> json = {
      "itemId": this.id,
      "itemName": this.name,
      "itemType": this.itemType,

      /// 先写死
      "labId": '82858490362716212',

      /// 先写死
      "labName": '广州华银医学检验中心有限公司',
      "specimenType": this.collectSpecimenTypeId,
      "specimenTypeName": this.collectSpecimenTypeName,
    };
    if (this.enShortName != null) {
      json['enShortName'] = enShortName;
    }
    if (this.sortOrder != null) {
      json['sortOrder'] = sortOrder;
    }
    if (this.labDeptId != null) {
      json['professionalGroupId'] = labDeptId;
    }
    if (this.labDeptName != null) {
      json['professionalGroupName'] = labDeptName;
    }
    if (this.itemCategory != null) {
      json['itemCategory'] = itemCategory;
    }
    if (this.itemCategory != null) {
      json['itemCategory'] = itemCategory;
    }
    if (this.allowQuantity != null) {
      json['allowQuantity'] = allowQuantity;
    }
    if (this.codeNo != null) {
      json['codeNo'] = codeNo;
    }
    if (this.forSex != null) {
      json['forSex'] = forSex;
    }
    return json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parentId'] = this.parentId;
    data['childId'] = this.childId;
    data['standCodeNo'] = this.standCodeNo;
    data['name'] = this.name;
    data['itemType'] = this.itemType;
    data['shortName'] = this.shortName;
    data['enName'] = this.enName;
    data['enShortName'] = this.enShortName;
    data['sampleTestMethodId'] = this.sampleTestMethodId;
    data['disciplineId'] = this.disciplineId;
    data['disciplineName'] = this.disciplineName;
    data['sampleTypeId'] = this.sampleTypeId;
    data['collectSpecimenTypeId'] = this.collectSpecimenTypeId;
    data['collectSpecimenTypeName'] = this.collectSpecimenTypeName;
    data['allowQuantity'] = this.allowQuantity;
    data['price'] = this.price;
    data['labDeptId'] = this.labDeptId;
    data['labDeptName'] = this.labDeptName;
    data['itemId'] = this.itemId;
    data['sortOrder'] = this.sortOrder;
    data['codeNo'] = this.codeNo;
    data['forSex'] = this.forSex;
    data['itemCategory'] = this.itemCategory;
    data['id'] = this.id;
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}

class SelectCompanyList {
  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<SelectCompanyListItem> records;

  SelectCompanyList.fromParams(
      {this.pageCount,
      this.pageNumber,
      this.pageSize,
      this.rowsCount,
      this.records});

  factory SelectCompanyList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new SelectCompanyList.fromJson(json.decode(jsonStr))
          : new SelectCompanyList.fromJson(jsonStr);

  SelectCompanyList.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']) {
      records.add(recordsItem == null
          ? null
          : new SelectCompanyListItem.fromJson(recordsItem));
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
    return '{"custName": ${custName != null ? '${json.encode(custName)}' : 'null'},"custId": ${custId != null ? '${json.encode(custId)}' : 'null'}}';
  }
}
