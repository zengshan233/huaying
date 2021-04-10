import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huayin_logistics/app.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:provider/provider.dart';
import 'config/storage_manager.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

main() async {
  FlavorConfig(flavor: Flavor.Uat);
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  FlutterBugly.init(androidAppId: FlavorConfig.instance.buglyAndroid,iOSAppId: FlavorConfig.instance.buglyiOS);

  FlutterBugly.postCatchedException((){
	runApp(App());
  });
  // Android状态栏透明 splash为白色,所以调整状态栏文字为黑色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
}
