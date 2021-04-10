import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';

class SelectItemModel extends ViewStateRefreshListModel {
  BuildContext context;

  String keyword;

  String itemType;

  String labDeptId;

  SelectItemModel({this.context, this.itemType, this.keyword, this.labDeptId});

  var yyDialog;
  //获取选择项目左侧菜单
  Future<SelectItemLeftMenu> selectItemLeftMenuData(String boxNo) async {
    setBusy();
    try {
      var response = await Repository.fetchSelectItemLeftMenu(boxNo);
      setIdle();
      return response;
    } catch (e, s) {
      print("selectItemLeftMenuData error $e ");
      setError(e, s);
      showErrorMessage(context);
      return null;
    }
  }

  @override
  Future<List<SelectItemRightListItem>> loadData({int pageNum}) async {
    var response = await Repository.fetchSelectItemRightList(
        keyword, itemType, labDeptId, pageNum);
    return response == null ? [] : response;
  }
}

class SelectCompanyModel extends ViewStateRefreshListModel {
  String custName;
  String organizId;

  SelectCompanyModel({this.custName, this.organizId});

  @override
  Future<List<SelectCompanyListItem>> loadData({int pageNum}) async {
    var response =
        await Repository.fetchSelectCompanyList(custName, pageNum, organizId);
    return response == null ? [] : response;
  }
}
