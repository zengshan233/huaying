import 'package:huayin_logistics/config/net/api.dart';
import 'package:huayin_logistics/model/check_data_model.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/join_list_model.dart';
import 'package:huayin_logistics/model/login_data_model.dart';
import 'package:huayin_logistics/model/oss_model.dart';
import 'package:huayin_logistics/model/page_model.dart';
import 'package:huayin_logistics/model/receive_model.dart';
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/model/site_model.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/model/specimen_status_inquiry_data_model.dart';
import 'package:huayin_logistics/model/transfer_picker_model_data.dart';
import 'package:huayin_logistics/model/user_model.dart';
import 'package:huayin_logistics/view_model/home/join_list_model.dart';

import 'huayin_api.dart';

class Repository {
  //分页大小
  static const String pageSize = '20';

  // 账号登录
  static Future fetchAccountLogin(String accountName, String password) async {
    var response = await http.post<Map>(
        '/org/security/user/signin?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {'accountName': accountName, 'password': password});
    return LoginDataModel.fromJson(response.data);
  }

  //获取验证码
  static Future fetchPhoneCheckCode(String phoneNumber) async {
    var response = await http.post<bool>(
        '/org/users/sms/code?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          'phoneNumber': phoneNumber,
        });
    return response.data;
  }

  //验证码登录
  static Future fetchPhoneLogin(String phoneNumber, String checkCode) async {
    var response = await http.post<Map>(
        '/org/users/sms/sign?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {'phoneNumber': phoneNumber, 'verifyCode': checkCode});
    return LoginDataModel.fromJson(response.data);
  }

  //修改密码
  static Future fetchModifyPassword(
      String phoneNumber, String checkCode, String password) async {
    var response = await http.post<bool>(
        '/org/account/retrieve/pwd?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          'loginType': 3,
          'phoneNumber': phoneNumber,
          'verifyCode': checkCode,
          'password': password
        });
    return response.data;
  }

  /// 获取个人信息
  static Future fetchUserInfo(String userId) async {
    var response = await http.get<Map>('/org/users/users/$userId');
    return User.fromJson(response.data);
  }

  //查询中转取件
  static Future fetchTransferPickerInquiry(String boxNo) async {
    var response = await http.post<Map>(
        '/specimen/logistics/pick/no/pick?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {'boxNo': boxNo});
    return TransferPickerData.fromJson(response.data);
  }

  //根据旧密码修改密码
  static Future changePassword(String phoneNumber, String password,
      String newPassword, String id, String accountName) async {
    var response = await http.post<bool>(
        '/org/account/update/pwd?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          'loginType': 3,
          'phoneNumber': phoneNumber,
          'newPassword': newPassword,
          'password': password,
          'accountName': accountName,
          'id': id,
        });
    return response.data;
  }

  //取件和取消取件操作
  static Future fetchPickerOrCancelPicker(
      String id,
      String updateAt,
      String driverContactNumber,
      String nodeHandlerId,
      String nodeHandlerName,
      String status) async {
    await http.post(
        '/specimen/logistics/pick/node?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          'status': status,
          'id': id,
          'updateAt': updateAt,
          'driverContactNumber': driverContactNumber,
          'nodeHandlerId': nodeHandlerId,
          'nodeHandlerName': nodeHandlerName
        });
  }

  //标本箱送达分页查询
  static Future fetchSpecimenArriveInquiryByPage(
      String deliveryDriverId, int pageNumber) async {
    var response = await http.post<Map>(
        '/specimen/logistics/sign/page/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          'deliveryDriverId': deliveryDriverId,
          'pageNumber': pageNumber,
          'pageSize': pageSize,
          'status': '2',
        });
    return SpecimenboxArriveDataModel.fromJson(response.data).records;
  }

  //标本箱送达-根据标本箱号查询标本箱信息
  static Future<List<SpecimenboxArriveItem>> fetchSpecimenArriveInquiryByBoxNo(
      {String boxNo, String labId, bool isDelivered = false}) async {
    Response<List> response = await http.post<List>(
        '/order/lab/$labId/box/transport/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {'boxNo': boxNo, 'isDelivered': isDelivered});
    return List<SpecimenboxArriveItem>.from(
        response.data.map((e) => SpecimenboxArriveItem.fromJson(e)));
  }

  //标本箱送达-送达操作
  static Future fetchSpecimenArriveOperate(
      {String labId,
      String id,
      String deliveredId,
      String deliveredName}) async {
    await http.post(
        '/order/lab/$labId/box/transport/delivered?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "deliveredId": deliveredId,
          "deliveredName": deliveredName,
          "id": id
        });
  }

  //标本箱确认接收
  static Future fetchSpecimenReceiveOperate({
    String labId,
    List<String> joinIds,
  }) async {
    await http.post(
        '/lab/$labId/box/receive/confirm?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "joinIds": joinIds,
        });
  }

  //标本箱超时确认
  static Future fetchSpecimenExceptionOperate({
    String id,
    String labId,
    String confirmId,
    String confirmName,
    String confirmRemark,
  }) async {
    await http.post(
        '/lab/$labId/box/transport/exception/confirm?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "exceptionConfirmBy": confirmId,
          "exceptionConfirmByName": confirmName,
          "exceptionRemark": confirmRemark,
          "id": id
        });
  }

  //标本箱中转确认
  static Future fetchTransferConfirm({
    String labId,
    Map<String, dynamic> data,
  }) async {
    await http.post(
        '/order/lab/$labId/box/transport/transfer/confirm?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
  }

  //标本箱送达-选择路线
  static Future<WayModel> fetchSpecimenSendSelectWay(String id) async {
    var response = await http.get<List<dynamic>>(
        '/line/user/query/lines/list/$id?orgId=82858490362716212&labOrgId=82858490362716212');
    return WayModel.fromJson(response.data);
  }

  //标本想送达-提交
  static Future fetchSpecimenSendSubmit(
      {Map<String, dynamic> data, String labId}) async {
    await http.post(
        '/lab/$labId/box/transport/batch/create?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
  }

  //获取选择项目左侧菜单
  static Future fetchSelectItemLeftMenu(String organizId) async {
    var response = await http.post<List<dynamic>>(
        '/org/org/dicts/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {"organizId": organizId});
    return SelectItemLeftMenu.fromJson(response.data);
  }

  //获取选择项目右侧列表
  static Future fetchSelectItemRightList(
      String keyword, String itemType, String labDeptId, int pageNumber) async {
    var response = await http.post<Map>(
        '/system/setting/item/conf/open/bill?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "keyword": keyword, //输入框搜索
          // "itemType": itemType, //单项1  组合2  套餐3
          // "labDeptId": labDeptId,
          // "itemType": itemType, //单项1  组合2  套餐3
          "pageNumber": pageNumber,
          "pageSize": pageSize
        });
    return SelectItemRightList.fromJson(response.data).records;
  }

  //获取单条套餐项目明细数据
  static Future<List<ProjectDetailItem>> fetchSelectItemDetail(
      String dictId) async {
    Response<List> response = await http.post<List>(
        '/dict/system/combo/items/join/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "dictId": dictId,
        });
    return List<ProjectDetailItem>.from(
        (response.data ?? []).map((e) => ProjectDetailItem.fromJson(e)));
  }

  //获取选择医院单位列表
  static Future fetchSelectCompanyList(String custName, int pageNumber) async {
    var response = await http.post<Map>(
        '/specimen/state/find/inspection?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "custName": custName,
          "pageNumber": pageNumber,
          "pageSize": pageSize,
        });
    return SelectCompanyList.fromJson(response.data).records;
  }

  //获取标本箱类型
  static Future fetchSelectSpecimentTypeList(
      String keyword, int pageNumber, String labId) async {
    var response = await http.post(
        '/lab/$labId/dict/system/sample/type/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "keyword": keyword,
          "status": 1,
        });
    return response.data;
  }

  //录单保存提交
  static Future fetchRecordSavaSubmit(
      List<Map<String, dynamic>> list, String labId) async {
    await http.post(
        '/lab/$labId/new/simple/record/save?orgId=82858490362716212&labOrgId=82858490362716212',
        data: list);
  }

  //拍照录单
  static Future<Map> fetchDocumentaryTakePhoneInfo(String barCode) async {
    Response<Map> response = await http.get<Map>(
        '/specimen/state/find/barcode?barCode=$barCode&orgId=82858490362716212&labOrgId=82858490362716212');
    return response.data;
  }

  //根据条码号查询已录入条码
  static Future<RecordedItem> fetchRecordedBarcode(
      {String labId,
      String barCode,
      String recordId,
      String recordAt,
      String status}) async {
    Response<Map<String, dynamic>> response = await http.post<
            Map<String, dynamic>>(
        '/order/lab/$labId/box/recorded/barcode?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "barcode": barCode,
          "recordId": recordId,
          "recordAt": recordAt,
          "status": status
        });
    return response.data == null ? null : RecordedItem.fromJson(response.data);
  }

  //列表查询标本箱已录入条码表
  static Future<List<RecordedItem>> fetchRecordedBarcodeList(
      {String labId,
      String barCode,
      String recordId,
      String startAt,
      String endAt,
      String status}) async {
    var response = await http.post(
        '/order/lab/$labId/box/recorded/page/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "recordId": recordId,
          "status": status,
          "barcode": barCode,
          "startAt": startAt,
          "endAt": endAt
        });
    return RecordedListResponse.fromJson(response.data).records;
  }

  //查询条码详情
  static Future fetchCodeDetail({String applyId, String labId}) async {
    Response<Map> response = await http.get<Map>(
        '/lab/$labId/new/simple/record/apply/$applyId?orgId=82858490362716212&labOrgId=82858490362716212');
    print('dataaaas ${response.data}');
    return response.data;
  }

  //拍照录单保存
  static Future fetchDocumentaryTakePhoneSubmit(
      List<Map<String, dynamic>> list) async {
    await http.post(
        '/recordSheet/apply/photo/record?orgId=82858490362716212&labOrgId=82858490362716212',
        data: list);
  }

  //列表查询标本箱交接表
  static Future<List<JoinListItem>> fetchDeliveryList(
      {String labId, String recordId, int pageNumber}) async {
    var response = await http.post(
        '/order/lab/$labId/box/join/page/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "pageNumber": pageNumber,
          "pageSize": 20,
        });
    return JoinListResponse.fromJson(response.data).records;
  }

  //拍照录单保存
  static Future<bool> fetchCheckCompany(
      {String labId,
      String boxNo,
      String inspectionUnitId,
      String recordId}) async {
    Response<bool> response = await http.post<bool>(
        '/order/lab/${labId}box/join/item/inspection/unit/check/confirm?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "boxNo": boxNo,
          "inspectionUnitId": inspectionUnitId,
          "recordId": recordId
        });
    return response?.data ?? false;
  }

  //标本状态查询
  static Future fetchSpecimenStatusInquiry(
      int pageNumber,
      String inputParam, //搜索框内容
      String createTime, //开始时间
      String endTime, //结束时间
      List<String> inspectionIds, //送检医院id
      List<String> itemIds, //申请项目id
      bool applyDate, //时间排序
      bool inspection, //医院排序
      bool specimenStatusName //标本状态排序
      ) async {
    var response = await http.post<Map>(
        '/specimen/state/pageQuery?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {
          "pageNumber": pageNumber,
          "pageSize": pageSize,
          "inputParam": inputParam,
          "createTime": createTime == '' ? '' : createTime + ' 00:00:00.000',
          "endTime": endTime == '' ? '' : endTime + ' 23:59:59.000',
          "inspectionIds": inspectionIds,
          "itemIds": itemIds,
          "applyDate": applyDate,
          "inspection": inspection,
          "specimenStatusName": specimenStatusName
        });
    return SpecimenStatusInquiryDataModel.fromJson(response.data).records;
  }

  //标本状态详情查询
  static Future fetchSpecimenStatusDetailInquiry(String id) async {
    var response = await http.get<Map>(
        '/specimen/state/find?id=$id&orgId=82858490362716212&labOrgId=82858490362716212');
    return SpecimenStatusInquiryDataModelDetail.fromJson(response.data);
  }

  //获取全部标本，待送达标本，相关事件
  static Future fetchSpecimenEventDataAccount() async {
    var response = await http.get<Map>(
        '/specimen/statecount/allandtobeserved?orgId=82858490362716212&labOrgId=82858490362716212');
    return response.data;
  }

  //判断条码列表中已经使用过
  static Future fetchJudgeSpecimenCodeExist(String barCodes) async {
    var response = await http.post<List<dynamic>>(
        '/recordSheet/apply/already/applied?orgId=82858490362716212&labOrgId=82858490362716212',
        queryParameters: {"barCodes": barCodes});
    return response.data;
  }

  //查询事件管理信息列表
  static Future fetchEventFeedbackList(int pageNumber,
      {String keyword, int handleStatus}) async {
    Map<String, dynamic> data = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    if (keyword != null && keyword.isNotEmpty) {
      data['keyword'] = keyword;
    }
    if (handleStatus != null && handleStatus > 0) {
      data['handleStatus'] = handleStatus;
    }

    var response = await http.post<Map>(
        '/call/center/customer/back/page/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return EventFeedbackListModel.fromJson(response.data).records;
  }

  //分页查询单录简易单
  static Future<List<CheckItem>> fetchCheckList(int pageNumber, String labId,
      {int aloneRecordStatus}) async {
    Map<String, dynamic> data = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    if (aloneRecordStatus != null && aloneRecordStatus > 0) {
      data['aloneRecordStatus'] = aloneRecordStatus;
    }
    var response = await http.post<Map>(
        '/lab/$labId/new/simple/alone/page/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return PageResponse<CheckItem>.fromJson(
        response.data, (v) => CheckItem.fromJson(v)).records;
  }

  //审核通过
  static Future fetchCheckAdopt(
      {String labId, Map<String, dynamic> data}) async {
    var response = await http.post(
        '/lab/$labId/new/simple/alone/adopt?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return response.data;
  }

  //审核驳回
  static Future fetchCheckRefuse(
      {String labId, Map<String, dynamic> data}) async {
    var response = await http.post(
        '/lab/$labId/new/simple/alone/refuse?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return response.data;
  }

  //新增反馈事件
  static Future fetchAddEventFeedback(Map<String, dynamic> data) async {
    var response = await http.post<Map>(
        '/call/center/customer/back/create?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return response.data;
  }

  //主键查询反馈事件内容
  static Future fetchEventFeedbackDetail(String id) async {
    var response = await http.get<Map>(
        '/call/center/customer/back/$id?orgId=82858490362716212&labOrgId=82858490362716212');
    return EventFeedback.fromJson(response.data);
  }

  //根据订单ID查询简易单
  static Future<CheckDetailData> fetchCheckDetail(
      {String id, String labId}) async {
    var response = await http.get<Map>(
        '/order/lab/$labId/new/simple/alone/$id?orgId=82858490362716212&labOrgId=82858490362716212');
    print('extraaaaaaaaaaaaa ${response.data['extra']}');
    return CheckDetailData.fromJson(response.data);
  }

  //修改反馈事件信息
  static Future fetchEditEventFeedback(
      String id, Map<String, dynamic> data) async {
    await http.put(
        '/call/center/customer/back/$id?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
  }

  //新增反馈图片
  static Future fetchAddEventImage(Map<String, dynamic> data) async {
    var response = await http.post(
        '/call/center/customer/back/image?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return response.data;
  }

  //删除反馈图片
  static Future fetchDeleteEventImage(String id, String updateAt) async {
    await http.delete(
        '/call/center/customer/back/image/$id?orgId=82858490362716212&labOrgId=82858490362716212',
        queryParameters: {"updateAt": updateAt});
  }

  //获取反馈图片列表
  static Future fetchEventImageList(String id) async {
    var response = await http.post(
        '/call/center/customer/back/image/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {"customerBackId": id});
    List<EventImage> list = [];
    if (response.data != null) {
      response.data.forEach((item) {
        list.add(EventImage(item));
      });
    }
    return list;
  }

  //新增事件反馈信息回复
  static Future fetchAddEventReply(Map<String, dynamic> data) async {
    await http.post(
        '/call/center/customer/back/message?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
  }

  //对象查询关联回复信息
  static Future fetchEventReplyList(String customerBackId) async {
    var response = await http.post(
        '/call/center/customer/back/message/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {"customerBackId": customerBackId});
    List<EventReply> list = [];
    if (response.data != null) {
      response.data.forEach((item) {
        list.add(EventReply(item));
      });
    }
    return list;
  }

  ///获取阿里云OSS临时授权
  static Future<OssSts> fetchOssSts() async {
    Response<Map<String, dynamic>> response =
        await http.get<Map<String, dynamic>>(
            '/oss/sts?orgId=82858490362716212&labOrgId=82858490362716212');
    OssSts ossSts = OssSts.fromJson(response.data);
    return ossSts;
  }

  ///获取标本箱
  static Future fetchBoxList(String labId, String userId) async {
    Response<List> response = await http.get<List>(
        '/order/lab/$labId/box/conf/$userId?orgId=82858490362716212&labOrgId=82858490362716212');
    print("boxLIsttttttttt ${response.data}");
    return response;
  }

  ///根据箱号和人员查询当前未完成最新交接单ID
  static Future<String> fetchDeliveryId(
      {String boxNo, String labId, String recordId, String boxId}) async {
    Response response = await http.post(
        '/order/lab/$labId/box/join/un/finish/current/new?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {"boxId": boxId, "boxNo": boxNo, 'recordId': recordId});
    return response.data.toString();
  }

  ///查询标本箱交接表详情
  static Future<DeliveryDetailModel> fetchDeliveryDetail(
      {String labId, String id}) async {
    Response response = await http.get(
        '/order/lab/$labId/box/join/$id?orgId=82858490362716212&labOrgId=82858490362716212');
    return DeliveryDetailModel.fromJson(response.data);
  }

  ///主键列表查询标本箱交接表
  static Future<List<JoinItem>> fetchJoinList(
      {String labId, List<String> ids}) async {
    Response response = await http.post(
        '/order/lab/$labId/box/join?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {"ids": ids});
    return List<JoinItem>.from(response.data.map((d) => JoinItem.fromJson(d)));
  }

  ///新增标本箱交接表
  static Future<DeliveryDetailModel> fetchAddDelivery(
      {String labId, String id, Map<String, dynamic> data}) async {
    Response response = await http.put(
        '/order/lab/$labId/box/join/item/$id?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return DeliveryDetailModel.fromJson(response.data);
  }

  ///确认标本箱交接表
  static Future fetchConfirmDelivery(String id) async {
    Response response = await http.put(
        '/order/lab/box/join/confirm/$id?orgId=82858490362716212&labOrgId=82858490362716212');
    return response;
  }

  ///修改标本箱交接明细状态
  static Future fetchConfirmDeliveryItem(String id, String status) async {
    Response response = await http.put(
        '/order/lab/box/join/item/$id/$status?orgId=82858490362716212&labOrgId=82858490362716212');
    return response;
  }

  ///修改标本箱交接明细温度表
  static Future fetchChangeDeliveryTemperature(
      {String id, String labId, Map<String, dynamic> data}) async {
    Response response = await http.put(
        '/order/lab/$labId/box/join/item/temperature/$id?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return response;
  }

  ///文件信息补充保存
  static Future<List<FileUploadItem>> fetchFileSave(
      String orgId, List<String> ossPaths) async {
    List params = ossPaths
        .map((path) => {
              "businessType": '2',
              "fileType": '1',
              "orgId": orgId,
              "ossPath": path
            })
        .toList();
    Response response = await http.post(
        '/files/batch/make/up?orgId=82858490362716212&labOrgId=82858490362716212',
        data: params);
    List<FileUploadItem> items = List<FileUploadItem>.from(
        response.data.map((e) => FileUploadItem.fromJson(e)));
    return items;
  }

  ///待合箱标本箱列表查询
  static Future<List<SpecimenCombinedItem>> fetchCombinedBoxes(
      {String userId, String labId}) async {
    Response<List> response = await http.post<List>(
        '/order/lab/$labId/box/join/wait/combined?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {"userId": userId});
    return List<SpecimenCombinedItem>.from(
        (response.data ?? []).map((l) => SpecimenCombinedItem.fromJson(l)));
  }

  ///查询待发出标本箱列表
  static Future<List<SpecimenBoxItem>> fetchSendBoxes(
      {String userId, String labId}) async {
    Response<List> response = await http.post<List>(
        '/order/lab/$labId/box/transport/wait/send/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {"userId": userId});
    return List<SpecimenBoxItem>.from(
        (response.data ?? []).map((l) => SpecimenBoxItem.fromJson(l)));
  }

  ///查询用户未使用标本箱列表
  static Future<List<SpecimenUnusedItem>> fetchUnUsedBoxes(
      {String userId, String labId}) async {
    Response<List> response = await http.post<List>(
        '/lab/$labId/box/conf/un/use/list/$userId?orgId=82858490362716212&labOrgId=82858490362716212');
    return List<SpecimenUnusedItem>.from(
        (response.data ?? []).map((l) => SpecimenUnusedItem.fromJson(l)));
  }

  ///标本箱合箱
  static Future fetchBoxesCombine(
      {String labId, Map<String, dynamic> data}) async {
    Response response = await http.post(
        '/order/lab/$labId/box/join/combined?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return Response;
  }

  ///查询待交接标本箱列表
  static Future<List<SpecimenJoinItem>> fetchJoinBoxes(
      {String userId, String labId}) async {
    Response<List> response = await http.post<List>(
        '/order/lab/$labId/box/wait/join/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: {"userId": userId});
    return List<SpecimenJoinItem>.from(
        (response?.data ?? []).map((r) => SpecimenJoinItem.fromJson(r)));
  }

  ///发起标本箱交接
  static Future fetchBoxesJoin(
      {String labId, Map<String, dynamic> data}) async {
    Response response = await http.post(
        '/order/lab/$labId/box/sponse/join?orgId=82858490362716212&labOrgId=82858490362716212',
        data: data);
    return;
  }

  ///查询查询所有物流人员
  static Future<List<UserModel>> fetchUserList(
      {String userId, String labId}) async {
    Response<List> response = await http.get<List>(
        '/lab/$labId/logistics/user/list?orgId=82858490362716212&labOrgId=82858490362716212');
    return List<UserModel>.from(
        response.data.map((r) => UserModel.fromJson(r)));
  }

  ///主键查询标本箱运输单
  static Future fetchTransportList({String userId, String labId}) async {
    Response response = await http.get(
        '/order/lab/$labId/box/transport/$userId?orgId=82858490362716212&labOrgId=82858490362716212');
    return response;
  }

  ///根据组织查询标本箱到达站点表
  static Future<List<SiteModel>> fetchArriveSiteList({String labId}) async {
    Response<List> response = await http.get<List>(
        '/order/lab/$labId/arrive/site/list?orgId=82858490362716212&labOrgId=82858490362716212');
    return List<SiteModel>.from(
        response.data.map((r) => SiteModel.fromJson(r)));
  }

  ///对象查询标本箱运输单
  static Future<List<SpecimenboxArriveItem>> fetchTransportData(
      {String labId,
      bool isDelivered,
      String boxNo,
      String receiveStatus}) async {
    Map<String, dynamic> params = {};
    if (receiveStatus != null) {
      params['receiveStatus'] = receiveStatus;
    }
    if (isDelivered != null) {
      params['isDelivered'] = isDelivered;
    }
    if (boxNo != null && boxNo.isNotEmpty) {
      params['boxNo'] = boxNo;
    }

    Response<List> response = await http.post<List>(
        '/order/lab/$labId/box/transport/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: params);
    return List<SpecimenboxArriveItem>.from(
        (response.data ?? []).map((r) => SpecimenboxArriveItem.fromJson(r)));
  }

  ///列表查询标本箱运输单
  static Future<List<SpecimenboxArriveItem>> fetchTransportListData(
      {String labId,
      bool isDelivered,
      String boxNo,
      String pickUpId,
      String lineId}) async {
    Map<String, dynamic> params = {
      "status": isDelivered ? '2' : '1',
    };
    if (pickUpId != null && isDelivered) {
      params['pickUpId'] = pickUpId;
    }
    if (boxNo != null && boxNo.isNotEmpty) {
      params['boxNo'] = boxNo;
    }

    Response response = await http.post(
        '/order/lab/$labId/box/transport/page/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: params);

    return PageResponse<SpecimenboxArriveItem>.fromJson(
        response.data, (v) => SpecimenboxArriveItem.fromJson(v)).records;
  }

  ///分页查询待交接确认或已经交接完成的标本箱信息
  static Future<List<ReceiveListItem>> fetchReceiveData(
      {String labId,
      String userId,
      String boxNo,
      int pageNumber,
      int receiveStatus}) async {
    Map<String, dynamic> params = {
      "userId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "receiveStatus": receiveStatus
    };
    if (boxNo != null) {
      params['boxNo'] = boxNo;
    }
    Response response = await http.post(
        '/lab/$labId/box/receive/page/list?orgId=82858490362716212&labOrgId=82858490362716212',
        data: params);
    return ReceiveList.fromJson(response.data).records ?? [];
  }
}
