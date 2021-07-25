import 'dart:async';

import 'package:flutter/services.dart';

class AesCipher {
  static const MethodChannel _channel = const MethodChannel('aesCipher');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> encrypt({String data, String key}) async {
    String encrypt =
        await _channel.invokeMethod('encrypt', {"data": data, "key": key});
    print('encrypt $encrypt');
    return encrypt;
  }

  static Future<String> decrypt({String data, String key}) async {
    String decryptData =
        await _channel.invokeMethod('decrypt', {"data": data, "key": key});
    print('decryptData $decryptData');
    return decryptData;
  }
}
