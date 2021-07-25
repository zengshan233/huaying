import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';

class PasswordInput extends StatefulWidget {
  final TextInputType keyType;
  final String imgStr;
  final String hintText;
  final Function change;
  final Widget suffix;
  PasswordInput(
      {this.keyType = TextInputType.text,
      this.imgStr,
      this.hintText,
      this.change,
      this.suffix});
  @override
  State<StatefulWidget> createState() {
    return _PasswordInputState();
  }
}

class _PasswordInputState extends State<PasswordInput> {
  String value = '';
  TextEditingController passwordCon = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// 解决密码类型输入框导致键盘遮住输入框的问题，手动实现密码输入框
    passwordCon.addListener(() {
      final text = passwordCon.text;
      if (text.length > value.length) {
        value = value + text.substring(value.length);
        Future.delayed(Duration(milliseconds: 100)).then((value) {
          String _hideText =
              List.generate(passwordCon.text.length, (index) => '*').join('');
          passwordCon.value = passwordCon.value.copyWith(
            text: _hideText,
            selection: TextSelection(
                baseOffset: text.length, extentOffset: text.length),
            composing: TextRange.empty,
          );
        });
      } else if (text.length < value.length) {
        value = value.substring(0, value.length - 1);
      }
      widget.change(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: ScreenUtil().setHeight(100),
      child: new TextField(
        controller: passwordCon,
        style: TextStyle(
          color: Color.fromRGBO(0, 104, 216, 1),
          fontSize: ScreenUtil().setSp(42),
        ),
        keyboardType: widget.keyType,
        cursorColor: Color.fromRGBO(0, 104, 216, 0.6),
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Color.fromRGBO(190, 190, 190, 1),
              fontSize: ScreenUtil().setSp(38),
            ),
            prefixIcon: Image.asset(
              ImageHelper.wrapAssets(widget.imgStr),
              fit: BoxFit.fitHeight,
            ),
            border: InputBorder.none,
            suffixIcon: widget.suffix),
      ),
    );
  }
}
