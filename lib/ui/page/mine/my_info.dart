import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:provider/provider.dart';

/// 个人信息页面
class MyInfo extends StatefulWidget {
  MyInfo({Key key}) : super(key: key);

  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 接口请求
      Provider.of<MineModel>(context).fetchUserInfo();
    });
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
                  _mineNavList(listWidget: [
                    _mineNavItem(
                        img: model.user.user?.icon ?? 'mine_lIcon01.png',
                        text: '个人信息',
                        needBorder: true,
                        clickListener: () {}),
                    _infoItem(
                        title: '账号', text: model.user.accountName ?? '--'),
                    _infoItem(title: '姓名', text: model.user.user?.name ?? '--'),
                    _infoItem(
                        title: '部门',
                        text: model.user.user?.orgName ?? '--'),
                    _infoItem(
                        title: '手机号',
                        text: model.user.user?.phoneNumber ?? '--')
                  ]),
                  new SizedBox(
                    height: ScreenUtil().setHeight(60),
                  ),
                  gradualButton('返回', onTap: () {
                    Navigator.pop(context);
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
    if (model.user.user?.gender != null) {
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
                            ? 'null'
                            : model.user.user.name,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(60), color: Colors.white)),
                new Text('账号：${model.user.accountName ?? '--'}',
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
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
      {@required String title, @required String text, bool needBorder = true}) {
    return Container(
        height: ScreenUtil().setHeight(160), //限制按钮高度
        decoration: BoxDecoration(
          border: Border(
              bottom: needBorder
                  ? BorderSide(
                      width: 1 / ScreenUtil.pixelRatio,
                      color: GlobalConfig.borderColor)
                  : BorderSide.none),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Text(title,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(46),
                  color: Color.fromRGBO(90, 90, 91, 1))),
          trailing: Text(text,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(38),
                  color: Color.fromRGBO(90, 90, 91, 1))),
        ));
  }
}
