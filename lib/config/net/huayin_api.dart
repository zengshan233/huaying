//import 'package:cookie_jar/cookie_jar.dart';
// import 'dart:convert';
// import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
//import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/config/storage_manager.dart';
import 'package:huayin_logistics/model/login_data_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'api.dart';
//import '../storage_manager.dart';

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = FlavorConfig.instance.apiHost;
    interceptors..add(ApiInterceptor());
    // cookie持久化 异步
    //   ..add(CookieManager(
    //       PersistCookieJar(dir: StorageManager.temporaryDirectory.path)));
    if (!FlavorConfig.isProduction()) {
      interceptors
        ..add(LogInterceptor(requestBody: true, responseBody: true)); //开启请求日志
    }
  }
}

/// 玩Android API
class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' data: ${options.data}');
    //    debugPrint('---api-request--->data--->${options.data}');
    return options;
  }

  @override
  onResponse(Response response) {
    //    debugPrint('---api-response--->resp----->${response.data}');
    //debugPrint('响应头：'+response.headers.toString()+'：响应头结束');
    if (response.headers['isrefresh'].toString() == '[true]') {
      //debugPrint('需要更新token');
      var userMap = StorageManager.localStorage.getItem('userInfo');

      userMap['token'] = response.headers['token'][0].toString();
      if (userMap['user'] is User) {
        userMap['user'] = userMap['user'].toJson();
      }
      //debugPrint(userMap.toString());
      LoginDataModel userinfo = LoginDataModel.fromJson(userMap);
      MineModel().saveUser(userinfo);
    }
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      return http.resolve(response);
    } else {
      if (respData.code == 401) {
        // 如果cookie过期,需要清除本地存储的登录信息
        // StorageManager.localStorage.deleteItem(UserModel.keyUser);
        throw const UnAuthorizedException(); // 需要登录
      } else {
        throw NotSuccessException.fromRespData(respData);
      }
    }
  }

  @override
  onError(DioError err) async {
    //debugPrint('错误处理：'+(err?.response?.statusCode==401).toString()+'：错误处理结束');
    if (err?.response?.statusCode == 401) {
      MineModel().clearUser();
      Future.delayed(Duration(seconds: 2), () {
        GlobalConfig.navigatorKey.currentState.pushNamedAndRemoveUntil(
            RouteName.login, (Route<dynamic> route) => false);
      });
    }
    return err;
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 0 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['msg'];
    data = json['data'];
  }
}
