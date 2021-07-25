import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/ui/widget/barcode_scanner.dart';
import 'package:huayin_logistics/ui/widget/scanner.dart';
import 'package:permission_handler/permission_handler.dart';

enum BuildMode { DEBUG, PROFILE, RELEASE }

class DeviceUtils {
  static BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.RELEASE;
    }
    var result = BuildMode.PROFILE;
    //Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.DEBUG;
      return true;
    }());
    return result;
  }

  static Future<AndroidDeviceInfo> androidDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.androidInfo;
  }

  static Future<IosDeviceInfo> iosDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.iosInfo;
  }

  static scanBarcode(
      {Function(String) confirm, bool multi = false, Function pop}) async {
    bool cameraPermission = await canOpenCamera();
    if (!cameraPermission) {
      return null;
    }
    Navigator.push(
        GlobalConfig.navigatorKey.currentState.overlay.context,
        MaterialPageRoute(
            builder: (_) => ScanPage(
                  multi: multi,
                  confirm: (code) {
                    if (code != null) {
                      confirm?.call(code);
                    }
                  },
                ))).then((value) => pop?.call());
  }

  static Future<bool> canOpenCamera() async {
    var camera =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    var storage = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (camera != PermissionStatus.granted ||
        storage != PermissionStatus.granted) {
      var future = await PermissionHandler().requestPermissions(
          [PermissionGroup.camera, PermissionGroup.storage]);
      for (final item in future.entries) {
        if (item.value != PermissionStatus.granted) {
          return false;
        }
      }
    } else {
      return true;
    }
    return true;
  }
}
