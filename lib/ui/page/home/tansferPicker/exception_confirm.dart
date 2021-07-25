import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/config/net/repository.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/model/file_upload_data_model.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/img_picker.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/transfer_picker_model.dart';
import 'package:huayin_logistics/view_model/mine/mine_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class ExceptionConfirm extends StatefulWidget {
  final SpecimenboxArriveItem item;
  final TransferPickerModel model;
  final Function update;
  ExceptionConfirm({this.item, this.model, this.update});
  @override
  _ExceptionConfirm createState() => _ExceptionConfirm();
}

class _ExceptionConfirm extends State<ExceptionConfirm> {
  TextEditingController remarkCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool exception = widget.item.exceptionRemark != null;
    return Container(
      width: ScreenUtil().setWidth(850),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Container(
              width: ScreenUtil().setWidth(920),
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(50),
                bottom: ScreenUtil().setHeight(50),
              ),
              alignment: Alignment.center,
              child: Text(
                '状态: ${exception ? '异常' : '正常'}',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(44),
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              )),
          Container(
              width: ScreenUtil().setWidth(920),
              alignment: Alignment.center,
              child: Text(
                exception ? widget.item.exceptionRemark : '若有异常请填写备注',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(40),
                  color: Color(0xFF333333),
                ),
              )),
          exception
              ? Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(50),
                    bottom: ScreenUtil().setHeight(20),
                  ),
                )
              : Container(
                  width: ScreenUtil().setWidth(700),
                  height: ScreenUtil().setWidth(300),
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(50),
                    bottom: ScreenUtil().setHeight(50),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(35)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Color(0xFFcccccc)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    scrollPadding: EdgeInsets.all(0),
                    autofocus: false,
                    controller: remarkCon,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(40),
                      color: Color.fromRGBO(90, 90, 91, 1),
                    ),
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '请输入备注',
                        hintStyle: TextStyle(color: Color(0xFFcccccc)),
                        contentPadding:
                            EdgeInsets.only(top: ScreenUtil().setWidth(10))),
                  ),
                ),
          Container(
            width: ScreenUtil().setWidth(850),
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(width: 0.5, color: Color(0xFFe5e5e5)),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                exception
                    ? Container()
                    : Expanded(
                        child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(40)),
                            alignment: Alignment.center,
                            child: Text(
                              '取消',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(44),
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            )),
                      )),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          if (exception) {
                            Navigator.pop(context);
                            return;
                          }
                          confirm(context);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(40)),
                            decoration: BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                  width: 0.5, color: Color(0xFFe5e5e5)),
                            )),
                            alignment: Alignment.center,
                            child: Text(
                              '确定',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(44),
                                fontWeight: FontWeight.bold,
                                color: DiyColors.heavy_blue,
                              ),
                            )))),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool checkData() {
    if (remarkCon.text.isEmpty) {
      showMsgToast('请输入备注');
      return false;
    }
    return true;
  }

  confirm(BuildContext context) async {
    if (!checkData()) {
      return;
    }
    widget.model.specimenExceptionOperate(
        itemId: widget.item.id,
        confirmRemark: remarkCon.text,
        callBack: () async {
          int idx =
              widget.model.list.indexWhere((element) => element == widget.item);
          widget.model.list[idx].exceptionRemark = remarkCon.text;
          Navigator.pop(context);
          showMsgToast('确认成功', context: context, onDismiss: () {
            Navigator.pop(context);
            widget.update();
          });
        });
  }
}
