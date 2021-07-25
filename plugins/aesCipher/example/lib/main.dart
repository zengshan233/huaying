import 'package:aesCipher/aesCipher.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AesCipher.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    A a = A();
    a.test();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            InkWell(
              onTap: () async {
                String encrypt = await AesCipher.encrypt(
                    data: '13019806745', key: 'HYPHONEKEY123456');
                print("encrypt $encrypt");
                String decrypt = await AesCipher.decrypt(
                    data: encrypt, key: 'HYPHONEKEY123456');
                print("decrypt $decrypt");
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.orange,
              ),
            )
          ],
        )),
      ),
    );
  }
}

class S {
  fun() => print('A');
}

class MA extends S {
  fun() {
    super.fun();
    print('执行MA的fun');
    log();
    print('MA');
  }

  log() {
    print('log MA');
  }
}

class MB extends S {
  fun() {
    super.fun();
    print('MB');
  }

  log() {
    print('log MB');
  }
}

class Test {
  void test() {
    print("Test");
  }
}

class TestB {
  void test() {
    print("TestB");
  }
}

class A extends S with Test, TestB {}
