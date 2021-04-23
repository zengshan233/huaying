import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/model/user_model.dart';
import 'package:huayin_logistics/provider/view_state_refresh_list_model.dart';

class SelectUserModel extends ViewStateRefreshListModel {
  String labId;
  String name;

  SelectUserModel({this.labId, this.name});

  @override
  Future<List<UserModel>> loadData({int pageNum}) async {
    List<UserModel> response = await Repository.fetchUserList(labId: labId);
    if(name !=null && name.isNotEmpty ){
    response = response.where((r) => r.name.contains(name)).toList();
    }
    return response == null ? [] : response;
  }
}
