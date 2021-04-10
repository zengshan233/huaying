import 'dart:convert' show json;

class SpecimenStatusInquiryDataModel {

  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<SpecimenStatusInquiryDataModelItem> records;

  SpecimenStatusInquiryDataModel.fromParams({this.pageCount, this.pageNumber, this.pageSize, this.rowsCount, this.records});

  factory SpecimenStatusInquiryDataModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SpecimenStatusInquiryDataModel.fromJson(json.decode(jsonStr)) : new SpecimenStatusInquiryDataModel.fromJson(jsonStr);
  
  SpecimenStatusInquiryDataModel.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']){
            records.add(recordsItem == null ? null : new SpecimenStatusInquiryDataModelItem.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}

class SpecimenStatusInquiryDataModelItem {

  int status;
  String applyDate;
  String applyItems;
  String recordTime;
  String barCode;
  String id;
  String inspectionUnitName;
  String name;
  String sexName;
  String statusName;

  SpecimenStatusInquiryDataModelItem.fromParams({this.status, this.applyDate, this.applyItems, this.recordTime,this.barCode, this.id, this.inspectionUnitName, this.name, this.sexName, this.statusName});

  factory SpecimenStatusInquiryDataModelItem(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SpecimenStatusInquiryDataModelItem.fromJson(json.decode(jsonStr)) : new SpecimenStatusInquiryDataModelItem.fromJson(jsonStr);
  
  SpecimenStatusInquiryDataModelItem.fromJson(jsonRes) {
    status = jsonRes['status'];
    applyDate = jsonRes['applyDate'];
    applyItems = jsonRes['applyItems'];
    barCode = jsonRes['barCode'];
    id = jsonRes['id'];
    inspectionUnitName = jsonRes['inspectionUnitName'];
    name = jsonRes['name'];
    sexName = jsonRes['sexName'];
    statusName = jsonRes['statusName'];
	recordTime = jsonRes['recordTime'];
  }

  @override
  String toString() {
    return '{"status": $status,"applyDate": ${applyDate != null?'${json.encode(applyDate)}':'null'},"recordTime": ${recordTime != null?'${json.encode(recordTime)}':'null'},"applyItems": ${applyItems != null?'${json.encode(applyItems)}':'null'},"barCode": ${barCode != null?'${json.encode(barCode)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"inspectionUnitName": ${inspectionUnitName != null?'${json.encode(inspectionUnitName)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"sexName": ${sexName != null?'${json.encode(sexName)}':'null'},"statusName": ${statusName != null?'${json.encode(statusName)}':'null'}}';
  }
}


class SpecimenStatusInquiryDataModelDetail {

  int status;
  String age;
  String applyDate;
  String applyDoctorName;
  String applyItems;
  String barCode;
  String collectorTime;
  String departmentName;
  String doctorPhone;
  String id;
  String inspectionUnitName;
  String name;
  String outpatientNumber;
  String phone;
  String remark;
  String sexName;
  String sickbedNumber;
  String statusName;
  String visitTypeName;
  String wardName;
  String recordTime;

  SpecimenStatusInquiryDataModelDetail.fromParams({this.status, this.age, this.applyDate, this.applyDoctorName, this.applyItems, this.barCode, this.collectorTime, this.departmentName, this.doctorPhone, this.id, this.inspectionUnitName, this.name, this.outpatientNumber, this.phone, this.remark, this.sexName, this.sickbedNumber, this.statusName, this.visitTypeName, this.wardName,this.recordTime});

  factory SpecimenStatusInquiryDataModelDetail(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SpecimenStatusInquiryDataModelDetail.fromJson(json.decode(jsonStr)) : new SpecimenStatusInquiryDataModelDetail.fromJson(jsonStr);
  
  SpecimenStatusInquiryDataModelDetail.fromJson(jsonRes) {
    status = jsonRes['status'];
    age = jsonRes['age'];
    applyDate = jsonRes['applyDate'];
    applyDoctorName = jsonRes['applyDoctorName'];
    applyItems = jsonRes['applyItems'];
    barCode = jsonRes['barCode'];
    collectorTime = jsonRes['collectorTime'];
    departmentName = jsonRes['departmentName'];
    doctorPhone = jsonRes['doctorPhone'];
    id = jsonRes['id'];
    inspectionUnitName = jsonRes['inspectionUnitName'];
    name = jsonRes['name'];
    outpatientNumber = jsonRes['outpatientNumber'];
    phone = jsonRes['phone'];
    remark = jsonRes['remark'];
    sexName = jsonRes['sexName'];
    sickbedNumber = jsonRes['sickbedNumber'];
    statusName = jsonRes['statusName'];
    visitTypeName = jsonRes['visitTypeName'];
    wardName = jsonRes['wardName'];
	recordTime = jsonRes['recordTime'];
  }

  @override
  String toString() {
    return '{"status": $status,"age": ${age != null?'${json.encode(age)}':'null'},"applyDate": ${applyDate != null?'${json.encode(applyDate)}':'null'},"applyDoctorName": ${applyDoctorName != null?'${json.encode(applyDoctorName)}':'null'},"applyItems": ${applyItems != null?'${json.encode(applyItems)}':'null'},"barCode": ${barCode != null?'${json.encode(barCode)}':'null'},"collectorTime": ${collectorTime != null?'${json.encode(collectorTime)}':'null'},"departmentName": ${departmentName != null?'${json.encode(departmentName)}':'null'},"doctorPhone": ${doctorPhone != null?'${json.encode(doctorPhone)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"inspectionUnitName": ${inspectionUnitName != null?'${json.encode(inspectionUnitName)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"outpatientNumber": ${outpatientNumber != null?'${json.encode(outpatientNumber)}':'null'},"phone": ${phone != null?'${json.encode(phone)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"sexName": ${sexName != null?'${json.encode(sexName)}':'null'},"sickbedNumber": ${sickbedNumber != null?'${json.encode(sickbedNumber)}':'null'},"statusName": ${statusName != null?'${json.encode(statusName)}':'null'},"visitTypeName": ${visitTypeName != null?'${json.encode(visitTypeName)}':'null'},"wardName": ${wardName != null?'${json.encode(wardName)}':'null'},"recordTime": ${recordTime != null?'${json.encode(recordTime)}':'null'}}';
  }
}
