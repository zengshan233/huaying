const Map<int, String> checkStatus = {
  2: '待审核',
  3: '审核通过',
  4: '驳回',
};

class CheckItem {
  String aloneRecordAuditedRejectRemark;
  int aloneRecordStatus;
  String aloneRecordStatusName;
  String applyId;
  String arecordId;
  String arecordName;
  String asubmitTime;
  String barCode;
  String boxNo;
  String createAt;
  String dcId;
  String hanger;
  String hangerId;
  String hangupTime;
  String id;
  String inspectionUnitId;
  String inspectionUnitName;
  bool isHangup;
  String itemNames;
  String name;
  String orgId;
  String photographTime;
  String photographer;
  String photographerId;
  String updateAt;

  CheckItem(
      {this.aloneRecordAuditedRejectRemark,
      this.aloneRecordStatus,
      this.aloneRecordStatusName,
      this.applyId,
      this.arecordId,
      this.arecordName,
      this.asubmitTime,
      this.barCode,
      this.boxNo,
      this.createAt,
      this.dcId,
      this.hanger,
      this.hangerId,
      this.hangupTime,
      this.id,
      this.inspectionUnitId,
      this.inspectionUnitName,
      this.isHangup,
      this.itemNames,
      this.name,
      this.orgId,
      this.photographTime,
      this.photographer,
      this.photographerId,
      this.updateAt});

  CheckItem.fromJson(Map<String, dynamic> json) {
    aloneRecordAuditedRejectRemark = json['aloneRecordAuditedRejectRemark'];
    aloneRecordStatus = json['aloneRecordStatus'];
    aloneRecordStatusName = json['aloneRecordStatusName'];
    applyId = json['applyId'];
    arecordId = json['arecordId'];
    arecordName = json['arecordName'];
    asubmitTime = json['asubmitTime'];
    barCode = json['barCode'];
    boxNo = json['boxNo'];
    createAt = json['createAt'];
    dcId = json['dcId'];
    hanger = json['hanger'];
    hangerId = json['hangerId'];
    hangupTime = json['hangupTime'];
    id = json['id'];
    inspectionUnitId = json['inspectionUnitId'];
    inspectionUnitName = json['inspectionUnitName'];
    isHangup = json['isHangup'];
    itemNames = json['itemNames'];
    name = json['name'];
    orgId = json['orgId'];
    photographTime = json['photographTime'];
    photographer = json['photographer'];
    photographerId = json['photographerId'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aloneRecordAuditedRejectRemark'] =
        this.aloneRecordAuditedRejectRemark;
    data['aloneRecordStatus'] = this.aloneRecordStatus;
    data['aloneRecordStatusName'] = this.aloneRecordStatusName;
    data['applyId'] = this.applyId;
    data['arecordId'] = this.arecordId;
    data['arecordName'] = this.arecordName;
    data['asubmitTime'] = this.asubmitTime;
    data['barCode'] = this.barCode;
    data['boxNo'] = this.boxNo;
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['hanger'] = this.hanger;
    data['hangerId'] = this.hangerId;
    data['hangupTime'] = this.hangupTime;
    data['id'] = this.id;
    data['inspectionUnitId'] = this.inspectionUnitId;
    data['inspectionUnitName'] = this.inspectionUnitName;
    data['isHangup'] = this.isHangup;
    data['itemNames'] = this.itemNames;
    data['name'] = this.name;
    data['orgId'] = this.orgId;
    data['photographTime'] = this.photographTime;
    data['photographer'] = this.photographer;
    data['photographerId'] = this.photographerId;
    data['updateAt'] = this.updateAt;
    return data;
  }
}

class CheckDetailData {
  Apply apply;
  List<Images> images;
  List<Items> items;
  List<Meta> meta;
  Map<String, dynamic> extra;

  CheckDetailData({this.apply, this.images, this.items, this.meta, this.extra});

  CheckDetailData.fromJson(Map<String, dynamic> json) {
    apply = json['apply'] != null ? new Apply.fromJson(json['apply']) : null;
    extra = json['extra'] ?? {};
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    if (json['meta'] != null) {
      meta = new List<Meta>();
      json['meta'].forEach((v) {
        meta.add(new Meta.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.apply != null) {
      data['apply'] = this.apply.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.map((v) => v.toJson()).toList();
    }
    data['extra'] = this.extra.toString();
    return data;
  }
}

class Apply {
  String age;
  String applyDate;
  String applyDoctorId;
  String applyDoctorName;
  String applyFrom;
  String applyNo;
  String applyReasonId;
  String arecordId;
  String arecordName;
  String asubmitTime;
  String barCode;
  String birthDate;
  String brecordId;
  String brecordName;
  String bsubmitTime;
  String bultrasoundDate;
  int caculatedAge;
  int chargebackStatus;
  String chargebackStatusName;
  String chargebackType;
  String chippedPosition;
  String clinicalDiagnosis;
  String collectorTime;
  String createAt;
  String dcId;
  String departmentId;
  String departmentName;
  String doctorPhone;
  String doubleRecordSourceId;
  int doubleRecordStatus;
  String doubleRecordStatusName;
  String doubleRecordType;
  String fields;
  int finsType;
  String finsTypeName;
  String hanger;
  String hangerId;
  String hangupTime;
  bool hasCirculation;
  bool hasExtra;
  bool hasSampleRemark;
  String hospitalCode;
  String id;
  String idCard;
  String idCardTypeName;
  String inspectionUnitId;
  String inspectionUnitName;
  String internalReceiveId;
  String internalReceiveName;
  String internalReceiveTime;
  bool isGenerateApply;
  bool isHangup;
  bool isSpecialHandle;
  bool isSpiltBottle;
  int itemCategory;
  int itemCount;
  String itemNames;
  List<Items> items;
  String linkupStatus;
  String livingBodyNo;
  String name;
  bool needSpiltBottle;
  int notProvideCollectorTime;
  String objectives;
  int orderType;
  String orderTypeName;
  String orgId;
  String outpatientNumber;
  String phone;
  String photographTime;
  String photographer;
  String photographerId;
  String pigeonholeCode;
  String pregnancyWeek;
  String recheckBarcode;
  String recheckStatus;
  String recheckStatusName;
  String recordId;
  String recordName;
  String recordNameRemark;
  String recordTime;
  int relStatus;
  String relStatusName;
  String relTime;
  String remark;
  int sex;
  String sexName;
  String sickbedNumber;
  int simpleRecordStatus;
  String simpleRecordStatusName;
  String specimenStatusId;
  String specimenStatusName;
  String specimenTypeId;
  String specimenTypeName;
  String spiltBottleHandler;
  String spiltBottleHandlerId;
  String spiltBottleSubBarCode;
  String spiltBottleTime;
  int status;
  String statusName;
  String th3CustomerName;
  String ultrasoundPrompt;
  String unpaidMenstruation;
  String updateAt;
  String visitTypeId;
  String visitTypeName;
  String wardId;
  String wardName;

  Apply(
      {this.age,
      this.applyDate,
      this.applyDoctorId,
      this.applyDoctorName,
      this.applyFrom,
      this.applyNo,
      this.applyReasonId,
      this.arecordId,
      this.arecordName,
      this.asubmitTime,
      this.barCode,
      this.birthDate,
      this.brecordId,
      this.brecordName,
      this.bsubmitTime,
      this.bultrasoundDate,
      this.caculatedAge,
      this.chargebackStatus,
      this.chargebackStatusName,
      this.chargebackType,
      this.chippedPosition,
      this.clinicalDiagnosis,
      this.collectorTime,
      this.createAt,
      this.dcId,
      this.departmentId,
      this.departmentName,
      this.doctorPhone,
      this.doubleRecordSourceId,
      this.doubleRecordStatus,
      this.doubleRecordStatusName,
      this.doubleRecordType,
      this.fields,
      this.finsType,
      this.finsTypeName,
      this.hanger,
      this.hangerId,
      this.hangupTime,
      this.hasCirculation,
      this.hasExtra,
      this.hasSampleRemark,
      this.hospitalCode,
      this.id,
      this.idCard,
      this.idCardTypeName,
      this.inspectionUnitId,
      this.inspectionUnitName,
      this.internalReceiveId,
      this.internalReceiveName,
      this.internalReceiveTime,
      this.isGenerateApply,
      this.isHangup,
      this.isSpecialHandle,
      this.isSpiltBottle,
      this.itemCategory,
      this.itemCount,
      this.itemNames,
      this.items,
      this.linkupStatus,
      this.livingBodyNo,
      this.name,
      this.needSpiltBottle,
      this.notProvideCollectorTime,
      this.objectives,
      this.orderType,
      this.orderTypeName,
      this.orgId,
      this.outpatientNumber,
      this.phone,
      this.photographTime,
      this.photographer,
      this.photographerId,
      this.pigeonholeCode,
      this.pregnancyWeek,
      this.recheckBarcode,
      this.recheckStatus,
      this.recheckStatusName,
      this.recordId,
      this.recordName,
      this.recordNameRemark,
      this.recordTime,
      this.relStatus,
      this.relStatusName,
      this.relTime,
      this.remark,
      this.sex,
      this.sexName,
      this.sickbedNumber,
      this.simpleRecordStatus,
      this.simpleRecordStatusName,
      this.specimenStatusId,
      this.specimenStatusName,
      this.specimenTypeId,
      this.specimenTypeName,
      this.spiltBottleHandler,
      this.spiltBottleHandlerId,
      this.spiltBottleSubBarCode,
      this.spiltBottleTime,
      this.status,
      this.statusName,
      this.th3CustomerName,
      this.ultrasoundPrompt,
      this.unpaidMenstruation,
      this.updateAt,
      this.visitTypeId,
      this.visitTypeName,
      this.wardId,
      this.wardName});

  Apply.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    applyDate = json['applyDate'];
    applyDoctorId = json['applyDoctorId'];
    applyDoctorName = json['applyDoctorName'];
    applyFrom = json['applyFrom'];
    applyNo = json['applyNo'];
    applyReasonId = json['applyReasonId'];
    arecordId = json['arecordId'];
    arecordName = json['arecordName'];
    asubmitTime = json['asubmitTime'];
    barCode = json['barCode'];
    birthDate = json['birthDate'];
    brecordId = json['brecordId'];
    brecordName = json['brecordName'];
    bsubmitTime = json['bsubmitTime'];
    bultrasoundDate = json['bultrasoundDate'];
    caculatedAge = json['caculatedAge'];
    chargebackStatus = json['chargebackStatus'];
    chargebackStatusName = json['chargebackStatusName'];
    chargebackType = json['chargebackType'];
    chippedPosition = json['chippedPosition'];
    clinicalDiagnosis = json['clinicalDiagnosis'];
    collectorTime = json['collectorTime'];
    createAt = json['createAt'];
    dcId = json['dcId'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    doctorPhone = json['doctorPhone'];
    doubleRecordSourceId = json['doubleRecordSourceId'];
    doubleRecordStatus = json['doubleRecordStatus'];
    doubleRecordStatusName = json['doubleRecordStatusName'];
    doubleRecordType = json['doubleRecordType'];
    fields = json['fields'];
    finsType = json['finsType'];
    finsTypeName = json['finsTypeName'];
    hanger = json['hanger'];
    hangerId = json['hangerId'];
    hangupTime = json['hangupTime'];
    hasCirculation = json['hasCirculation'];
    hasExtra = json['hasExtra'];
    hasSampleRemark = json['hasSampleRemark'];
    hospitalCode = json['hospitalCode'];
    id = json['id'];
    idCard = json['idCard'];
    idCardTypeName = json['idCardTypeName'];
    inspectionUnitId = json['inspectionUnitId'];
    inspectionUnitName = json['inspectionUnitName'];
    internalReceiveId = json['internalReceiveId'];
    internalReceiveName = json['internalReceiveName'];
    internalReceiveTime = json['internalReceiveTime'];
    isGenerateApply = json['isGenerateApply'];
    isHangup = json['isHangup'];
    isSpecialHandle = json['isSpecialHandle'];
    isSpiltBottle = json['isSpiltBottle'];
    itemCategory = json['itemCategory'];
    itemCount = json['itemCount'];
    itemNames = json['itemNames'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    linkupStatus = json['linkupStatus'];
    livingBodyNo = json['livingBodyNo'];
    name = json['name'];
    needSpiltBottle = json['needSpiltBottle'];
    notProvideCollectorTime = json['notProvideCollectorTime'];
    objectives = json['objectives'];
    orderType = json['orderType'];
    orderTypeName = json['orderTypeName'];
    orgId = json['orgId'];
    outpatientNumber = json['outpatientNumber'];
    phone = json['phone'];
    photographTime = json['photographTime'];
    photographer = json['photographer'];
    photographerId = json['photographerId'];
    pigeonholeCode = json['pigeonholeCode'];
    pregnancyWeek = json['pregnancyWeek'];
    recheckBarcode = json['recheckBarcode'];
    recheckStatus = json['recheckStatus'];
    recheckStatusName = json['recheckStatusName'];
    recordId = json['recordId'];
    recordName = json['recordName'];
    recordNameRemark = json['recordNameRemark'];
    recordTime = json['recordTime'];
    relStatus = json['relStatus'];
    relStatusName = json['relStatusName'];
    relTime = json['relTime'];
    remark = json['remark'];
    sex = json['sex'];
    sexName = json['sexName'];
    sickbedNumber = json['sickbedNumber'];
    simpleRecordStatus = json['simpleRecordStatus'];
    simpleRecordStatusName = json['simpleRecordStatusName'];
    specimenStatusId = json['specimenStatusId'];
    specimenStatusName = json['specimenStatusName'];
    specimenTypeId = json['specimenTypeId'];
    specimenTypeName = json['specimenTypeName'];
    spiltBottleHandler = json['spiltBottleHandler'];
    spiltBottleHandlerId = json['spiltBottleHandlerId'];
    spiltBottleSubBarCode = json['spiltBottleSubBarCode'];
    spiltBottleTime = json['spiltBottleTime'];
    status = json['status'];
    statusName = json['statusName'];
    th3CustomerName = json['th3CustomerName'];
    ultrasoundPrompt = json['ultrasoundPrompt'];
    unpaidMenstruation = json['unpaidMenstruation'];
    updateAt = json['updateAt'];
    visitTypeId = json['visitTypeId'];
    visitTypeName = json['visitTypeName'];
    wardId = json['wardId'];
    wardName = json['wardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['applyDate'] = this.applyDate;
    data['applyDoctorId'] = this.applyDoctorId;
    data['applyDoctorName'] = this.applyDoctorName;
    data['applyFrom'] = this.applyFrom;
    data['applyNo'] = this.applyNo;
    data['applyReasonId'] = this.applyReasonId;
    data['arecordId'] = this.arecordId;
    data['arecordName'] = this.arecordName;
    data['asubmitTime'] = this.asubmitTime;
    data['barCode'] = this.barCode;
    data['birthDate'] = this.birthDate;
    data['brecordId'] = this.brecordId;
    data['brecordName'] = this.brecordName;
    data['bsubmitTime'] = this.bsubmitTime;
    data['bultrasoundDate'] = this.bultrasoundDate;
    data['caculatedAge'] = this.caculatedAge;
    data['chargebackStatus'] = this.chargebackStatus;
    data['chargebackStatusName'] = this.chargebackStatusName;
    data['chargebackType'] = this.chargebackType;
    data['chippedPosition'] = this.chippedPosition;
    data['clinicalDiagnosis'] = this.clinicalDiagnosis;
    data['collectorTime'] = this.collectorTime;
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['departmentId'] = this.departmentId;
    data['departmentName'] = this.departmentName;
    data['doctorPhone'] = this.doctorPhone;
    data['doubleRecordSourceId'] = this.doubleRecordSourceId;
    data['doubleRecordStatus'] = this.doubleRecordStatus;
    data['doubleRecordStatusName'] = this.doubleRecordStatusName;
    data['doubleRecordType'] = this.doubleRecordType;
    data['fields'] = this.fields;
    data['finsType'] = this.finsType;
    data['finsTypeName'] = this.finsTypeName;
    data['hanger'] = this.hanger;
    data['hangerId'] = this.hangerId;
    data['hangupTime'] = this.hangupTime;
    data['hasCirculation'] = this.hasCirculation;
    data['hasExtra'] = this.hasExtra;
    data['hasSampleRemark'] = this.hasSampleRemark;
    data['hospitalCode'] = this.hospitalCode;
    data['id'] = this.id;
    data['idCard'] = this.idCard;
    data['idCardTypeName'] = this.idCardTypeName;
    data['inspectionUnitId'] = this.inspectionUnitId;
    data['inspectionUnitName'] = this.inspectionUnitName;
    data['internalReceiveId'] = this.internalReceiveId;
    data['internalReceiveName'] = this.internalReceiveName;
    data['internalReceiveTime'] = this.internalReceiveTime;
    data['isGenerateApply'] = this.isGenerateApply;
    data['isHangup'] = this.isHangup;
    data['isSpecialHandle'] = this.isSpecialHandle;
    data['isSpiltBottle'] = this.isSpiltBottle;
    data['itemCategory'] = this.itemCategory;
    data['itemCount'] = this.itemCount;
    data['itemNames'] = this.itemNames;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['linkupStatus'] = this.linkupStatus;
    data['livingBodyNo'] = this.livingBodyNo;
    data['name'] = this.name;
    data['needSpiltBottle'] = this.needSpiltBottle;
    data['notProvideCollectorTime'] = this.notProvideCollectorTime;
    data['objectives'] = this.objectives;
    data['orderType'] = this.orderType;
    data['orderTypeName'] = this.orderTypeName;
    data['orgId'] = this.orgId;
    data['outpatientNumber'] = this.outpatientNumber;
    data['phone'] = this.phone;
    data['photographTime'] = this.photographTime;
    data['photographer'] = this.photographer;
    data['photographerId'] = this.photographerId;
    data['pigeonholeCode'] = this.pigeonholeCode;
    data['pregnancyWeek'] = this.pregnancyWeek;
    data['recheckBarcode'] = this.recheckBarcode;
    data['recheckStatus'] = this.recheckStatus;
    data['recheckStatusName'] = this.recheckStatusName;
    data['recordId'] = this.recordId;
    data['recordName'] = this.recordName;
    data['recordNameRemark'] = this.recordNameRemark;
    data['recordTime'] = this.recordTime;
    data['relStatus'] = this.relStatus;
    data['relStatusName'] = this.relStatusName;
    data['relTime'] = this.relTime;
    data['remark'] = this.remark;
    data['sex'] = this.sex;
    data['sexName'] = this.sexName;
    data['sickbedNumber'] = this.sickbedNumber;
    data['simpleRecordStatus'] = this.simpleRecordStatus;
    data['simpleRecordStatusName'] = this.simpleRecordStatusName;
    data['specimenStatusId'] = this.specimenStatusId;
    data['specimenStatusName'] = this.specimenStatusName;
    data['specimenTypeId'] = this.specimenTypeId;
    data['specimenTypeName'] = this.specimenTypeName;
    data['spiltBottleHandler'] = this.spiltBottleHandler;
    data['spiltBottleHandlerId'] = this.spiltBottleHandlerId;
    data['spiltBottleSubBarCode'] = this.spiltBottleSubBarCode;
    data['spiltBottleTime'] = this.spiltBottleTime;
    data['status'] = this.status;
    data['statusName'] = this.statusName;
    data['th3CustomerName'] = this.th3CustomerName;
    data['ultrasoundPrompt'] = this.ultrasoundPrompt;
    data['unpaidMenstruation'] = this.unpaidMenstruation;
    data['updateAt'] = this.updateAt;
    data['visitTypeId'] = this.visitTypeId;
    data['visitTypeName'] = this.visitTypeName;
    data['wardId'] = this.wardId;
    data['wardName'] = this.wardName;
    return data;
  }
}

class Items {
  String applyId;
  String barCode;
  String chargeBackStatus;
  String chargeBackStatusName;
  String codeNo;
  String createAt;
  String dcId;
  String enShortName;
  String id;
  String inspectionProductCode;
  int itemCategory;
  String itemId;
  String itemName;
  int itemQuantity;
  int itemType;
  String itemTypeName;
  String labId;
  String labName;
  String orgId;
  String packageId;
  String packageIndex;
  String professionalGroupId;
  String professionalGroupName;
  int sortOrder;
  String specimenType;
  String specimenTypeName;
  int status;
  String statusName;
  List<TestItem> testItem;
  String updateAt;

  Items(
      {this.applyId,
      this.barCode,
      this.chargeBackStatus,
      this.chargeBackStatusName,
      this.codeNo,
      this.createAt,
      this.dcId,
      this.enShortName,
      this.id,
      this.inspectionProductCode,
      this.itemCategory,
      this.itemId,
      this.itemName,
      this.itemQuantity,
      this.itemType,
      this.itemTypeName,
      this.labId,
      this.labName,
      this.orgId,
      this.packageId,
      this.packageIndex,
      this.professionalGroupId,
      this.professionalGroupName,
      this.sortOrder,
      this.specimenType,
      this.specimenTypeName,
      this.status,
      this.statusName,
      this.testItem,
      this.updateAt});

  Items.fromJson(Map<String, dynamic> json) {
    applyId = json['applyId'];
    barCode = json['barCode'];
    chargeBackStatus = json['chargeBackStatus'];
    chargeBackStatusName = json['chargeBackStatusName'];
    codeNo = json['codeNo'];
    createAt = json['createAt'];
    dcId = json['dcId'];
    enShortName = json['enShortName'];
    id = json['id'];
    inspectionProductCode = json['inspectionProductCode'];
    itemCategory = json['itemCategory'];
    itemId = json['itemId'];
    itemName = json['itemName'];
    itemQuantity = json['itemQuantity'];
    itemType = json['itemType'];
    itemTypeName = json['itemTypeName'];
    labId = json['labId'];
    labName = json['labName'];
    orgId = json['orgId'];
    packageId = json['packageId'];
    packageIndex = json['packageIndex'];
    professionalGroupId = json['professionalGroupId'];
    professionalGroupName = json['professionalGroupName'];
    sortOrder = json['sortOrder'];
    specimenType = json['specimenType'];
    specimenTypeName = json['specimenTypeName'];
    status = json['status'];
    statusName = json['statusName'];
    if (json['testItem'] != null) {
      testItem = new List<TestItem>();
      json['testItem'].forEach((v) {
        testItem.add(new TestItem.fromJson(v));
      });
    }
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applyId'] = this.applyId;
    data['barCode'] = this.barCode;
    data['chargeBackStatus'] = this.chargeBackStatus;
    data['chargeBackStatusName'] = this.chargeBackStatusName;
    data['codeNo'] = this.codeNo;
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['enShortName'] = this.enShortName;
    data['id'] = this.id;
    data['inspectionProductCode'] = this.inspectionProductCode;
    data['itemCategory'] = this.itemCategory;
    data['itemId'] = this.itemId;
    data['itemName'] = this.itemName;
    data['itemQuantity'] = this.itemQuantity;
    data['itemType'] = this.itemType;
    data['itemTypeName'] = this.itemTypeName;
    data['labId'] = this.labId;
    data['labName'] = this.labName;
    data['orgId'] = this.orgId;
    data['packageId'] = this.packageId;
    data['packageIndex'] = this.packageIndex;
    data['professionalGroupId'] = this.professionalGroupId;
    data['professionalGroupName'] = this.professionalGroupName;
    data['sortOrder'] = this.sortOrder;
    data['specimenType'] = this.specimenType;
    data['specimenTypeName'] = this.specimenTypeName;
    data['status'] = this.status;
    data['statusName'] = this.statusName;
    if (this.testItem != null) {
      data['testItem'] = this.testItem.map((v) => v.toJson()).toList();
    }
    data['updateAt'] = this.updateAt;
    return data;
  }
}

class TestItem {
  String applyId;
  String applyItemId;
  String codeNo;
  String createAt;
  String dcId;
  String enName;
  String enShortName;
  String id;
  int itemQuantity;
  String labId;
  String labName;
  String orgId;
  String professionalGroupId;
  String professionalGroupName;
  int sortOrder;
  String specimenTypeId;
  String specimenTypeName;
  String standCodeNo;
  int status;
  String subCodeId;
  String testItemId;
  String testItemName;
  String updateAt;

  TestItem(
      {this.applyId,
      this.applyItemId,
      this.codeNo,
      this.createAt,
      this.dcId,
      this.enName,
      this.enShortName,
      this.id,
      this.itemQuantity,
      this.labId,
      this.labName,
      this.orgId,
      this.professionalGroupId,
      this.professionalGroupName,
      this.sortOrder,
      this.specimenTypeId,
      this.specimenTypeName,
      this.standCodeNo,
      this.status,
      this.subCodeId,
      this.testItemId,
      this.testItemName,
      this.updateAt});

  TestItem.fromJson(Map<String, dynamic> json) {
    applyId = json['applyId'];
    applyItemId = json['applyItemId'];
    codeNo = json['codeNo'];
    createAt = json['createAt'];
    dcId = json['dcId'];
    enName = json['enName'];
    enShortName = json['enShortName'];
    id = json['id'];
    itemQuantity = json['itemQuantity'];
    labId = json['labId'];
    labName = json['labName'];
    orgId = json['orgId'];
    professionalGroupId = json['professionalGroupId'];
    professionalGroupName = json['professionalGroupName'];
    sortOrder = json['sortOrder'];
    specimenTypeId = json['specimenTypeId'];
    specimenTypeName = json['specimenTypeName'];
    standCodeNo = json['standCodeNo'];
    status = json['status'];
    subCodeId = json['subCodeId'];
    testItemId = json['testItemId'];
    testItemName = json['testItemName'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applyId'] = this.applyId;
    data['applyItemId'] = this.applyItemId;
    data['codeNo'] = this.codeNo;
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['enName'] = this.enName;
    data['enShortName'] = this.enShortName;
    data['id'] = this.id;
    data['itemQuantity'] = this.itemQuantity;
    data['labId'] = this.labId;
    data['labName'] = this.labName;
    data['orgId'] = this.orgId;
    data['professionalGroupId'] = this.professionalGroupId;
    data['professionalGroupName'] = this.professionalGroupName;
    data['sortOrder'] = this.sortOrder;
    data['specimenTypeId'] = this.specimenTypeId;
    data['specimenTypeName'] = this.specimenTypeName;
    data['standCodeNo'] = this.standCodeNo;
    data['status'] = this.status;
    data['subCodeId'] = this.subCodeId;
    data['testItemId'] = this.testItemId;
    data['testItemName'] = this.testItemName;
    data['updateAt'] = this.updateAt;
    return data;
  }
}

class Images {
  String createAt;
  String dcId;
  String describe;
  String id;
  String name;
  String orgId;
  String relId;
  String updateAt;
  String url;

  Images(
      {this.createAt,
      this.dcId,
      this.describe,
      this.id,
      this.name,
      this.orgId,
      this.relId,
      this.updateAt,
      this.url});

  Images.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'];
    dcId = json['dcId'];
    describe = json['describe'];
    id = json['id'];
    name = json['name'];
    orgId = json['orgId'];
    relId = json['relId'];
    updateAt = json['updateAt'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['describe'] = this.describe;
    data['id'] = this.id;
    data['name'] = this.name;
    data['orgId'] = this.orgId;
    data['relId'] = this.relId;
    data['updateAt'] = this.updateAt;
    data['url'] = this.url;
    return data;
  }
}

class Meta {
  String applyId;
  String checkRule;
  String createAt;
  int dataType;
  String dataTypeName;
  String dcId;
  String defaultValue;
  String fieldId;
  String fieldName;
  String id;
  int length;
  String mapperField;
  String orgId;
  bool required;
  int sortOrder;
  String updateAt;
  String widgetCode;

  Meta(
      {this.applyId,
      this.checkRule,
      this.createAt,
      this.dataType,
      this.dataTypeName,
      this.dcId,
      this.defaultValue,
      this.fieldId,
      this.fieldName,
      this.id,
      this.length,
      this.mapperField,
      this.orgId,
      this.required,
      this.sortOrder,
      this.updateAt,
      this.widgetCode});

  Meta.fromJson(Map<String, dynamic> json) {
    applyId = json['applyId'];
    checkRule = json['checkRule'];
    createAt = json['createAt'];
    dataType = json['dataType'];
    dataTypeName = json['dataTypeName'];
    dcId = json['dcId'];
    defaultValue = json['defaultValue'];
    fieldId = json['fieldId'];
    fieldName = json['fieldName'];
    id = json['id'];
    length = json['length'];
    mapperField = json['mapperField'];
    orgId = json['orgId'];
    required = json['required'];
    sortOrder = json['sortOrder'];
    updateAt = json['updateAt'];
    widgetCode = json['widgetCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applyId'] = this.applyId;
    data['checkRule'] = this.checkRule;
    data['createAt'] = this.createAt;
    data['dataType'] = this.dataType;
    data['dataTypeName'] = this.dataTypeName;
    data['dcId'] = this.dcId;
    data['defaultValue'] = this.defaultValue;
    data['fieldId'] = this.fieldId;
    data['fieldName'] = this.fieldName;
    data['id'] = this.id;
    data['length'] = this.length;
    data['mapperField'] = this.mapperField;
    data['orgId'] = this.orgId;
    data['required'] = this.required;
    data['sortOrder'] = this.sortOrder;
    data['updateAt'] = this.updateAt;
    data['widgetCode'] = this.widgetCode;
    return data;
  }
}
