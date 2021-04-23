import 'package:flutter/widgets.dart';

class DeliveryItem {
  final String date;
  final String billno;
  final bool confirm;
  final bool check;
  DeliveryItem({this.date, this.billno, this.confirm, this.check});
}

class SpecimenBoxItem {
  List<String> joinIds;
  String boxNo;
  int boxType;
  bool ice;

  SpecimenBoxItem({this.joinIds, this.boxNo, this.boxType, this.ice = false});

  SpecimenBoxItem.fromJson(Map<String, dynamic> json) {
    joinIds = json['joinIds'].cast<String>();
    boxNo = json['boxNo'];
    boxType = json['boxType'];
    ice = json['ice'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['joinIds'] = this.joinIds;
    data['boxNo'] = this.boxNo;
    data['boxType'] = this.boxType;
    data['ice'] = this.ice;
    return data;
  }
}

class SpecimenJoinItem {
  String boxNo;
  String id;
  List<String> joinIds;

  SpecimenJoinItem({this.id, this.boxNo, this.joinIds});

  SpecimenJoinItem.fromJson(Map<String, dynamic> json) {
    joinIds = json['joinIds'].cast<String>();
    boxNo = json['boxNo'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['joinIds'] = this.joinIds;
    data['id'] = this.id;
    data['boxNo'] = this.boxNo;
    return data;
  }
}

class SpecimenCombinedItem {
  String joinId;
  String boxNo;
  String boxId;

  SpecimenCombinedItem({this.joinId, this.boxNo, this.boxId});

  SpecimenCombinedItem.fromJson(Map<String, dynamic> json) {
    joinId = json['joinId'];
    boxNo = json['boxNo'];
    boxId = json['boxId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['joinId'] = this.joinId;
    data['boxNo'] = this.boxNo;
    data['boxId'] = this.boxId;
    return data;
  }
}

class SpecimenUnusedItem {
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

  SpecimenUnusedItem(
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

  SpecimenUnusedItem.fromJson(Map<String, dynamic> json) {
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

class DeliveryInputItem {
  final String name;
  final TextEditingController controller;
  final Function onTap;
  DeliveryInputItem({this.name, this.controller, this.onTap});
}

class DeliveryDetailModel {
  String dcId;
  String orgId;
  String orderNo;
  String boxNo;
  String recordDate;
  String recordId;
  String recordName;
  int confirmStatus;
  String confirmAt;
  int signForStatus;
  int transportStatus;
  String signForRemark;
  List<Items> items;
  String id;
  String createAt;
  String updateAt;

  DeliveryDetailModel(
      {this.dcId,
      this.orgId,
      this.orderNo,
      this.boxNo,
      this.recordDate,
      this.recordId,
      this.recordName,
      this.confirmStatus,
      this.confirmAt,
      this.signForStatus,
      this.transportStatus,
      this.signForRemark,
      this.items,
      this.id,
      this.createAt,
      this.updateAt});

  DeliveryDetailModel.fromJson(Map<String, dynamic> json) {
    dcId = json['dcId'];
    orgId = json['orgId'];
    orderNo = json['orderNo'];
    boxNo = json['boxNo'];
    recordDate = json['recordDate'];
    recordId = json['recordId'];
    recordName = json['recordName'];
    confirmStatus = json['confirmStatus'];
    confirmAt = json['confirmAt'];
    signForStatus = json['signForStatus'];
    transportStatus = json['transportStatus'];
    signForRemark = json['signForRemark'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    id = json['id'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['orderNo'] = this.orderNo;
    data['boxNo'] = this.boxNo;
    data['recordDate'] = this.recordDate;
    data['recordId'] = this.recordId;
    data['recordName'] = this.recordName;
    data['confirmStatus'] = this.confirmStatus;
    data['confirmAt'] = this.confirmAt;
    data['signForStatus'] = this.signForStatus;
    data['transportStatus'] = this.transportStatus;
    data['signForRemark'] = this.signForRemark;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}

class Items {
  String dcId;
  String orgId;
  String joinId;
  String inspectionUnitId;
  String inspectionUnitName;
  int barcodeTotal;
  String routineSecretion;
  String routineIce;
  String routineSmear;
  String routineMic;
  String routineOther;
  String pathologyTissueSample;
  String pathologyTissueOrder;
  String pathologyTissueTct;
  String pathologySmear;
  String pathologyLiquidSpecimen;
  String pathologySlideGlassConsultation;
  String pathologySlideGlassCooperate;
  String pathologyWaxBlockConsultation;
  String pathologyWaxBlockCooperate;
  String pathologyQfc;
  String pathologyOther;
  int status;
  List<Temperatures> temperatures;
  String id;
  String createAt;
  String updateAt;

  Items(
      {this.dcId,
      this.orgId,
      this.joinId,
      this.inspectionUnitId,
      this.inspectionUnitName,
      this.barcodeTotal,
      this.routineSecretion,
      this.routineIce,
      this.routineSmear,
      this.routineMic,
      this.routineOther,
      this.pathologyTissueSample,
      this.pathologyTissueOrder,
      this.pathologyTissueTct,
      this.pathologySmear,
      this.pathologyLiquidSpecimen,
      this.pathologySlideGlassConsultation,
      this.pathologySlideGlassCooperate,
      this.pathologyWaxBlockConsultation,
      this.pathologyWaxBlockCooperate,
      this.pathologyQfc,
      this.pathologyOther,
      this.status,
      this.temperatures,
      this.id,
      this.createAt,
      this.updateAt});

  Items.fromJson(Map<String, dynamic> json) {
    dcId = json['dcId'];
    orgId = json['orgId'];
    joinId = json['joinId'];
    inspectionUnitId = json['inspectionUnitId'];
    inspectionUnitName = json['inspectionUnitName'];
    barcodeTotal = json['barcodeTotal'];
    routineSecretion = json['routineSecretion'];
    routineIce = json['routineIce'];
    routineSmear = json['routineSmear'];
    routineMic = json['routineMic'];
    routineOther = json['routineOther'];
    pathologyTissueSample = json['pathologyTissueSample'];
    pathologyTissueOrder = json['pathologyTissueOrder'];
    pathologyTissueTct = json['pathologyTissueTct'];
    pathologySmear = json['pathologySmear'];
    pathologyLiquidSpecimen = json['pathologyLiquidSpecimen'];
    pathologySlideGlassConsultation = json['pathologySlideGlassConsultation'];
    pathologySlideGlassCooperate = json['pathologySlideGlassCooperate'];
    pathologyWaxBlockConsultation = json['pathologyWaxBlockConsultation'];
    pathologyWaxBlockCooperate = json['pathologyWaxBlockCooperate'];
    pathologyQfc = json['pathologyQfc'];
    pathologyOther = json['pathologyOther'];
    status = json['status'];
    if (json['temperatures'] != null) {
      temperatures = new List<Temperatures>();
      json['temperatures'].forEach((v) {
        temperatures.add(new Temperatures.fromJson(v));
      });
    }
    id = json['id'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['joinId'] = this.joinId;
    data['inspectionUnitId'] = this.inspectionUnitId;
    data['inspectionUnitName'] = this.inspectionUnitName;
    data['barcodeTotal'] = this.barcodeTotal;
    data['routineSecretion'] = this.routineSecretion;
    data['routineIce'] = this.routineIce;
    data['routineSmear'] = this.routineSmear;
    data['routineMic'] = this.routineMic;
    data['routineOther'] = this.routineOther;
    data['pathologyTissueSample'] = this.pathologyTissueSample;
    data['pathologyTissueOrder'] = this.pathologyTissueOrder;
    data['pathologyTissueTct'] = this.pathologyTissueTct;
    data['pathologySmear'] = this.pathologySmear;
    data['pathologyLiquidSpecimen'] = this.pathologyLiquidSpecimen;
    data['pathologySlideGlassConsultation'] =
        this.pathologySlideGlassConsultation;
    data['pathologySlideGlassCooperate'] = this.pathologySlideGlassCooperate;
    data['pathologyWaxBlockConsultation'] = this.pathologyWaxBlockConsultation;
    data['pathologyWaxBlockCooperate'] = this.pathologyWaxBlockCooperate;
    data['pathologyQfc'] = this.pathologyQfc;
    data['pathologyOther'] = this.pathologyOther;
    data['status'] = this.status;
    if (this.temperatures != null) {
      data['temperatures'] = this.temperatures.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}

class Temperatures {
  String createAt;
  String dcId;
  String id;
  String joinItemId;
  String orgId;
  String recordAt;
  String temperature;
  String updateAt;

  Temperatures(
      {this.createAt,
      this.dcId,
      this.id,
      this.joinItemId,
      this.orgId,
      this.recordAt,
      this.temperature,
      this.updateAt});

  Temperatures.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'];
    dcId = json['dcId'];
    id = json['id'];
    joinItemId = json['joinItemId'];
    orgId = json['orgId'];
    recordAt = json['recordAt'];
    temperature = json['temperature'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createAt'] = this.createAt;
    data['dcId'] = this.dcId;
    data['id'] = this.id;
    data['joinItemId'] = this.joinItemId;
    data['orgId'] = this.orgId;
    data['recordAt'] = this.recordAt;
    data['temperature'] = this.temperature;
    data['updateAt'] = this.updateAt;
    return data;
  }
}

class JoinListItem {
  String dcId;
  String orgId;
  String orderNo;
  String boxNo;
  String recordDate;
  String recordId;
  String recordName;
  int confirmStatus;
  String confirmAt;
  int signForStatus;
  int transportStatus;
  String signForRemark;
  List<Null> items;
  String id;
  String createAt;
  String updateAt;

  JoinListItem(
      {this.dcId,
      this.orgId,
      this.orderNo,
      this.boxNo,
      this.recordDate,
      this.recordId,
      this.recordName,
      this.confirmStatus,
      this.confirmAt,
      this.signForStatus,
      this.transportStatus,
      this.signForRemark,
      this.items,
      this.id,
      this.createAt,
      this.updateAt});

  JoinListItem.fromJson(Map<String, dynamic> json) {
    dcId = json['dcId'];
    orgId = json['orgId'];
    orderNo = json['orderNo'];
    boxNo = json['boxNo'];
    recordDate = json['recordDate'];
    recordId = json['recordId'];
    recordName = json['recordName'];
    confirmStatus = json['confirmStatus'];
    confirmAt = json['confirmAt'];
    signForStatus = json['signForStatus'];
    transportStatus = json['transportStatus'];
    signForRemark = json['signForRemark'];
    items = json['items'];
    id = json['id'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dcId'] = this.dcId;
    data['orgId'] = this.orgId;
    data['orderNo'] = this.orderNo;
    data['boxNo'] = this.boxNo;
    data['recordDate'] = this.recordDate;
    data['recordId'] = this.recordId;
    data['recordName'] = this.recordName;
    data['confirmStatus'] = this.confirmStatus;
    data['confirmAt'] = this.confirmAt;
    data['signForStatus'] = this.signForStatus;
    data['transportStatus'] = this.transportStatus;
    data['signForRemark'] = this.signForRemark;
    data['items'] = this.items;
    data['id'] = this.id;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
