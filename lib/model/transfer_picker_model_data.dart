import 'dart:convert' show json;

class TransferPickerData {

  String deliveredTime;
  String deliveryDriver;
  String deliveryDriverId;
  String driverContactNumber;
  String hasImage;
  String images;
  String pickUpTime;
  String signForTime;
  String signatory;
  String signatoryId;
  int specimenAmount;
  int status;
  String boxNo;
  String createAt;
  String dcId;
  String id;
  String logisticsLine;
  String orderNo;
  String orgId;
  String sender;
  String senderId;
  String senderTime;
  String statusName;
  String updateAt;

  TransferPickerData.fromParams({this.deliveredTime, this.deliveryDriver, this.deliveryDriverId, this.driverContactNumber, this.hasImage, this.images, this.pickUpTime, this.signForTime, this.signatory, this.signatoryId, this.specimenAmount, this.status, this.boxNo, this.createAt, this.dcId, this.id, this.logisticsLine, this.orderNo, this.orgId, this.sender, this.senderId, this.senderTime, this.statusName, this.updateAt});

  factory TransferPickerData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TransferPickerData.fromJson(json.decode(jsonStr)) : new TransferPickerData.fromJson(jsonStr);
  
  TransferPickerData.fromJson(jsonRes) {
    deliveredTime = jsonRes['deliveredTime'];
    deliveryDriver = jsonRes['deliveryDriver'];
    deliveryDriverId = jsonRes['deliveryDriverId'];
    driverContactNumber = jsonRes['driverContactNumber'];
    hasImage = jsonRes['hasImage'];
    images = jsonRes['images'];
    pickUpTime = jsonRes['pickUpTime'];
    signForTime = jsonRes['signForTime'];
    signatory = jsonRes['signatory'];
    signatoryId = jsonRes['signatoryId'];
    specimenAmount = jsonRes['specimenAmount'];
    status = jsonRes['status'];
    boxNo = jsonRes['boxNo'];
    createAt = jsonRes['createAt'];
    dcId = jsonRes['dcId'];
    id = jsonRes['id'];
    logisticsLine = jsonRes['logisticsLine'];
    orderNo = jsonRes['orderNo'];
    orgId = jsonRes['orgId'];
    sender = jsonRes['sender'];
    senderId = jsonRes['senderId'];
    senderTime = jsonRes['senderTime'];
    statusName = jsonRes['statusName'];
    updateAt = jsonRes['updateAt'];
  }

  @override
  String toString() {
    return '{"deliveredTime": ${deliveredTime != null?'${json.encode(deliveredTime)}':'null'},"deliveryDriver": ${deliveryDriver != null?'${json.encode(deliveryDriver)}':'null'},"deliveryDriverId": ${deliveryDriverId != null?'${json.encode(deliveryDriverId)}':'null'},"driverContactNumber": ${driverContactNumber != null?'${json.encode(driverContactNumber)}':'null'},"hasImage": ${hasImage != null?'${json.encode(hasImage)}':'null'},"images": ${images != null?'${json.encode(images)}':'null'},"pickUpTime": ${pickUpTime != null?'${json.encode(pickUpTime)}':'null'},"signForTime": ${signForTime != null?'${json.encode(signForTime)}':'null'},"signatory": ${signatory != null?'${json.encode(signatory)}':'null'},"signatoryId": ${signatoryId != null?'${json.encode(signatoryId)}':'null'},"specimenAmount": $specimenAmount,"status": $status,"boxNo": ${boxNo != null?'${json.encode(boxNo)}':'null'},"createAt": ${createAt != null?'${json.encode(createAt)}':'null'},"dcId": ${dcId != null?'${json.encode(dcId)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"logisticsLine": ${logisticsLine != null?'${json.encode(logisticsLine)}':'null'},"orderNo": ${orderNo != null?'${json.encode(orderNo)}':'null'},"orgId": ${orgId != null?'${json.encode(orgId)}':'null'},"sender": ${sender != null?'${json.encode(sender)}':'null'},"senderId": ${senderId != null?'${json.encode(senderId)}':'null'},"senderTime": ${senderTime != null?'${json.encode(senderTime)}':'null'},"statusName": ${statusName != null?'${json.encode(statusName)}':'null'},"updateAt": ${updateAt != null?'${json.encode(updateAt)}':'null'}}';
  }
}

