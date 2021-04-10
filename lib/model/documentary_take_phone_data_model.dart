import 'dart:convert' show json;

class DocumentaryTakePhoneDataModel {

  List<DocumentaryTakePhoneDataModelImgItem> images;
  Map<String, dynamic> apply;

  DocumentaryTakePhoneDataModel.fromParams({this.images, this.apply});

  factory DocumentaryTakePhoneDataModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new DocumentaryTakePhoneDataModel.fromJson(json.decode(jsonStr)) : new DocumentaryTakePhoneDataModel.fromJson(jsonStr);
  
  DocumentaryTakePhoneDataModel.fromJson(jsonRes) {
    images = jsonRes['images'] == null ? null : [];

    for (var imagesItem in images == null ? [] : jsonRes['images']){
            images.add(imagesItem == null ? null : new DocumentaryTakePhoneDataModelImgItem.fromJson(imagesItem));
    }

    apply = jsonRes['apply'];
  }

  @override
  String toString() {
    return '{"images": $images,"apply": ${apply != null?'${json.encode(apply)}':'null'}}';
  }
}

class DocumentaryTakePhoneDataModelImgItem {

  String name;
  String url;
  String id;
  String fileId;

  DocumentaryTakePhoneDataModelImgItem.fromParams({this.name, this.url,this.id,this.fileId});
  
  DocumentaryTakePhoneDataModelImgItem.fromJson(jsonRes) {
    name = jsonRes['name'];
    url = jsonRes['url'];
	id = jsonRes['id'];
	fileId = jsonRes['fileId'];
  }

  @override
  String toString() {
    return '{"name": ${name != null?'${json.encode(name)}':'null'},"fileId": ${fileId != null?'${json.encode(fileId)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'}}';
  }
}

