import 'dart:convert' show json;

class SpecimenboxArriveDataModel {

  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<SpecimenboxArriveItem> records;

  SpecimenboxArriveDataModel.fromParams({this.pageCount, this.pageNumber, this.pageSize, this.rowsCount, this.records});

  factory SpecimenboxArriveDataModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new SpecimenboxArriveDataModel.fromJson(json.decode(jsonStr)) : new SpecimenboxArriveDataModel.fromJson(jsonStr);
  
  SpecimenboxArriveDataModel.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']){
            records.add(recordsItem == null ? null : new SpecimenboxArriveItem.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}

class SpecimenboxArriveItem {

  String deliveredTime;
  int specimenAmount;
  int status;
  bool hasImage;
  String boxNo;
  String createAt;
  String dcId;
  String deliveryDriver;
  String deliveryDriverId;
  String driverContactNumber;
  String id;
  String logisticsLine;
  String orderNo;
  String orgId;
  String pickUpTime;
  String sender;
  String senderId;
  String senderTime;
  String signForTime;
  String signatory;
  String signatoryId;
  String statusName;
  String updateAt;
  List<SpecimenboxArriveItemImage> images;

  SpecimenboxArriveItem.fromParams({this.deliveredTime, this.specimenAmount, this.status, this.hasImage, this.boxNo, this.createAt, this.dcId, this.deliveryDriver, this.deliveryDriverId, this.driverContactNumber, this.id, this.logisticsLine, this.orderNo, this.orgId, this.pickUpTime, this.sender, this.senderId, this.senderTime, this.signForTime, this.signatory, this.signatoryId, this.statusName, this.updateAt, this.images});
  
  SpecimenboxArriveItem.fromJson(jsonRes) {
    deliveredTime = jsonRes['deliveredTime'];
    specimenAmount = jsonRes['specimenAmount'];
    status = jsonRes['status'];
    hasImage = jsonRes['hasImage'];
    boxNo = jsonRes['boxNo'];
    createAt = jsonRes['createAt'];
    dcId = jsonRes['dcId'];
    deliveryDriver = jsonRes['deliveryDriver'];
    deliveryDriverId = jsonRes['deliveryDriverId'];
    driverContactNumber = jsonRes['driverContactNumber'];
    id = jsonRes['id'];
    logisticsLine = jsonRes['logisticsLine'];
    orderNo = jsonRes['orderNo'];
    orgId = jsonRes['orgId'];
    pickUpTime = jsonRes['pickUpTime'];
    sender = jsonRes['sender'];
    senderId = jsonRes['senderId'];
    senderTime = jsonRes['senderTime'];
    signForTime = jsonRes['signForTime'];
    signatory = jsonRes['signatory'];
    signatoryId = jsonRes['signatoryId'];
    statusName = jsonRes['statusName'];
    updateAt = jsonRes['updateAt'];
    images = jsonRes['images'] == null ? null : [];

    for (var imagesItem in images == null ? [] : jsonRes['images']){
            images.add(imagesItem == null ? null : new SpecimenboxArriveItemImage.fromJson(imagesItem));
    }
  }

  @override
  String toString() {
    return '{"deliveredTime": ${deliveredTime != null?'${json.encode(deliveredTime)}':'null'},"specimenAmount": $specimenAmount,"status": $status,"hasImage": $hasImage,"boxNo": ${boxNo != null?'${json.encode(boxNo)}':'null'},"createAt": ${createAt != null?'${json.encode(createAt)}':'null'},"dcId": ${dcId != null?'${json.encode(dcId)}':'null'},"deliveryDriver": ${deliveryDriver != null?'${json.encode(deliveryDriver)}':'null'},"deliveryDriverId": ${deliveryDriverId != null?'${json.encode(deliveryDriverId)}':'null'},"driverContactNumber": ${driverContactNumber != null?'${json.encode(driverContactNumber)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"logisticsLine": ${logisticsLine != null?'${json.encode(logisticsLine)}':'null'},"orderNo": ${orderNo != null?'${json.encode(orderNo)}':'null'},"orgId": ${orgId != null?'${json.encode(orgId)}':'null'},"pickUpTime": ${pickUpTime != null?'${json.encode(pickUpTime)}':'null'},"sender": ${sender != null?'${json.encode(sender)}':'null'},"senderId": ${senderId != null?'${json.encode(senderId)}':'null'},"senderTime": ${senderTime != null?'${json.encode(senderTime)}':'null'},"signForTime": ${signForTime != null?'${json.encode(signForTime)}':'null'},"signatory": ${signatory != null?'${json.encode(signatory)}':'null'},"signatoryId": ${signatoryId != null?'${json.encode(signatoryId)}':'null'},"statusName": ${statusName != null?'${json.encode(statusName)}':'null'},"updateAt": ${updateAt != null?'${json.encode(updateAt)}':'null'},"images": $images}';
  }
}

class SpecimenboxArriveItemImage {

  String describe;
  String createAt;
  String dcId;
  String id;
  String name;
  String orgId;
  String relId;
  String updateAt;
  String url;

  SpecimenboxArriveItemImage.fromParams({this.describe, this.createAt, this.dcId, this.id, this.name, this.orgId, this.relId, this.updateAt, this.url});
  
  SpecimenboxArriveItemImage.fromJson(jsonRes) {
    describe = jsonRes['describe'];
    createAt = jsonRes['createAt'];
    dcId = jsonRes['dcId'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    orgId = jsonRes['orgId'];
    relId = jsonRes['relId'];
    updateAt = jsonRes['updateAt'];
    url = jsonRes['url'];
  }

  @override
  String toString() {
    return '{"describe": ${describe != null?'${json.encode(describe)}':'null'},"createAt": ${createAt != null?'${json.encode(createAt)}':'null'},"dcId": ${dcId != null?'${json.encode(dcId)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"orgId": ${orgId != null?'${json.encode(orgId)}':'null'},"relId": ${relId != null?'${json.encode(relId)}':'null'},"updateAt": ${updateAt != null?'${json.encode(updateAt)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'}}';
  }
}

