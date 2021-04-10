//验证手机号码
bool isPhone(String input) {
    RegExp mobile = new RegExp(r'(0|86|17951)?(13[0-9]|15[0-35-9]|17[0678]|18[0-9]|14[57])[0-9]{8}');
    return mobile.hasMatch(input);
}

//非空校验
bool isRequire(String input) {
    return input.isEmpty?false:true;
}

// 验证固定电话
bool isTel(String tel) {
  RegExp phone = new RegExp(r'^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$');
  return phone.hasMatch(tel);
}