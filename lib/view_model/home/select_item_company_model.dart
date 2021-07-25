import 'package:flutter/cupertino.dart';
import 'package:huayin_logistics/model/select_item_company_data_model.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';
import 'package:huayin_logistics/utils/popUtils.dart';

class SelectItemModel extends ViewStateRefreshListModel<SelectProjectItem> {
  BuildContext context;

  String keyword;

  String itemType;

  String labDeptId;

  SelectItemModel({this.context, this.itemType, this.keyword, this.labDeptId});

  var yyDialog;

  Future<List<ProjectDetailItem>> loadDetail(String dictId) async {
    PopUtils.showLoading();
    List<ProjectDetailItem> response;
    try {
      response = await Repository.fetchSelectItemDetail(dictId);
    } catch (e, s) {
      PopUtils.dismiss();
      setError(e, s, errState: false);
      showErrorMessage(context);
      return null;
    }
    PopUtils.dismiss();
    return response == null ? [] : response;
  }

  @override
  Future<List<SelectProjectItem>> loadData({int pageNum}) async {
    var response;
    try {
      response = await Repository.fetchSelectItemRightList(
          keyword, itemType, labDeptId, pageNum);
    } catch (e, s) {
      setError(e, s, errState: false);
      showErrorMessage(context);
      return null;
    }
    return response == null ? [] : response;
  }
}

class SelectCompanyModel extends ViewStateRefreshListModel {
  String custName;
  BuildContext context;

  SelectCompanyModel({this.custName, this.context});

  @override
  Future<List<SelectCompanyListItem>> loadData({int pageNum}) async {
    var response;
    try {
      response = await Repository.fetchSelectCompanyList(custName, pageNum);
    } catch (e, s) {
      setError(e, s, errState: false);
      showErrorMessage(context);
      return null;
    }
    return response == null ? [] : response;
  }
}
