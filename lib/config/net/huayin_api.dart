//import 'package:cookie_jar/cookie_jar.dart';
// import 'dart:convert';
// import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import '../router_manger.dart';
import 'api.dart';
//import '../storage_manager.dart';

final Http http = Http();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = FlavorConfig.instance.apiHost;
    interceptors..add(ApiInterceptor());
    if (!FlavorConfig.isProduction()) {
      interceptors
        ..add(LogInterceptor(requestBody: false, responseBody: false)); //开启请求日志
    }
  }
}

/// 玩Android API
class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    handler.next(options);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    //    debugPrint('---api-response--->resp----->${response.data}');
    //debugPrint('响应头：'+response.headers.toString()+'：响应头结束');
    if (response.headers['isRefresh'].toString() == '[true]') {
      MineModel.refreshUser();
    }
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      return handler.resolve(response);
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
  onError(DioError err, ErrorInterceptorHandler handler) async {
    //debugPrint('错误处理：'+(err?.response?.statusCode==401).toString()+'：错误处理结束');
    if (err?.response?.statusCode == 401) {
      bool needRefresh = await MineModel.refreshUser();
      if (!needRefresh) {
        MineModel().clearUser();
        Future.delayed(Duration(seconds: 2), () {
          GlobalConfig.navigatorKey.currentState.pushNamedAndRemoveUntil(
              RouteName.login, (Route<dynamic> route) => false);
        });
      }
    }
    handler.reject(err);
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
