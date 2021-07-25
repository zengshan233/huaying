library oss_dart;

/// A Calculator.
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'utils.dart';

/// OSS Client
class OssClient {
  String endpoint;
  Function tokenGetter; //获取临时账号
  Map<String, String> headers = {}; //请求的header
  String url;
  String method;
  Map params = {};
  String accessKey; //sts账号
  String accessSecret; //sts账号密码s
  String secureToken; //sts账号token
  String expire; //过期时间
  String bucketName = '';
  String fileKey;
  OssClient({this.endpoint, this.bucketName, this.tokenGetter});

  bool _checkExpire(String expire) {
    if (expire == null) {
      return false;
    }
    final expireIn = DateTime.parse(expire).toLocal();
    if (new DateTime.now().compareTo(expireIn) > 0) {
      return true;
    }
    return false;
  }

  String _createXml(List completeParts) {
    var xml =
        '<?xml version="1.0" encoding="UTF-8"?>\n<CompleteMultipartUpload>\n';
    for (var i = 0; i < completeParts.length; i++) {
      xml += '<Part>\n';
      xml += '<PartNumber>${i + 1}</PartNumber>\n';
      xml += '<ETag>${completeParts[i]}</ETag>\n';
      xml += '</Part>\n';
    }
    xml += '</CompleteMultipartUpload>';
    return xml;
  }

  //初始化获取sts账号，如果账号已存在，检查是否过期，如果过期重新获取
  Future init() async {
    if (this.tokenGetter == null) {
      throw Exception('必须先获取临时账号');
    }
    if (expire == null || _checkExpire(expire)) {
      Map stsInfo = await this.tokenGetter();
      this.accessKey = stsInfo['accessKeyId'];
      this.accessSecret = stsInfo['accessKeySecret'];
      this.secureToken = stsInfo['securityToken'];
      this.expire = stsInfo['expiration'];
    }
  }

  /// 上传文件
  /// @param fileData type:List<int> data of upload file
  /// @param bucketName type:String name of bucket
  /// @param fileKey type:String upload filename
  Future<Response> putObject(List<int> fileData, String fileKey,
      [Map header]) async {
    await init();
    this.headers = {
      'content-md5': md5File(fileData),
      'content-type': 'application/octet-stream'
    };
    if (header != null) {
      for (var key in header.keys) {
        headers[key] = header[key];
      }
    }
    this.method = 'PUT';
    this.fileKey = fileKey;
    _signRequest();
    return await http.put(Uri.parse(url), headers: headers, body: fileData);
  }

  //初始化分片上传
  // @param fileKey type:String upload filename
  initiateMultipartUpload(String fileKey) async {
    await init();
    this.method = 'POST';
    this.fileKey = fileKey;
    _signRequest();
    return await http.post(Uri.parse(url), headers: headers);
  }

  //上传分片
  // @param fileData type:List<int> data of upload file
  // @param uploadId type:String name of multiUpload
  // @param fileKey type:String upload filename
  uploadPart(
      List<int> fileData, String fileKey, String uploadId, num partNum) async {
    return putObject(
        fileData, '$fileKey?partNumber=$partNum&uploadId=$uploadId');
  }

  //完成分片上传
  // @param etags type:List 所有分片的tag，按上传编号排序
  // @param uploadId type:String name of multiUpload
  // @param fileKey type:String upload filename
  completeMultipartUpload(List etags, String fileKey, String uploadId) async {
    await init();
    String xml = _createXml(etags);
    var bytes = Uint8List.fromList(xml.codeUnits);
    this.headers['content-md5'] = md5File(bytes);
    this.method = 'POST';
    this.fileKey = '$fileKey?uploadId=$uploadId';
    _signRequest();
    return await http.post(Uri.parse(url), headers: headers, body: bytes);
  }

  //列举指定Upload ID所属的所有已经上传成功Part
  // @param uploadId type:String name of multiUpload
  // @param fileKey type:String upload filename
  listParts(String fileKey, String uploadId) async {
    await init();
    this.method = 'GET';
    this.fileKey = '$fileKey?uploadId=$uploadId';
    _signRequest();
    return await http.get(Uri.parse(url), headers: headers);
  }

  //下载文件
  // @param fileKey type:String upload filename
  getObject(String fileKey) async {
    await init();
    this.method = 'GET';
    this.fileKey = fileKey;
    _signRequest();
    return await http.get(Uri.parse(url), headers: headers);
  }

  static const _subresource_key_set = [
    'response-content-type',
    'response-content-language',
    'response-cache-control',
    'logging',
    'response-content-encoding',
    'acl',
    'uploadId',
    'uploads',
    'partNumber',
    'group',
    'link',
    'delete',
    'website',
    'location',
    'objectInfo',
    'objectMeta',
    'response-expires',
    'response-content-disposition',
    'cors',
    'lifecycle',
    'restore',
    'qos',
    'referer',
    'stat',
    'bucketInfo',
    'append',
    'position',
    'security-token',
    'live',
    'comp',
    'status',
    'vod',
    'startTime',
    'endTime',
    'x-oss-process',
    'symlink',
    'callback',
    'callback-var',
    'tagging',
    'encryption',
    'versions',
    'versioning',
    'versionId',
    'policy'
  ];
  //签名url
  void _signRequest() {
    this.url = "https://$bucketName.$endpoint/$fileKey";
    headers['date'] = httpDateNow();
    if (this.secureToken != null) {
      headers['x-oss-security-token'] = this.secureToken;
    }
    final signature = this._makeSignature();
    headers['authorization'] = "OSS ${this.accessKey}:$signature";
  }

  String _makeSignature() {
    final stringToSign = this._getStringToSign();
    print('this.accessSecret ${this.accessSecret}');
    print('stringToSign ${stringToSign}');
    return hmacSign(this.accessSecret, stringToSign);
  }

  String _getStringToSign() {
    final resourceString = this._getResourceString();
    final headersString = this._getHeadersString();
    final contentMd5 = headers['content-md5'] ?? '';
    final contentType = headers['content-type'] ?? '';
    final date = headers['date'];
    return "$method\n$contentMd5\n$contentType\n$date\n$headersString$resourceString";
  }

  String _getResourceString() {
    if (bucketName == '') {
      return "/";
    } else {
      final substring = this._getSubresourceString();
      return "/$bucketName/$fileKey$substring";
    }
  }

  String _getHeadersString() {
    var canonHeaders = [];
    for (final key in headers.keys) {
      if (key.toLowerCase().startsWith('x-oss-')) {
        canonHeaders.add(key.toLowerCase());
      }
    }
    canonHeaders.sort((s1, s2) {
      return s1.compareTo(s2);
    });
    if (canonHeaders.length > 0) {
      final headerStrings = canonHeaders.map((key) {
        final v = headers[key];
        return "$key:$v";
      }).join("\n");
      return "$headerStrings\n";
    } else {
      return '';
    }
  }

  String _getSubresourceString() {
    if ((params ?? {}).isNotEmpty) {
      return '';
    }
    var subresourceParams = [];
    for (final key in params.keys) {
      if (_subresource_key_set.contains(key)) {
        subresourceParams.add([key, params[key]]);
      }
    }
    subresourceParams.sort((item1, item2) {
      return item1[0].compareTo(item2[0]);
    });
    if (subresourceParams.length > 0) {
      final seqs = subresourceParams.map((arr) {
        final k = arr[0];
        final v = arr[1];
        if (v != null && v != '') {
          return "$k=$v";
        } else {
          return k;
        }
      });
      final paramstring = seqs.join('&');
      return "?$paramstring";
    } else {
      return '';
    }
  }
}
