import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class OssUploader {
  Dio dio;

  String bucket;

  String endPoint;

  OssUploader({@required this.bucket, @required this.endPoint}) {
    BaseOptions options = new BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      contentType: "application/x-www-form-urlencoded",
    );
    dio = Dio(options);
  }

  Future<String> uploadFile(
      {@required List<String> filePaths,
      @required String ossSecret,
      @required String ossId,
      String ossFolder = 'images',
      String securityToken}) async {
    ///验证文本域 这里设置是过期时间
    String policyText =
        '{"expiration": "2090-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

    ///进行utf8编码
    List<int> policyTextUtf8 = utf8.encode(policyText);

    ///进行base64编码
    String policyBase64 = base64.encode(policyTextUtf8);

    ///再次进行utf8编码
    List<int> policy = utf8.encode(policyBase64);

    String accesskey = ossSecret;

    ///进行utf8 编码
    List<int> key = utf8.encode(accesskey);

    ///通过hmac,使用sha1进行加密
    List<int> signaturePre = new Hmac(sha1, key).convert(policy).bytes;

    ///最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);

    ///dio的请求配置
    dio.options.responseType = ResponseType.plain;
    print('bucket $bucket');
    print('endPoint $endPoint');
    print('urllllllllll ${"https://$bucket.$endPoint"}');
    dio.options.contentType = "multipart/form-data";
    String fileName = filePaths.first.substring(
        filePaths.first.lastIndexOf("/") + 1, filePaths.first.length);
    Map<String, dynamic> params = {
      'key': "$ossFolder/" + 'test',
      'policy': policyBase64,
      'OSSAccessKeyId': ossId,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'file': await MultipartFile.fromFile(filePaths.first, filename: fileName),
    };

    if (securityToken != null) {
      params['x-oss-security-token'] = securityToken;
    }
    print('params $params');

    ///创建一个formdata，作为dio的参数
    FormData data = new FormData.fromMap(params);

    // for (String path in filePaths) {
    //   ///上传到文件名
    //   String fileName = path.substring(path.lastIndexOf("/") + 1, path.length);
    //   data.files.add(MapEntry(
    //     "fileuploads",
    //     await MultipartFile.fromFile(path, filename: fileName),
    //   ));
    // }

    try {
      Response response =
          await dio.post("https://$bucket.$endPoint", data: data);
      if (response.statusCode == 200) {
        print('responsesssssssssss ${response.data}');
        return 'https://';
      } else {
        throw 'network error';
      }
    } on DioError catch (e) {
      print('upload error $e');
      throw e;
    }
  }
}
