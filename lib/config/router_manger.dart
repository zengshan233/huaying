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
  /// ?????????
  static const String splash = 'splash';

  /// ??????
  static const String tab = '/';

  /// ?????????
  static const String login = 'login';

  /// ????????????
  static const String easyRecord = 'easyRecord';

  /// ????????????
  static const String documentaryTakephone = 'documentaryTakephone';

  /// ?????????
  static const String deliveryReceipt = 'deliveryReceipt';

  /// ????????????
  static const String recordedCode = 'recordedCode';

  /// ??????????????????
  static const String recordedCodeDetail = 'recordedCodeDetail';

  /// ???????????????
  static const String specimenBoxSend = 'specimenBoxSend';

  /// ????????????
  static const String transferPicker = 'transferPicker';

  /// ????????????
  static const String mutilRecord = 'mutilRecord';

  /// ???????????????
  static const String specimenBoxArrive = 'specimenBoxArrive';

  /// ????????????
  static const String forgetPassword = 'forgetPassword';

  /// ????????????
  static const String eventManagement = 'eventManagement';

  /// ????????????
  static const String receiptCheck = 'receiptCheck';

  /// ????????????
  static const String receiptDetail = 'receiptDetail';

  /// ????????????????????????
  static const String receiptConfirm = 'receiptConfirm';

  /// ??????????????????
  static const String selectCompany = 'selectCompany';

  /// ???????????????
  static const String specimentBoxCombine = 'specimentBoxCombine';

  /// ???????????????
  static const String specimentBoxJoin = 'specimentBoxJoin';

  /// ??????????????????
  static const String selectProject = 'selectProject';

  /// ??????????????????
  static const String eventDetail = 'eventDetail';

  /// ????????????
  static const String userInfo = 'userInfo';

  /// ????????????
  static const String changePassword = 'changePassword';

  /// ???????????????
  static const String deliveryDetail = 'deliveryDetail';

  /// ??????????????????
  static const String specimentSpecimenType = 'specimentSpecimenType';

  /// ???????????????
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

/// Pop??????
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
