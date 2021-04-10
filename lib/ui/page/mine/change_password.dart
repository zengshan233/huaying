import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/provider/provider_widget.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/notice_dialog.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'package:huayin_logistics/view_model/mine/login_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String _password = ''; //手机号
  String _newPassword = ''; //新密码
  String _ensurePasswprd = ''; //确认新密码

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return GestureDetector(
			behavior: HitTestBehavior.translucent,
			onTap: () {
				// 触摸收起键盘
				FocusScope.of(context).requestFocus(FocusNode());
			},
			child:
    
    
    Scaffold(
      appBar: appBarComon(context,text:'修改密码'),
      body: SingleChildScrollView(
        child: new Container(
            width: ScreenUtil.screenWidth,
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(320),
                bottom: ScreenUtil().setHeight(30)),
            constraints:
                BoxConstraints(minHeight: ScreenUtil().setHeight(1100)),
            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topLeft,
                    image: AssetImage(ImageHelper.wrapAssets('login_bg.png')),
                    fit: BoxFit.fitWidth)),
            child: ProviderWidget<LoginModel>(
              model: LoginModel(Provider.of<MineModel>(context)),
              builder: (context, model, child) => Column(
                children: <Widget>[
                  _mineHeader(model.mineModel),
                  _mineNavList(listWidget: [
                    _mineNavItem(
                        img: 'mine_lIcon02.png',
                        text: '修改密码',
                        needBorder: true,
                        clickListener: () {}),
                    _inputItem(
                        keyType: TextInputType.visiblePassword,
                        hintText: '请输入旧密码',
                        hideText: true,
                        change: (v) {
                          setState(() {
                            _password = v.toString();
                          });
                        }),
                    _inputItem(
                        keyType: TextInputType.visiblePassword,
                        hintText: '请输入新密码',
                        hideText: true,
                        change: (v) {
                          setState(() {
                            _newPassword = v.toString();
                          });
                        }),
                    _inputItem(
                        keyType: TextInputType.visiblePassword,
                        hintText: '请重复输入新密码',
                        hideText: true,
                        change: (v) {
                          setState(() {
                            _ensurePasswprd = v.toString();
                          });
                        })
                  ]),
                  new SizedBox(
                    height: ScreenUtil().setHeight(60),
                  ),
                  gradualButton('确定', onTap: () {
                    if (!_checkLoginInput()) return;
                    if (!model.checkLoginEnable()) {
                      showMsgToast('密码错误超过3次，请一分钟后再尝试');
                      return;
                    }
                    model
                        .changePassword(
                            model.mineModel.user.user.phoneNumber,
                            _password,
                            _newPassword,
                            model.mineModel.user.user.id,
                            model.mineModel.user.accountName)
                        .then((value) {
                      if (value) {
                        var yyDialog;
                        yyDialog = yyNoticeDialog(text: '修改成功');
                        Future.delayed(Duration(seconds: 1), () {
                          dialogDismiss(yyDialog);
                          Navigator.pushNamedAndRemoveUntil(context,
                              RouteName.login, (Route<dynamic> route) => false);
                        });
                      } else {
                        model.showErrorMessage(context);
                      }
                    });
                  })
                ],
              ),
            )),
      ),
    ));
  }

  //头像账号
  Widget _mineHeader(MineModel model) {
    var headerUrl = '';
    if (model.user?.user?.gender != null) {
      switch (model.user.user.gender.toString()) {
        case '1':
          headerUrl = 'mine_male_header.png';
          break;
        case '2':
          headerUrl = 'mine_female_header.png';
          break;
        default:
          headerUrl = 'mine_unknow_header.png';
          break;
      }
    } else {
      headerUrl = 'mine_unknow_header.png';
    }
    return new Container(
      width: ScreenUtil.screenWidth,
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(90)),
      child: new Row(
        children: <Widget>[
          new PhysicalModel(
            shape: BoxShape.circle,
            color: Colors.white,
            clipBehavior: Clip.antiAlias, //注意这个属性
            elevation: 4,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
            child: new Container(
              width: ScreenUtil().setWidth(194),
              height: ScreenUtil().setWidth(194),
              padding: EdgeInsets.all(4),
              child: new Image.asset(ImageHelper.wrapAssets(headerUrl),
                  fit: BoxFit.fitHeight),
            ),
          ),
          new Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                    model.user == null
                        ? '未登录'
                        : model.user?.user == null
                            ? 'null'
                            : model.user?.user?.name,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(60), color: Colors.white)),
                new Text('账号：${model.user?.accountName ?? '--'}',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: Color.fromRGBO(0, 71, 152, 1),
                        height: 1.6))
              ],
            ),
          )
        ],
      ),
    );
  }

  //导航列表
  Widget _mineNavList({List<Widget> listWidget}) {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(42)),
      child: new PhysicalModel(
        color: Colors.white, //设置背景底色透明
        borderRadius: BorderRadius.all(Radius.circular(14)),
        clipBehavior: Clip.antiAlias, //裁剪类型
        elevation: 4,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
        child: new Container(
          width: ScreenUtil().setWidth(944),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(38)),
          child: new Column(
            children: listWidget,
          ),
        ),
      ),
    );
  }

  //单个导航
  Widget _mineNavItem(
      {@required String img,
      @required String text,
      Function clickListener,
      bool needBorder = false}) {
    return new Container(
      height: ScreenUtil().setHeight(160), //限制���钮高度
      decoration: BoxDecoration(
        border: Border(
            bottom: needBorder
                ? BorderSide(
                    width: 1 / ScreenUtil.pixelRatio,
                    color: GlobalConfig.borderColor)
                : BorderSide.none),
      ),
      child: new FlatButton(
        padding: EdgeInsets.all(0),
        highlightColor: Colors.transparent,
        //splashColor:Colors.transparent,
        onPressed: () {
          clickListener();
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
                child: new Row(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  child: new Image.asset(
                    ImageHelper.wrapAssets(img),
                    width: ScreenUtil().setHeight(80),
                    height: ScreenUtil().setHeight(80),
                  ),
                ),
                new Text(
                  text,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(46),
                      color: Color.fromRGBO(90, 90, 91, 1)),
                )
              ],
            )),
          ],
        ),
      ),
    );
  }

  //校验输入
  bool _checkLoginInput() {
    if (_password.length < 6) {
      showMsgToast('旧密码长度不能小于6位');
      return false;
    }
    if (_newPassword.length < 6) {
      showMsgToast('新密码长度不能小于6位');
      return false;
    }
    if (_newPassword != _ensurePasswprd) {
      showMsgToast('两次密码输入不一致');
      return false;
    }
    return true;
  }

  Widget _inputItem(
      {TextInputType keyType = TextInputType.text,
      String hintText,
      Function change,
      bool hideText = false,
      Widget suffix}) {
    //print(suffix);
    return new Container(
      height: ScreenUtil().setHeight(160), //限制按钮高度
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
            border: InputBorder.none,
            suffixIcon: suffix),
        onChanged: (v) {
          change(v);
        },
      ),
    );
  }
}
