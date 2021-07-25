import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:qrcode/qrcode.dart';
import './barcode_scanner.dart';

class ScanPage extends StatefulWidget {
  final Function(String) confirm;
  final bool multi;
  ScanPage({Key key, this.confirm, this.multi = false}) : super(key: key);

  @override
  _ScanPageState createState() => new _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  GlobalKey<QrcodeReaderViewState> _key = GlobalKey();
  List<String> _codes = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: QrcodeReaderView(
        key: _key,
        onScan: onScan,
        initCamera: !widget.multi,
        headerWidget: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }

  Future onScan(String data) async {
    if (widget.multi) {
      PopUtils.showLoading();
      await Future.delayed(Duration(seconds: 2));
      await widget.confirm(data);
      PopUtils.dismiss();
    } else {
      if (_codes.contains(data)) {
        return;
      }
      _codes.add(data);
      Navigator.pop(context);
      widget.confirm(data);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
