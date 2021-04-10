import 'package:flutter/material.dart';
import 'package:huayin_logistics/utils/string_utils.dart';

/// APP运行环境
enum Flavor {
  /// 开发环境
  Dev,

  /// 测试环境
  Alpha,

  /// 生产环境
  Prod,

  /// 用户验收测试
  Uat,
}

const String _devUrl = "https://lrp-dev.idaoben.com"; //开发环境

const String _testUrl = "https://lrp-test.huayinlab.com"; //测试环境

const String _prodUrl = "https://lrp.huayinlab.com"; //生产环境

const String _uatUrl = "https://lrpuat.huayinlab.com"; //uat环境

const String _bugly_iOS_dev = "aaabfb9c94"; //异常收集 iOS dev

const String _bugly_android_dev = "22a92692d6"; //异常收集 android dev

const String _bugly_iOS_test = "63bf2466a6"; //异常收集 iOS dev

const String _bugly_android_test = "a8dbdb21d5"; //异常收集 android dev

const String _bugly_iOS_uat = "5e0158c2dc"; //异常收集 iOS dev

const String _bugly_android_uat = "c95cdca96f"; //异常收集 android dev

const String _bugly_iOS_prod = "b7a9c29d7c"; //异常收集 iOS dev

const String _bugly_android_prod = "f01d74e7e9"; //异常收集 android dev


  String getApiHost(Flavor profile) {
    switch (profile) {
      case Flavor.Dev:
        return _devUrl + '/api/web/app';
      case Flavor.Alpha:
        return _testUrl + '/api/web/app';
      case Flavor.Prod:
        return _prodUrl + '/api/web/app';
      case Flavor.Uat:
        return _uatUrl + '/api/web/app';
      default:
        return _devUrl + '/api/web/app';
    }
  }

  String getImgPre(Flavor profile) {
    switch (profile) {
      case Flavor.Dev:
        return _devUrl;
      case Flavor.Alpha:
        return _testUrl;
      case Flavor.Prod:
        return _prodUrl;
      case Flavor.Uat:
        return _uatUrl;
      default:
        return _devUrl;
    }
  }

  String getAppName(Flavor profile) {
    switch (profile) {
      case Flavor.Dev:
        return "华银物流 DEV";
      case Flavor.Alpha:
        return "华银物流 TEST";
      case Flavor.Prod:
        return "华银物流";
      case Flavor.Uat:
        return "华银物流 UAT";
      default:
        return "华银物流";
    }
  }

  Color getColor(Flavor profile) {
    switch (profile) {
      case Flavor.Dev:
        return Colors.redAccent;
      case Flavor.Alpha:
        return Colors.deepPurpleAccent;
      case Flavor.Prod:
        return Colors.blueAccent;
      case Flavor.Uat:
        return Colors.deepOrangeAccent;
      default:
        return Colors.blueAccent;
    }
  }

  String getBuglyiOSID(Flavor profile) {
	  switch (profile) {
      case Flavor.Dev:
        return _bugly_iOS_dev;
      case Flavor.Alpha:
        return _bugly_iOS_test;
      case Flavor.Prod:
        return _bugly_iOS_prod;
      case Flavor.Uat:
        return _bugly_iOS_uat;
      default:
        return _bugly_iOS_dev;
    }
  }

    String getBuglyAndroidID(Flavor profile) {
	  switch (profile) {
      case Flavor.Dev:
        return _bugly_android_dev;
      case Flavor.Alpha:
        return _bugly_android_test;
      case Flavor.Prod:
        return _bugly_android_prod;
      case Flavor.Uat:
        return _bugly_android_uat;
      default:
        return _bugly_android_dev;
    }
  }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String apiHost;
  final String imgPre;
  final String appName;
  final Color color;
  final String buglyiOS;
  final String buglyAndroid;

  static FlavorConfig _instance;

  factory FlavorConfig({
      @required Flavor flavor}) {
    _instance ??= FlavorConfig._internal(
        flavor, StringUtils.enumName(flavor.toString()), getApiHost(flavor), getAppName(flavor), getColor(flavor), getImgPre(flavor), getBuglyAndroidID(flavor), getBuglyiOSID(flavor));
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.apiHost, this.appName, this.color, this.imgPre, this.buglyAndroid,this.buglyiOS);

  static FlavorConfig get instance { return _instance;}

  static bool isProduction() => _instance.flavor == Flavor.Prod;

  static bool isDevelopment() => _instance.flavor == Flavor.Dev;

  static bool isTest() => _instance.flavor == Flavor.Alpha;

  static bool isUat() => _instance.flavor == Flavor.Uat;
}
