class OssSts {
  String requestId;
  Credentials credentials;
  AssumedRoleUser assumedRoleUser;
  String bucket;
  String endpoint;

  OssSts(
      {this.requestId,
      this.credentials,
      this.assumedRoleUser,
      this.bucket,
      this.endpoint});

  OssSts.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    credentials = json['credentials'] != null
        ? new Credentials.fromJson(json['credentials'])
        : null;
    assumedRoleUser = json['assumedRoleUser'] != null
        ? new AssumedRoleUser.fromJson(json['assumedRoleUser'])
        : null;
    bucket = json['bucket'];
    endpoint = json['endpoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    if (this.credentials != null) {
      data['credentials'] = this.credentials.toJson();
    }
    if (this.assumedRoleUser != null) {
      data['assumedRoleUser'] = this.assumedRoleUser.toJson();
    }
    data['bucket'] = this.bucket;
    data['endpoint'] = this.endpoint;
    return data;
  }
}

class Credentials {
  String securityToken;
  String accessKeySecret;
  String accessKeyId;
  String expiration;

  Credentials(
      {this.securityToken,
      this.accessKeySecret,
      this.accessKeyId,
      this.expiration});

  Credentials.fromJson(Map<String, dynamic> json) {
    securityToken = json['securityToken'];
    accessKeySecret = json['accessKeySecret'];
    accessKeyId = json['accessKeyId'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['securityToken'] = this.securityToken;
    data['accessKeySecret'] = this.accessKeySecret;
    data['accessKeyId'] = this.accessKeyId;
    data['expiration'] = this.expiration;
    return data;
  }
}

class AssumedRoleUser {
  String arn;
  String assumedRoleId;

  AssumedRoleUser({this.arn, this.assumedRoleId});

  AssumedRoleUser.fromJson(Map<String, dynamic> json) {
    arn = json['arn'];
    assumedRoleId = json['assumedRoleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['arn'] = this.arn;
    data['assumedRoleId'] = this.assumedRoleId;
    return data;
  }
}
