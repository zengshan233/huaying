import 'dart:convert' show json;

class FileUpload {

  int code;
  String msg;
  List<FileUploadItem> data;

  FileUpload.fromParams({this.code, this.msg, this.data});

  factory FileUpload(jsonStr) => jsonStr == null ? null : jsonStr is String ? new FileUpload.fromJson(json.decode(jsonStr)) : new FileUpload.fromJson(jsonStr);
  
  FileUpload.fromJson(jsonRes) {
    code = jsonRes['code'];
    msg = jsonRes['msg'];
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
            data.add(dataItem == null ? null : new FileUploadItem.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"code": $code,"msg": ${msg != null?'${json.encode(msg)}':'null'},"data": $data}';
  }
}

class FileUploadItem {

  int businessType;
  int fileType;
  String bucket;
  String createAt;
  String dcId;
  String directory;
  String fileName;
  String id;
  String innerUrl;
  String orgId;
  String thumbnailName;
  String thumbnailUrl;
  String updateAt;

  FileUploadItem.fromParams({this.businessType, this.fileType, this.bucket, this.createAt, this.dcId, this.directory, this.fileName, this.id, this.innerUrl, this.orgId, this.thumbnailName, this.thumbnailUrl, this.updateAt});
  
  FileUploadItem.fromJson(jsonRes) {
    businessType = jsonRes['businessType'];
    fileType = jsonRes['fileType'];
    bucket = jsonRes['bucket'];
    createAt = jsonRes['createAt'];
    dcId = jsonRes['dcId'];
    directory = jsonRes['directory'];
    fileName = jsonRes['fileName'];
    id = jsonRes['id'];
    innerUrl = jsonRes['innerUrl'];
    orgId = jsonRes['orgId'];
    thumbnailName = jsonRes['thumbnailName'];
    thumbnailUrl = jsonRes['thumbnailUrl'];
    updateAt = jsonRes['updateAt'];
  }

  @override
  String toString() {
    return '{"businessType": $businessType,"fileType": $fileType,"bucket": ${bucket != null?'${json.encode(bucket)}':'null'},"createAt": ${createAt != null?'${json.encode(createAt)}':'null'},"dcId": ${dcId != null?'${json.encode(dcId)}':'null'},"directory": ${directory != null?'${json.encode(directory)}':'null'},"fileName": ${fileName != null?'${json.encode(fileName)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"innerUrl": ${innerUrl != null?'${json.encode(innerUrl)}':'null'},"orgId": ${orgId != null?'${json.encode(orgId)}':'null'},"thumbnailName": ${thumbnailName != null?'${json.encode(thumbnailName)}':'null'},"thumbnailUrl": ${thumbnailUrl != null?'${json.encode(thumbnailUrl)}':'null'},"updateAt": ${updateAt != null?'${json.encode(updateAt)}':'null'}}';
  }
}

