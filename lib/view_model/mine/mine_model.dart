import 'package:aesCipher/aesCipher.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/storage_manager.dart';
import 'package:huayin_logistics/model/login_data_model.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';

const String PHONE_ENCRPT_KEY = 'HYPHONEKEY123456';

class MineModel extends ViewStateModel {
  static const String kUser = 'userInfo';
  static const String kUserName = 'username';
  static const String kPassword = 'userpassword';
  static const String kExpire = 'expire';

  /// 暂时写死
  String get labId => '82858490362716212';

  LoginDataModel _user;

  LoginDataModel get user => _user;

  bool get hasUser => user != null;

  MineModel() {
    var userMap = StorageManager.localStorage.getItem(kUser);
    _user = userMap != null ? LoginDataModel.fromJson(userMap) : null;
    //debugPrint('用户信息'+_user.user.name);
  }

  saveUser(LoginDataModel user, {String accountName, String password}) async {
    _user = user;
    notifyListeners();
    await StorageManager.localStorage.setItem(kUser, user);
    if (password != null && accountName != null) {
      DateTime now = DateTime.now();
      String expire = now.add(Duration(days: 7)).toString().split('.').first;
      await StorageManager.localStorage.setItem(kExpire, expire);
      String _accountNameEncrypt =
          await AesCipher.encrypt(data: accountName, key: PHONE_ENCRPT_KEY);
      await StorageManager.localStorage.setItem(kUserName, _accountNameEncrypt);
      String _passwordEncrypt =
          await AesCipher.encrypt(data: password, key: PHONE_ENCRPT_KEY);
      StorageManager.localStorage.setItem(kPassword, _passwordEncrypt);
    }
  }

  static Future<bool> refreshUser() async {
    String expire = StorageManager.localStorage.getItem(kExpire);
    if (expire == null) {
      return false;
    }
    String accountName = StorageManager.localStorage.getItem(kUserName);
    String password = StorageManager.localStorage.getItem(kPassword);
    int now = DateTime.now().millisecondsSinceEpoch;
    int expireTime = DateTime.parse(expire).millisecondsSinceEpoch;
    if (now <= expireTime) {
      if (password != null && accountName != null) {
        String _accountName =
            await AesCipher.decrypt(data: accountName, key: PHONE_ENCRPT_KEY);
        String _password =
            await AesCipher.decrypt(data: password, key: PHONE_ENCRPT_KEY);
        var user = await Repository.fetchAccountLogin(_accountName, _password);
        StorageManager.localStorage.setItem(kUser, user);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
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
