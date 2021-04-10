import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huayin_logistics/config/storage_manager.dart';
import 'package:huayin_logistics/provider/view_state_model.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/progress_dialog.dart';
import 'mine_model.dart';

const String Token = 'token';
const int ErrorTime = 3;
const int CountDownTime = 60 * 1000;
const String CountDownTimeKey = 'countDownTime';

class LoginModel extends ViewStateModel {
  final MineModel mineModel;

  /// 倒数时间
  int _countDown = 0;

  /// 错误次数
  int _errorTime = 0;

  LoginModel(this.mineModel) {
    _countDown = StorageManager.sharedPreferences.getInt(CountDownTimeKey);
  }

  /// 获取倒数时间
  int get countDown => _countDown;

  /// 是否可以执行登录信息
  bool checkLoginEnable() {
    if (_countDown != null && _countDown > 0) {
      bool enable =
          DateTime.now().millisecondsSinceEpoch - _countDown > CountDownTime;
      if (enable) {
        this._errorTime = 0;
        this._countDown = 0;
        StorageManager.sharedPreferences.setInt(CountDownTimeKey, 0);
      }
      return enable;
    }
    return true;
  }

  var yyDialog;
  //账号登录
  Future<bool> login(String accountName, String password) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      var user = await Repository.fetchAccountLogin(accountName, password);
      mineModel.saveUser(user);
      setIdle();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      dialogDismiss(yyDialog);
      setError(e, s);
      return false;
    }
  }

  //获取验证码
  Future<bool> getCheckCode(String phoneNumber) async {
    setBusy();
    try {
      var getCode = await Repository.fetchPhoneCheckCode(phoneNumber);
      setIdle();
      if (!getCode) {
        showMsgToast('获取验证码失败！');
      }
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }

  //验证码登陆
  Future<bool> phoneLogin(String phoneNumber, String checkCode) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      var user = await Repository.fetchPhoneLogin(phoneNumber, checkCode);
      mineModel.saveUser(user);
      setIdle();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      return false;
    }
  }

  //修改密码
  Future<bool> fetchModifyPassword(
      String phoneNumber, String checkCode, String password) async {
    yyDialog = yyProgressDialogNoBody();
    setBusy();
    try {
      await Repository.fetchModifyPassword(phoneNumber, checkCode, password);
      setIdle();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      setError(e, s);
      dialogDismiss(yyDialog);
      return false;
    }
  }

  /// 根据旧密码修改新密码
  Future<bool> changePassword(String phoneNumber, String password,
      String newPassword, String id, String accountName) async {
    yyDialog = yyProgressDialogBody();
    setBusy();
    try {
      await Repository.changePassword(
          phoneNumber, password, newPassword, id, accountName);
      setIdle();
      _errorTime = 0;
      await StorageManager.sharedPreferences.setInt(CountDownTimeKey, 0);
      mineModel.clearUser();
      dialogDismiss(yyDialog);
      return true;
    } catch (e, s) {
      if (e is DioError) {
        if (e.type == DioErrorType.DEFAULT) {
          // incorrect status, such as 404, 503...
          debugPrint(e.toString());
          _errorTime++;
          if (_errorTime >= ErrorTime) {
            debugPrint("设置限制时长");
            _countDown = DateTime.now().millisecondsSinceEpoch;
            await StorageManager.sharedPreferences
                .setInt(CountDownTimeKey, _countDown);
          }
        }
      }
      setError(e, s);
      dialogDismiss(yyDialog);
      return false;
    }
  }
}
