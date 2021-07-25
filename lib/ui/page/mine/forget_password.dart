import 'dart:async';

import 'package:aesCipher/aesCipher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/ui/widget/form_check.dart';
import 'package:huayin_logistics/ui/widget/password_input.dart';
import 'package:huayin_logistics/view_model/mine/login_model.dart';
import 'package:provider/provider.dart';

const String PHONE_ENCRPT_KEY = 'HYPHONEKEY123456';
const String PASSWORD_ENCRPT_KEY = 'ABCDEFGABCDEFG12';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPassword createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPassword> {
  bool _sendButtonEnble = true; //发送验证码按钮可点击
  int _sendButtonCount = 60; //点击计时
  String _sendButtonText = "获取验证码"; //发送按钮文字
  Timer _sendButtonTimer;

  String _phoneNumber = ''; //手机号
  String _checkCode = ''; //验证码
  String _password = ''; //新密码
  String _ensurePasswprd = ''; //确认新密码

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _sendButtonTimer?.cancel();
    _sendButtonTimer = null; //销毁计时器
    super.dispose();
  }

  void _initSendButtonTimer() {
    _sendButtonText = '重新获取($_sendButtonCount)';
    _sendButtonTimer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _sendButtonCount--;
      setState(() {
        if (_sendButtonCount > 0) {
          _sendButtonText = '重新获取($_sendButtonCount)';
        } else {
          timer.cancel();
          _sendButtonText = '获取验证码';
          _sendButtonEnble = true;
          _sendButtonCount = 60;
        }
      });
    });
  }

  void _sendButtonClickListen(model) async {
    setState(() {
      if (_sendButtonEnble) {
        // //当按钮可点击时
        _sendButtonEnble = false; //按钮状态标记
        _initSendButtonTimer();
        model.getCheckCode(_phoneNumber).then((value) {
          if (value) {
          } else {
            model.showErrorMessage(context);
          }
        });
        return null; //返回null按钮禁止点击
      } else {
        //当按钮不可点击时
        //        debugPrint('false');
        return null; //返回null按钮禁止点击
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            body: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
                child: new Container(
                  width: ScreenUtil.screenWidth,
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(320)),
                  constraints:
                      BoxConstraints(minHeight: ScreenUtil().setHeight(1100)),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.topLeft,
                          image: AssetImage(
                              ImageHelper.wrapAssets('login_bg.png')),
                          fit: BoxFit.fitWidth)),
                  child: new Column(
                    children: <Widget>[_loginIcon(), _inputContent()],
                  ),
                ))));
  }

  //icon及文字
  Widget _loginIcon() {
    return new Container(
        width: ScreenUtil.screenWidth,
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(90)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new PhysicalModel(
                color: Colors.white, //设置背景底色透明
                borderRadius: BorderRadius.all(Radius.circular(14)),
                clipBehavior: Clip.antiAlias, //注意这个属性
                elevation: 2,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.2),
                child: new Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setWidth(200),
                  child: new Image(
                    image: NetworkImage(
                        'http://www.dongdao.net/d/file/logo/2018-04-25/2659ce3f5669af75e07409daee057472.jpg'),
                    fit: BoxFit.contain,
                  ),
                )),
            new Text('欢迎来到 华银物流平台',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(68),
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.6)),
            new Text('赶快登录办公吧',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(38),
                    color: Color.fromRGBO(0, 71, 152, 1))),
            new SizedBox(
              height: ScreenUtil().setHeight(150),
            )
          ],
        ));
  }

  //获取验证码
  void getCheckCode(model) {
    if (!isPhone(_phoneNumber)) {
      showMsgToast('手机号码格式不正确');
    } else {
      _sendButtonClickListen(model);
    }
  }

  //登录框
  Widget _inputContent() {
    return new PhysicalModel(
      color: Colors.white, //设置背景底色透明
      borderRadius: BorderRadius.all(Radius.circular(14)),
      clipBehavior: Clip.antiAlias, //裁剪类型
      elevation: 4,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.2),
      child: new Container(
          width: ScreenUtil().setWidth(944),
          constraints: BoxConstraints(
            minHeight: ScreenUtil().setHeight(1152),
          ),
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(120)),
          child: ProviderWidget<LoginModel>(
              model: LoginModel(Provider.of(context)),
              builder: (context, model, child) => Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(74),
                            vertical: ScreenUtil().setHeight(4)),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(0, 104, 216, 1)))),
                        child: new Text(
                          '找回密码',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(38),
                            color: Color.fromRGBO(0, 104, 216, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _inputFiled(widgtList: [
                        new Stack(
                          children: <Widget>[
                            _inputItem(
                                keyType: TextInputType.phone,
                                hintText: '请输入手机号',
                                imgStr: 'login_phone.png',
                                change: (v) {
                                  _phoneNumber = v.toString();
                                }),
                            new Positioned(
                              right: 0,
                              top: ScreenUtil().setHeight(10),
                              child: new Container(
                                height: ScreenUtil().setHeight(80),
                                child: new FlatButton(
                                  color: _sendButtonEnble
                                      ? Color.fromRGBO(35, 177, 250, 1)
                                      : Colors.grey.withOpacity(0.1),
                                  highlightColor: _sendButtonEnble
                                      ? Colors.blue[700]
                                      : Colors.transparent,
                                  colorBrightness: Brightness.dark,
                                  splashColor: _sendButtonEnble
                                      ? Colors.grey
                                      : Colors.transparent,
                                  child: Text(
                                    _sendButtonText,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(34),
                                        color: _sendButtonEnble
                                            ? Colors.white
                                            : Colors.black.withOpacity(0.4)),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    getCheckCode(model);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        new Container(
                          padding:
                              EdgeInsets.only(top: ScreenUtil().setHeight(150)),
                          child: _inputItem(
                              keyType: TextInputType.number,
                              hintText: '请输入验证码',
                              imgStr: 'login_checkcode.png',
                              change: (v) {
                                _checkCode = v.toString();
                              }),
                        ),
                        new Container(
                          padding:
                              EdgeInsets.only(top: ScreenUtil().setHeight(150)),
                          child: PasswordInput(
                              keyType: TextInputType.text,
                              hintText: '请输入新密码',
                              imgStr: 'login_lock.png',
                              change: (String v) {
                                _password = v.toString();
                              }),
                        ),
                        new Container(
                          padding:
                              EdgeInsets.only(top: ScreenUtil().setHeight(150)),
                          child: PasswordInput(
                              keyType: TextInputType.text,
                              hintText: '请重复输入新密码',
                              imgStr: 'login_lock.png',
                              change: (v) {
                                _ensurePasswprd = v.toString();
                              }),
                        ),
                      ]),
                      _inputButton(model)
                    ],
                  ))),
    );
  }

  //登陆输入框
  Widget _inputFiled({List<Widget> widgtList}) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(72),
          right: ScreenUtil().setWidth(72),
          top: ScreenUtil().setHeight(140)),
      child: new Column(children: widgtList),
    );
  }

  Widget _inputItem(
      {TextInputType keyType = TextInputType.text,
      String imgStr,
      String hintText,
      Function change,
      bool hideText = false,
      Widget suffix}) {
    //print(suffix);
    return new Container(
      height: ScreenUtil().setHeight(100),
      child: new TextField(
        style: TextStyle(
          color: Color.fromRGBO(0, 104, 216, 1),
          fontSize: ScreenUtil().setSp(42),
        ),
        keyboardType: keyType,
        obscureText: hideText,
        cursorColor: Color.fromRGBO(0, 104, 216, 0.6),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color.fromRGBO(190, 190, 190, 1),
              fontSize: ScreenUtil().setSp(38),
            ),
            prefixIcon: Image.asset(
              ImageHelper.wrapAssets(imgStr),
              fit: BoxFit.fitHeight,
            ),
            border: InputBorder.none,
            suffixIcon: suffix),
        onChanged: (v) {
          change(v);
        },
      ),
    );
  }

  //校验输入
  bool _checkLoginInput() {
    bool checkOk = true;
    if (!isPhone(_phoneNumber)) {
      showMsgToast('手机号码格式不正确');
      checkOk = false;
      return null;
    }
    if (!isRequire(_checkCode)) {
      showMsgToast('验证码不能为空');
      checkOk = false;
      return null;
    }
    if (_password.length < 6) {
      showMsgToast('新密码长度不能小于6位');
      checkOk = false;
      return null;
    }
    if (_password != _ensurePasswprd) {
      showMsgToast('两次密码输入不一致');
      checkOk = false;
    }
    return checkOk;
  }

  //登录按钮
  Widget _inputButton(LoginModel model) {
    return new Column(
      children: <Widget>[
        SizedBox(height: ScreenUtil().setHeight(142)),
        new PhysicalModel(
          color: Colors.white, //设置背景底色透明
          borderRadius: BorderRadius.all(Radius.circular(10)),
          clipBehavior: Clip.antiAlias, //注意这个属性
          elevation: 4,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
          child: Container(
            width: ScreenUtil().setWidth(800),
            height: ScreenUtil().setHeight(150),
            decoration: BoxDecoration(
              gradient: LinearGradient(//背景径向渐变
                  colors: [
                Color.fromRGBO(42, 192, 255, 1),
                Color.fromRGBO(35, 177, 250, 1),
                Color.fromRGBO(21, 145, 241, 1)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: FlatButton(
              onPressed: () async {
                if (!_checkLoginInput()) return;
                String _phoneNumberEncrypt = await AesCipher.encrypt(
                    data: _phoneNumber, key: PHONE_ENCRPT_KEY);
                String _passwordEncrypt = await AesCipher.encrypt(
                    data: this._password, key: PASSWORD_ENCRPT_KEY);
                model
                    .fetchModifyPassword(
                        _phoneNumberEncrypt, this._checkCode, _passwordEncrypt)
                    .then((value) {
                  if (value) {
                    var yyDialog;
                    yyDialog = yyNoticeDialog(text: '修改成功');
                    Future.delayed(Duration(seconds: 2), () {
                      dialogDismiss(yyDialog);
                      Navigator.of(context).pop(true);
                    });
                  } else {
                    model.showErrorMessage(context);
                  }
                });
              },
              child: new Text(
                '确认修改',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(46),
                    color: Colors.white,
                    letterSpacing: 1),
              ),
            ),
          ),
        ),
        new Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
          child: new FlatButton(
            child: new Text(
              '返回',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(38),
                  color: Color.fromRGBO(190, 190, 190, 1)),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        )
      ],
    );
  }
}
