import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/ui/page/home/deliveryReceipt/delivery_detail.dart';
import 'package:huayin_logistics/ui/page/home/mutilRecord/mutil_record.dart';
import 'package:huayin_logistics/ui/page/home/receiptCheck/receipt_check.dart';
import 'package:huayin_logistics/ui/page/home/receiptCheck/receipt_confirm.dart';
import 'package:huayin_logistics/ui/page/home/receiptCheck/receipt_details.dart';
import 'package:huayin_logistics/ui/page/home/recordedCode/code_detail.dart';
import 'package:huayin_logistics/ui/page/home/selectProject/select_specimen_type.dart';
import 'package:huayin_logistics/ui/page/home/specimenCombine/specimen_box_combine.dart';
import 'package:huayin_logistics/ui/page/home/specimentJoin/speciment_box_join.dart';
import 'package:huayin_logistics/ui/page/home/specimentJoin/user_list.dart';
import 'package:huayin_logistics/ui/page/mine/change_password.dart';
import 'package:huayin_logistics/ui/widget/page_route_anim.dart';
import 'package:huayin_logistics/ui/page/splash.dart';
import 'package:huayin_logistics/ui/page/tab.dart';
import 'package:huayin_logistics/ui/page/mine/login.dart';
import 'package:huayin_logistics/ui/page/mine/forget_password.dart';
import 'package:huayin_logistics/ui/page/home/easyRecord/easy_record.dart';
import 'package:huayin_logistics/ui/page/home/takePhone/documentary_take_phone.dart';
import 'package:huayin_logistics/ui/page/home/deliveryReceipt/delivery_receipt.dart';
import 'package:huayin_logistics/ui/page/home/recordedCode/recorded_code.dart';
import 'package:huayin_logistics/ui/page/home/specimenSend/specimen_box_send.dart';
import 'package:huayin_logistics/ui/page/home/tansferPicker/transfer_picker.dart';
import 'package:huayin_logistics/ui/page/home/specimenArrive/speciment_box_arrive.dart';
import 'package:huayin_logistics/ui/page/home/eventManagement/event_management.dart';
import 'package:huayin_logistics/ui/page/home/easyRecord/select_company.dart';
import 'package:huayin_logistics/ui/page/home/selectProject/select_project.dart';
import 'package:huayin_logistics/ui/page/home/eventManagement/event_detail.dart';
import 'package:huayin_logistics/ui/page/mine/my_info.dart';

class RouteName {
  /// 启动页
  static const String splash = 'splash';

  /// 首页
  static const String tab = '/';

  /// 登陆页
  static const String login = 'login';

  /// 简易录单
  static const String easyRecord = 'easyRecord';

  /// 拍照录单
  static const String documentaryTakephone = 'documentaryTakephone';

  /// 交接单
  static const String deliveryReceipt = 'deliveryReceipt';

  /// 已录条码
  static const String recordedCode = 'recordedCode';

  /// 已录条码详情
  static const String recordedCodeDetail = 'recordedCodeDetail';

  /// 标本箱发出
  static const String specimenBoxSend = 'specimenBoxSend';

  /// 中转取件
  static const String transferPicker = 'transferPicker';

  /// 批量录单
  static const String mutilRecord = 'mutilRecord';

  /// 标本箱送达
  static const String specimenBoxArrive = 'specimenBoxArrive';

  /// 忘记密码
  static const String forgetPassword = 'forgetPassword';

  /// 事件管理
  static const String eventManagement = 'eventManagement';

  /// 单据审核
  static const String receiptCheck = 'receiptCheck';

  /// 单据详情
  static const String receiptDetail = 'receiptDetail';

  /// 单据详情审核确认
  static const String receiptConfirm = 'receiptConfirm';

  /// 选择送检单位
  static const String selectCompany = 'selectCompany';

  /// 标本箱合箱
  static const String specimentBoxCombine = 'specimentBoxCombine';

  /// 标本箱交接
  static const String specimentBoxJoin = 'specimentBoxJoin';

  /// 选择申请项目
  static const String selectProject = 'selectProject';

  /// 事件管理详情
  static const String eventDetail = 'eventDetail';

  /// 个人信息
  static const String userInfo = 'userInfo';

  /// 修改密码
  static const String changePassword = 'changePassword';

  /// 交接单详情
  static const String deliveryDetail = 'deliveryDetail';

  /// 选择标本类型
  static const String specimentSpecimenType = 'specimentSpecimenType';

  /// 选择联系人
  static const String selectUserList = 'selectUserList';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.tab:
        return NoAnimRouteBuilder(TabNavigator());
      case RouteName.login:
        return CupertinoPageRoute(builder: (_) => Login());
      case RouteName.easyRecord:
        return CupertinoPageRoute(builder: (_) => EasyRecord());
      case RouteName.documentaryTakephone:
        return CupertinoPageRoute(builder: (_) => DocumentaryTakePhone());
      case RouteName.deliveryReceipt:
        return CupertinoPageRoute(builder: (_) => DeliveryReceipt());
      case RouteName.recordedCode:
        return CupertinoPageRoute(builder: (_) => RecordedCode());
      case RouteName.recordedCodeDetail:
        var param = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => CodeDetail(item: param['item']));
      case RouteName.selectUserList:
        var param = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => SelectUserList(item: param['item']));
      case RouteName.specimenBoxSend:
        return CupertinoPageRoute(builder: (_) => SpecimenBoxSend());
      case RouteName.transferPicker:
        return CupertinoPageRoute(builder: (_) => TransferPicker());
      case RouteName.mutilRecord:
        return CupertinoPageRoute(builder: (_) => MutilRecord());
      case RouteName.specimenBoxArrive:
        return CupertinoPageRoute(builder: (_) => SpecimenBoxArrive());
      case RouteName.forgetPassword:
        return CupertinoPageRoute(builder: (_) => ForgetPassword());
      case RouteName.eventManagement:
        return CupertinoPageRoute(builder: (_) => EventManagement());
      case RouteName.receiptCheck:
        return CupertinoPageRoute(builder: (_) => ReceiptCheck());
      case RouteName.specimentBoxCombine:
        return CupertinoPageRoute(builder: (_) => SpecimentBoxCombine());
      case RouteName.specimentBoxJoin:
        return CupertinoPageRoute(builder: (_) => SpecimentBoxJoin());
      case RouteName.specimentSpecimenType:
        return CupertinoPageRoute(builder: (_) => SelectSpecimenType());
      case RouteName.selectCompany:
        var param = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => SelectCompany(item: param['item']));
      case RouteName.selectProject:
        var selectProjectParm = settings.arguments as Map;
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => SelectProject(
                hasSelectItem: selectProjectParm == null
                    ? null
                    : selectProjectParm['hasSelectItem']));
      case RouteName.deliveryDetail:
        var param = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => DeliveryDetail(
                  id: param['id'],
                  detail: param['detail'],
                  updateStatus: param['updateStatus'],
                ));
      case RouteName.eventDetail:
        var param = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => EventDetail(
                  eventBackId: param['eventBackId'],
                ));
      case RouteName.receiptDetail:
        var param = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => ReceiptDetail(
                receiptId: param['receiptId'],
                applyId: param['applyId'],
                status: param['status'],
                updateList: param['updateList']));
      case RouteName.receiptConfirm:
        var param = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => ReceiptConfirm(
                  applyId: param['applyId'],
                  update: param['update'],
                ));
      case RouteName.userInfo:
        return CupertinoPageRoute(builder: (_) => MyInfo());
      case RouteName.changePassword:
        return CupertinoPageRoute(builder: (_) => ChangePassword());
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
