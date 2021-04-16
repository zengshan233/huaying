import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/specimen_type_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';

class SelectSpecimenTypeModel extends ViewStateRefreshListModel {
  String keyword;
  String labId;

  SelectSpecimenTypeModel({this.keyword, this.labId});

  @override
  Future<List<SpecimenTypeItem>> loadData({int pageNum}) async {
    var response =
        await Repository.fetchSelectSpecimentTypeList(keyword, pageNum, labId);
    List<SpecimenTypeItem> items = List<SpecimenTypeItem>.from(
        response.map((e) => SpecimenTypeItem.fromJson(e)));
    return items;
  }
}
