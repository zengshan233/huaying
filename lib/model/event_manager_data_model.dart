import 'dart:convert' show json;

/// 反馈事件状态
enum EventStatus {
  /// 初始化状态
  Idle,
  /// 1 未处理
  Untreated,
  /// 2 处理中（已回复）
  Pending,
  /// 3 已处理
  Done,
}

/// 反馈事件状态-字符串
String eventStatusStr(EventStatus status) {
  switch (status) {
    case EventStatus.Untreated:
      return "未处理";
    case EventStatus.Pending:
      return "处理中";
    case EventStatus.Done:
      return "已处理";
    default:
      return "";
  }
}

/// 反馈事件类型
enum EventFeedbackType {
  /// 初始化状态
  Idle,
  /// 1 客户反馈
  Message,
  /// 2 投诉
  Complaint,
  /// 3 物流异常
  Anomaly,
}

/// 反馈事件类型-字符串
String eventFeedbackTypeStr(EventFeedbackType type) {
  switch (type) {
    case EventFeedbackType.Message:
      return "客户反馈";
    case EventFeedbackType.Complaint:
      return "事件投诉";
    case EventFeedbackType.Anomaly:
      return "物流异常事件";
    default:
      return "";
  }
}

class EventFeedbackListModel {
  int pageCount;
  int pageNumber;
  int pageSize;
  int rowsCount;
  List<EventFeedback> records;

  EventFeedbackListModel.fromParams(
      {this.pageCount,
      this.pageNumber,
      this.pageSize,
      this.rowsCount,
      this.records});

  factory EventFeedbackListModel(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new EventFeedbackListModel.fromJson(json.decode(jsonStr))
          : new EventFeedbackListModel.fromJson(jsonStr);

  EventFeedbackListModel.fromJson(jsonRes) {
    pageCount = jsonRes['pageCount'];
    pageNumber = jsonRes['pageNumber'];
    pageSize = jsonRes['pageSize'];
    rowsCount = jsonRes['rowsCount'];
    records = jsonRes['records'] == null ? null : [];

    for (var recordsItem in records == null ? [] : jsonRes['records']) {
      records.add(
          recordsItem == null ? null : new EventFeedback.fromJson(recordsItem));
    }
  }

  @override
  String toString() {
    return '{"pageCount": $pageCount,"pageNumber": $pageNumber,"pageSize": $pageSize,"rowsCount": $rowsCount,"records": $records}';
  }
}


class EventFeedback {
  String id;
  String contactId;
  int finalHandleId;
  int handleStatus;
  String hospitalId;
  int status;
  int type;
  String backText;
  String codeNo;
  String contactName;
  String contactPhone;
  String finalHandleName;
  String hospitalName;
  String remark;
  List<EventImage> images;
  String backTime;
  String finalHandleTime;
  String dcId;
  String orgId;

  EventFeedback.fromParams(
      {
        this.id,
        this.contactId,
      this.finalHandleId,
      this.handleStatus,
      this.hospitalId,
      this.status,
      this.type,
      this.backText,
      this.codeNo,
      this.contactName,
      this.contactPhone,
      this.finalHandleName,
      this.hospitalName,
      this.remark,
      this.images,
      this.backTime,
      this.finalHandleTime,
	  this.dcId,
	  this.orgId});

  factory EventFeedback(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new EventFeedback.fromJson(json.decode(jsonStr))
          : new EventFeedback.fromJson(jsonStr);

  EventFeedback.fromJson(jsonRes) {
    id = jsonRes['id'];
    contactId = jsonRes['contactId'];
    finalHandleId = jsonRes['finalHandleId'];
    handleStatus = jsonRes['handleStatus'];
    hospitalId = jsonRes['hospitalId'];
    status = jsonRes['status'];
    type = jsonRes['type'];
    backText = jsonRes['backText'];
    codeNo = jsonRes['codeNo'];
    contactName = jsonRes['contactName'];
    contactPhone = jsonRes['contactPhone'];
    finalHandleName = jsonRes['finalHandleName'];
    hospitalName = jsonRes['hospitalName'];
    remark = jsonRes['remark'];
    images = jsonRes['images'] == null ? null : [];

    for (var imagesItem in images == null ? [] : jsonRes['images']) {
      images
          .add(imagesItem == null ? null : new EventImage.fromJson(imagesItem));
    }

    backTime = jsonRes['backTime'];
    finalHandleTime = jsonRes['finalHandleTime'];
	dcId = jsonRes['dcId'];
	orgId = jsonRes['orgId'];
  }

  @override
  String toString() {
    return '{"id": $id, "contactId": $contactId,"finalHandleId": $finalHandleId,"handleStatus": $handleStatus,"hospitalId": $hospitalId,"status": $status,"type": $type,"backText": ${backText != null ? '${json.encode(backText)}' : 'null'},"codeNo": ${codeNo != null ? '${json.encode(codeNo)}' : 'null'},"contactName": ${contactName != null ? '${json.encode(contactName)}' : 'null'},"contactPhone": ${contactPhone != null ? '${json.encode(contactPhone)}' : 'null'},"finalHandleName": ${finalHandleName != null ? '${json.encode(finalHandleName)}' : 'null'},"hospitalName": ${hospitalName != null ? '${json.encode(hospitalName)}' : 'null'},"remark": ${remark != null ? '${json.encode(remark)}' : 'null'},"images": $images,"backTime": $backTime,"finalHandleTime": $finalHandleTime, "dcId": $dcId, "orgId": $orgId}';
  }

  Map<String, dynamic> toJson(){
    List<Map<String,dynamic>> jsonImages = [];
    images.forEach((item){
      jsonImages.add(item.toJson());
    });
    return {
      'id': id,
      'contactId': contactId,
      'finalHandleId': finalHandleId,
      'handleStatus': handleStatus,
      'hospitalId': hospitalId,
      'hospitalName': hospitalName,
      'status':status,
      'type':type,
      'backText':backText,
      'codeNo':codeNo,
      'contactName':contactName,
      'contactPhone':contactPhone,
      'finalHandleName':finalHandleName,
      'remark':remark,
      'backTime': backTime,
      'finalHandleTime': finalHandleTime,
      'images':jsonImages,
    };
  }
}

class EventImage {
  String id;
	String dcId;
  String orgId;
  String customerBackId;
  String imageId;
  int status;
  String imageName;
  String imageUrl;
  String remark;
  String createAt;
  String updateAt;

  EventImage.fromParams(
      {this.customerBackId,
      this.imageId,
      this.status,
      this.imageName,
      this.imageUrl,
      this.remark,
      this.id,
      this.createAt,
      this.updateAt});

  EventImage.fromJson(jsonRes) {
	  dcId = jsonRes['dcId'];
    orgId = jsonRes['orgId'];
    customerBackId = jsonRes['customerBackId'];
    imageId = jsonRes['imageId'];
    status = jsonRes['status'];
    imageName = jsonRes['imageName'];
    imageUrl = jsonRes['imageUrl'];
    remark = jsonRes['remark'];
    id = jsonRes['id'];
    createAt = jsonRes['createAt'];
    updateAt = jsonRes['updateAt'];
  }

  factory EventImage(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new EventImage.fromJson(json.decode(jsonStr))
          : new EventImage.fromJson(jsonStr);

  @override
  String toString() {
    return '{"dcId": $dcId,"orgId": $orgId, "customerBackId": $customerBackId,"imageId": $imageId,"status": $status,"imageName": ${imageName != null ? '${json.encode(imageName)}' : 'null'},"imageUrl": ${imageUrl != null ? '${json.encode(imageUrl)}' : 'null'},"remark": ${remark != null ? '${json.encode(remark)}' : 'null'}}';
  }

  Map<String, dynamic> toJson() => 
  {
    'customerBackId':customerBackId,
    'imageId':imageId,
    'status':status,
    'imageName':imageName,
    'imageUrl':imageUrl,
    'remark':remark,
	'dcId':dcId,
    'orgId':orgId,
  };
}

class EventReply {

  String dcId;
  String orgId;
  String backId;
  String backName;
  String backText;
  String backTime;
  String createAt;
  String customerBackId;
  String id;
  String remark;
  String status;
  String updateAt;

  EventReply.fromParams({this.dcId, this.orgId, this.backId, this.backName, this.backText, this.backTime, this.createAt, this.customerBackId, this.id, this.remark, this.status, this.updateAt});
  
  EventReply.fromJson(jsonRes) {
    dcId = jsonRes['dcId'];
    orgId = jsonRes['orgId'];
    backId = jsonRes['backId'];
    backName = jsonRes['backName'];
    backText = jsonRes['backText'];
    backTime = jsonRes['backTime'];
    createAt = jsonRes['createAt'];
    customerBackId = jsonRes['customerBackId'];
    id = jsonRes['id'];
    remark = jsonRes['remark'];
    status = jsonRes['status'];
    updateAt = jsonRes['updateAt'];
  }

    factory EventReply(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new EventReply.fromJson(json.decode(jsonStr))
          : new EventReply.fromJson(jsonStr);

  @override
  String toString() {
    return '{"dcId": $dcId,"orgId": $orgId,"backId": ${backId != null?'${json.encode(backId)}':'null'},"backName": ${backName != null?'${json.encode(backName)}':'null'},"backText": ${backText != null?'${json.encode(backText)}':'null'},"backTime": ${backTime != null?'${json.encode(backTime)}':'null'},"createAt": ${createAt != null?'${json.encode(createAt)}':'null'},"customerBackId": ${customerBackId != null?'${json.encode(customerBackId)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"remark": ${remark != null?'${json.encode(remark)}':'null'},"status": ${status != null?'${json.encode(status)}':'null'},"updateAt": ${updateAt != null?'${json.encode(updateAt)}':'null'}}';
  }

  Map<String, dynamic> toJson() => 
  {
    'dcId':dcId,
    'orgId':orgId,
    'backId':backId,
    'backName':backName,
    'backText':backText,
    'backTime':backTime,
	'customerBackId':customerBackId,
  };
}
