import 'package:huayin_logistics/config/net/api.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/model/documentary_take_phone_data_model.dart';
import 'package:huayin_logistics/model/event_manager_data_model.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/login_data_model.dart';
import 'package:huayin_logistics/model/oss_model.dart';
import 'package:huayin_logistics/model/recorded_code_model.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/model/specimen_box_send_data_model.dart';
import 'package:huayin_logistics/model/specimen_status_inquiry_data_model.dart';
import 'package:huayin_logistics/model/transfer_picker_model_data.dart';
import 'package:huayin_logistics/view_model/home/join_list_model.dart';

import 'huayin_api.dart';

class Repository {
  //分页大小
  static const String pageSize = '20';

  // 账号登录
  static Future fetchAccountLogin(String accountName, String password) async {
    var response = await http.post<Map>('/org/security/user/signin',
        data: {'accountName': accountName, 'password': password});
    print(response.data);
    return LoginDataModel.fromJson(response.data);
  }

  //获取验证码
  static Future fetchPhoneCheckCode(String phoneNumber) async {
    var response = await http.post<bool>('/org/users/sms/code', data: {
      'phoneNumber': phoneNumber,
    });
    return response.data;
  }

  //验证码登录
  static Future fetchPhoneLogin(String phoneNumber, String checkCode) async {
    var response = await http.post<Map>('/org/users/sms/sign',
        data: {'phoneNumber': phoneNumber, 'verifyCode': checkCode});
    return LoginDataModel.fromJson(response.data);
  }

  //修改密码
  static Future fetchModifyPassword(
      String phoneNumber, String checkCode, String password) async {
    var response = await http.post<bool>('/org/account/retrieve/pwd', data: {
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
    var response = await http
        .post<Map>('/specimen/logistics/pick/no/pick', data: {'boxNo': boxNo});
    return TransferPickerData.fromJson(response.data);
  }

  //根据旧密码修改密码
  static Future changePassword(String phoneNumber, String password,
      String newPassword, String id, String accountName) async {
    var response = await http.post<bool>('/org/account/update/pwd', data: {
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
    await http.post('/specimen/logistics/pick/node', data: {
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
    var response =
        await http.post<Map>('/specimen/logistics/sign/page/list', data: {
      'deliveryDriverId': deliveryDriverId,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'status': '2',
    });
    return SpecimenboxArriveDataModel.fromJson(response.data).records;
  }

  //标本箱送达-根据标本箱号查询标本箱信息
  static Future fetchSpecimenArriveInquiryByBoxNo(String boxNo) async {
    var response = await http
        .post<Map>('/specimen/logistics/sign/no/sign', data: {'boxNo': boxNo});
    return SpecimenboxArriveItem.fromJson(response.data);
  }

  //标本箱送达-送达操作
  static Future fetchSpecimenArriveOperate(
      String id,
      String updateAt,
      String driverContactNumber,
      String nodeHandlerId,
      String nodeHandlerName) async {
    await http.post('/specimen/logistics/sign/node', data: {
      'status': '3',
      'id': id,
      'updateAt': updateAt,
      'driverContactNumber': driverContactNumber,
      'nodeHandlerId': nodeHandlerId,
      'nodeHandlerName': nodeHandlerName
    });
  }

  //标本箱送达-选择路线
  static Future fetchSpecimenSendSelectWay(String id) async {
    var response =
        await http.get<List<dynamic>>('/line/user/query/lines/list/$id');
    return WayModel.fromJson(response.data);
  }

  //标本想送达-提交
  static Future fetchSpecimenSendSubmit(
      String boxNo,
      String specimenAmount,
      List<Map<String, String>> images,
      String logisticsLine,
      String sender,
      String senderId) async {
    await http.post<Map>('/specimen/logistics/hair', data: {
      "boxNo": boxNo,
      "specimenAmount": specimenAmount,
      "images": images,
      "logisticsLine": logisticsLine,
      "sender": sender,
      "senderId": senderId
    });
  }

  //获取选择项目左侧菜单
  static Future fetchSelectItemLeftMenu(String organizId) async {
    var response = await http.post<List<dynamic>>('/org/org/dicts/list',
        data: {"organizId": organizId});
    return SelectItemLeftMenu.fromJson(response.data);
  }

  //获取选择项目右侧列表
  static Future fetchSelectItemRightList(
      String keyword, String itemType, String labDeptId, int pageNumber) async {
    var response =
        await http.post<Map>('/system/setting/item/conf/open/bill', data: {
      "keyword": keyword, //输入框搜索
      // "itemType": itemType, //单项1  组合2  套餐3
      // "labDeptId": labDeptId,
      "pageNumber": pageNumber,
      "pageSize": pageSize
    });
    return SelectItemRightList.fromJson(response.data).records;
  }

  //获取选择医院单位列表
  static Future fetchSelectCompanyList(String custName, int pageNumber) async {
    var response =
        await http.post<Map>('/specimen/state/find/inspection', data: {
      "custName": custName,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    });
    return SelectCompanyList.fromJson(response.data).records;
  }

  //获取标本箱类型
  static Future fetchSelectSpecimentTypeList(
      String keyword, int pageNumber, String labId) async {
    var response =
        await http.post('/lab/$labId/dict/system/sample/type/list', data: {
      "keyword": keyword,
      "status": 0,
    });
    return response.data;
  }

  //录单保存提交
  static Future fetchRecordSavaSubmit(
      List<Map<String, dynamic>> list, String labId) async {
    await http.post('/lab/$labId/new/simple/record/save', data: list);
  }

  //拍照录单
  static Future fetchDocumentaryTakePhoneInfo(String barCode) async {
    var response =
        await http.get<Map>('/specimen/state/find/barcode?barCode=$barCode');
    return DocumentaryTakePhoneDataModel.fromJson(response.data);
  }

  //根据条码号查询已录入条码
  static Future<RecordedItem> fetchRecordedBarcode(
      {String labId,
      String barCode,
      String recordId,
      String recordAt,
      String status}) async {
    Response<Map<String, dynamic>> response = await http
        .post<Map<String, dynamic>>(
            '/order/lab/$labId/box/recorded/barcode',
            data: {
          "barcode": barCode,
          "recordId": recordId,
          "recordAt": recordAt,
          "status": status
        });
    return RecordedItem.fromJson(response.data);
  }

  //根据条码号查询已录入条码
  static Future<List<RecordedItem>> fetchRecordedBarcodeList(
      {String labId,
      String barCode,
      String recordId,
      String recordAt,
      String status}) async {
    var response = await http.post('/order/lab/$labId/box/recorded/page/list',
        data: {"recordId": recordId, "status": status});
    return RecordedListResponse.fromJson(response.data).records;
  }

  //查询条码详情
  static Future fetchCodeDetail({String applyId, String labId}) async {
    Response<Map> response =
        await http.get<Map>('/lab/$labId/new/simple/record/apply/$applyId');
    return response.data;
  }

  //拍照录单保存
  static Future fetchDocumentaryTakePhoneSubmit(
      List<Map<String, dynamic>> list) async {
    await http.post('/recordSheet/apply/photo/record', data: list);
  }

  //列表查询标本箱交接表
  static Future<List<JoinListItem>> fetchDeliveryList(
      {String labId, String recordId}) async {
    var response =
        await http.post('/order/lab/$labId/box/join/page/list', data: {
      "pageNumber": 1,
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
        '/order/lab/${labId}box/join/item/inspection/unit/check/confirm',
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
    var response = await http.post<Map>('/specimen/state/pageQuery', data: {
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
    var response = await http.get<Map>('/specimen/state/find?id=$id');
    return SpecimenStatusInquiryDataModelDetail.fromJson(response.data);
  }

  //获取全部标本，待送达标本，相关事件
  static Future fetchSpecimenEventDataAccount() async {
    var response = await http.get<Map>('/specimen/statecount/allandtobeserved');
    return response.data;
  }

  //判断条码列表中已经使用过
  static Future fetchJudgeSpecimenCodeExist(String barCodes) async {
    var response = await http.post<List<dynamic>>(
        '/recordSheet/apply/already/applied',
        queryParameters: {"barCodes": barCodes});
    return response.data;
  }

  //查询事件管理信息列表
  static Future fetchEventFeedbackList(int pageNumber, {String keyword}) async {
    Map<String, dynamic> data;
    if (keyword == null || keyword.isEmpty) {
      data = {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
      };
    } else {
      data = {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "keyword": keyword, //输入框搜索
        // "startDate":'2020-01-01 00:00:00.000',
        // "endDate":'2020-03-20 23:59:59.000'
      };
    }
    var response = await http.post<Map>('/call/center/customer/back/page/list',
        data: data);
    return EventFeedbackListModel.fromJson(response.data).records;
  }

  //新增反馈事件
  static Future fetchAddEventFeedback(Map<String, dynamic> data) async {
    var response =
        await http.post<Map>('/call/center/customer/back/create', data: data);
    return response.data;
  }

  //主键查询反馈事件内容
  static Future fetchEventFeedbackDetail(String id) async {
    var response = await http.get<Map>('/call/center/customer/back/$id');
    return EventFeedback.fromJson(response.data);
  }

  //修改反馈事件信息
  static Future fetchEditEventFeedback(
      String id, Map<String, dynamic> data) async {
    await http.put('/call/center/customer/back/$id', data: data);
  }

  //新增反馈图片
  static Future fetchAddEventImage(Map<String, dynamic> data) async {
    var response =
        await http.post('/call/center/customer/back/image', data: data);
    return response.data;
  }

  //删除反馈图片
  static Future fetchDeleteEventImage(String id, String updateAt) async {
    await http.delete('/call/center/customer/back/image/$id',
        queryParameters: {"updateAt": updateAt});
  }

  //获取反馈图片列表
  static Future fetchEventImageList(String id) async {
    var response = await http.post('/call/center/customer/back/image/list',
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
    await http.post('/call/center/customer/back/message', data: data);
  }

  //对象查询关联回复信息
  static Future fetchEventReplyList(String customerBackId) async {
    var response = await http.post('/call/center/customer/back/message/list',
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
        await http.get<Map<String, dynamic>>('/oss/sts');
    OssSts ossSts = OssSts.fromJson(response.data);
    return ossSts;
  }

  ///获取标本箱
  static Future fetchBoxList(String labId, String userId) async {
    Response<List> response =
        await http.get<List>('/order/lab/$labId/box/conf/$userId');
    return response;
  }

  ///根据箱号和人员查询当前未完成最新交接单ID
  static Future<String> fetchDeliveryId(
      {String boxNo, String labId, String recordId}) async {
    Response response = await http.post(
        '/order/lab/$labId/box/join/un/finish/current/new',
        data: {"boxNo": boxNo, 'recordId': recordId});
    return response.data.toString();
  }

  ///查询标本箱交接表详情
  static Future<DeliveryDetailModel> fetchDeliveryDetail(
      {String labId, String id}) async {
    Response response = await http.get('/order/lab/$labId/box/join/$id');
    return DeliveryDetailModel.fromJson(response.data);
  }

  ///新增标本箱交接表
  static Future<DeliveryDetailModel> fetchAddDelivery(
      {String labId, String id, Map<String, dynamic> data}) async {
    Response response =
        await http.put('/order/lab/$labId/box/join/item/$id', data: data);
    return DeliveryDetailModel.fromJson(response.data);
  }

  ///确认标本箱交接表
  static Future fetchConfirmDelivery(String id) async {
    Response response = await http.put('/order/lab/box/join/confirm/$id');
    return response;
  }

  ///修改标本箱交接明细状态
  static Future fetchConfirmDeliveryItem(String id, String status) async {
    Response response = await http.put('/order/lab/box/join/item/$id/$status');
    return response;
  }

  ///修改标本箱交接明细温度表
  static Future fetchChangeDeliveryTemperature(
      {String id, String labId, Map<String, dynamic> data}) async {
    Response response = await http
        .put('/order/lab/$labId/box/join/item/temperature/$id', data: data);
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
    Response response = await http.post('/files/batch/make/up', data: params);
    List<FileUploadItem> items = List<FileUploadItem>.from(
        response.data.map((e) => FileUploadItem.fromJson(e)));
    return items;
  }

  ///待合箱标本箱列表查询
  static Future fetchCombinedBoxes({String userId, String labId}) async {
    Response response = await http.post(
        '/order/lab/$labId/box/transport/wait/combined',
        data: {"userId": userId});
    return response;
  }
}
