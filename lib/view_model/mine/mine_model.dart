import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/storage_manager.dart';
import 'package:huayin_logistics/model/login_data_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';

class MineModel extends ViewStateModel {
  static const String kUser = 'userInfo';

  LoginDataModel _user;

  LoginDataModel get user => _user;

  bool get hasUser => user != null;

  MineModel() {
    var userMap = StorageManager.localStorage.getItem(kUser);
    _user = userMap != null ? LoginDataModel.fromJson(userMap) : null;
    //debugPrint('用户信息'+_user.user.name);
  }

  saveUser(LoginDataModel user) {
    _user = user;
    notifyListeners();
    StorageManager.localStorage.setItem(kUser, user);
  }

  /// 清除持久化的用户数据
  clearUser() {
    _user = null;
    notifyListeners();
    StorageManager.localStorage.deleteItem(kUser);
  }

  /// 获取用户信息
  Future fetchUserInfo() async {
    setBusy();
    await Repository.fetchUserInfo(_user.user.id).then((data) {
      this._user?.user = data;
      StorageManager.localStorage.setItem(kUser, user);
      setIdle();
    }).catchError((err, trace) {
      setError(err, trace);
    });
  }
}
