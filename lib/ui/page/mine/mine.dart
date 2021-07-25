import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart'
    show gradualButton;
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

class Mine extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  Map<String, dynamic> _dataAccount = {
    'allApply': 0,
    'toBeServedApply': 0,
    'event': 0
  };

  //获取统计数据
  Future fetchSpecimenEventDataAccountData() async {
    var response = await Repository.fetchSpecimenEventDataAccount();
    if (response != null) {
      response.forEach((String key, dynamic val) {
        if (response[key] != null) {
          _dataAccount[key] = val;
        }
      });
      setState(() {
        _dataAccount = _dataAccount;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSpecimenEventDataAccountData();
    // WidgetsBinding.instance.addPostFrameCallback((callback){
    // 	fetchSpecimenEventDataAccountData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Consumer<MineModel>(
              builder: (context, model, child) => Column(
                children: <Widget>[
                  _mineHeader(model),
                  _mineData(),
                  _mineNavList(listWidget: [
                    _mineNavItem(
                        img: 'mine_lIcon01.png',
                        text: '个人信息',
                        needBorder: true,
                        clickListener: () {
                          Navigator.pushNamed(context, RouteName.userInfo);
                        }),
                    _mineNavItem(
                        img: 'mine_lIcon02.png',
                        text: '修改密码',
                        clickListener: () {
                          Navigator.pushNamed(
                              context, RouteName.changePassword);
                        })
                  ]),
                  _mineNavList(listWidget: [
                    _mineNavItem(
                        img: 'mine_lIcon03.png',
                        text: '帮助中心',
                        needBorder: true,
                        clickListener: () {}),
                    _mineNavItem(
                        img: 'mine_lIcon04.png',
                        text: '关于我们',
                        clickListener: () {})
                  ]),
                  new SizedBox(
                    height: ScreenUtil().setHeight(60),
                  ),
                  gradualButton('退出当前账号', onTap: () {
                    model.clearUser();
                    Navigator.pushNamed(context, RouteName.login);
                  })
                ],
              ),
            )),
      ),
    );
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
                        : model.user.user == null
                            ? '--'
                            : model.user?.user?.name,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(60), color: Colors.white)),
                new Text(
                    '账号：${model.user?.accountName ?? model.user?.user?.phoneNumber ?? ""}',
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

  //个人数据
  Widget _mineData() {
    return Offstage(
        offstage: false,
        child: Container(
          margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(120),
              bottom: ScreenUtil().setHeight(8)),
          child: new PhysicalModel(
            color: Colors.white, //设置背景底色透明
            borderRadius: BorderRadius.all(Radius.circular(20)),
            clipBehavior: Clip.antiAlias, //裁剪类型
            elevation: 4,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
            child: Container(
              width: ScreenUtil().setWidth(944),
              constraints:
                  BoxConstraints(minHeight: ScreenUtil().setHeight(306)),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _mineDataItem(
                      number: _dataAccount['allApply'].toString(),
                      type: '全部标本'),
                  _mineDataItem(
                      number: _dataAccount['toBeServedApply'].toString(),
                      type: '待送达标本'),
                  _mineDataItem(
                      number: _dataAccount['event'].toString(), type: '相关事件'),
                ],
              ),
            ),
          ),
        ));
  }

  //单个数据
  Widget _mineDataItem({@required String number, @required String type}) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(number,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(64),
                color: Color.fromRGBO(0, 71, 152, 1),
                fontWeight: FontWeight.w600)),
        new Text(type,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(38),
                color: Color.fromRGBO(178, 178, 178, 1),
                height: 2))
      ],
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
      height: ScreenUtil().setHeight(160), //限制按钮高度
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
            new Image.asset(
              ImageHelper.wrapAssets('mine_rarrow.png'),
              width: ScreenUtil().setHeight(40),
              height: ScreenUtil().setHeight(40),
            ),
          ],
        ),
      ),
    );
  }
}
