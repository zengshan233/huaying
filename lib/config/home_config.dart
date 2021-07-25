import 'package:huayin_logistics/config/router_manger.dart';
import 'package:huayin_logistics/model/config_model.dart';

/// 录单模块
List<HomeTabsItem> homeTabsWrite = [
  HomeTabsItem(
      text: '简易录单',
      imgUrl: 'main_simple_write.png',
      routeName: RouteName.easyRecord),
  HomeTabsItem(
      text: '批量录单',
      imgUrl: 'main_batch_write.png',
      routeName: RouteName.mutilRecord),
  HomeTabsItem(
      text: '交接单',
      imgUrl: 'main_transfer.png',
      routeName: RouteName.deliveryReceipt),
  HomeTabsItem(
      text: '已录条码',
      imgUrl: 'main_write_code.png',
      routeName: RouteName.recordedCode),
  HomeTabsItem(
      text: '单据拍照',
      imgUrl: 'main_ticket_picture.png',
      routeName: RouteName.documentaryTakephone),
];

/// 物流处理模块
List<HomeTabsItem> homeTabsExpress = [
  HomeTabsItem(
      text: '标本箱发出',
      imgUrl: 'main_express_send.png',
      routeName: RouteName.specimenBoxSend),
  HomeTabsItem(
      text: '中转取件',
      imgUrl: 'main_express_transfer.png',
      routeName: RouteName.transferPicker),
  HomeTabsItem(
      text: '标本箱送达',
      imgUrl: 'main_express_arrive.png',
      routeName: RouteName.specimenBoxArrive),
];

/// 标本箱处理模块
List<HomeTabsItem> homeTabsBox = [
  HomeTabsItem(
      text: '标本箱交接',
      imgUrl: 'main_hand_box.png',
      routeName: RouteName.specimentBoxJoin),
  HomeTabsItem(
      text: '标本箱合箱',
      imgUrl: 'main_merge_box.png',
      routeName: RouteName.specimentBoxCombine),
];

/// 其他模块
List<HomeTabsItem> homeTabsOther = [
  HomeTabsItem(
      text: '事件管理',
      imgUrl: 'main_issue_manage.png',
      routeName: RouteName.eventManagement),
  HomeTabsItem(
      text: '单据审核',
      imgUrl: 'main_ticket_examine.png',
      routeName: RouteName.receiptCheck)
];
