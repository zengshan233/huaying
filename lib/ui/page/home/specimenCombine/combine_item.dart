import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/model/delivery_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';
import 'package:huayin_logistics/ui/widget/multi_select.dart';
import 'package:huayin_logistics/view_model/home/specimen_combine_model.dart';

class ReceiveItem extends StatelessWidget {
  final SpecimenCombinedItem item;
  final SpecimenCombineModel model;
  final Function update;
  ReceiveItem({this.item, this.model, this.update});

  @override
  Widget build(BuildContext context) {
    bool received = item.receiveStatus == 2;
    bool canReceived = item.receiveStatus == 0;
    bool unReceived = item.receiveStatus == 1;
    return InkWell(
        onTap: () {
          if (unReceived) {
            return;
          }
          model.addCombineItem(item);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    MultiSelect(
                      disable: unReceived,
                      select: model.combineBoxes.contains(item),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(item.boxNo,
                            style: TextStyle(color: Color(0xFF666666)))),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (!unReceived) {
                    return;
                  }
                  yyAlertDialogWithDivider(
                      tip: '是否确认接收？',
                      context: context,
                      success: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        model.specimenReceiveOperateData(
                          joinIds: [item.joinId],
                        ).then((val) {
                          if (val) {
                            int idx = model.combineList
                                .indexWhere((element) => element == item);
                            model.combineList[idx].receiveStatus = 2;
                            update();
                            showMsgToast('接收成功！', context: context);
                          }
                        });
                      });
                },
                child: Container(
                  width: ScreenUtil().setWidth(210),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(5)),
                  decoration: BoxDecoration(
                      color:
                          !unReceived ? Color(0xFFf2f2f2) : Colors.transparent,
                      border: Border.all(
                          width: 1,
                          color: !unReceived
                              ? Color(0xFFdcdcdc)
                              : DiyColors.heavy_blue),
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(40)))),
                  alignment: Alignment.center,
                  child: Text(
                    canReceived ? '可交接' : received ? '已接收' : '确认接收',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(38),
                        color: !unReceived
                            ? Color(0xFFcccccc)
                            : DiyColors.heavy_blue),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
