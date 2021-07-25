import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/page/home/tansferPicker/exception_confirm.dart';
import 'package:huayin_logistics/ui/page/home/tansferPicker/transfer_confirm.dart';
import 'package:huayin_logistics/ui/page/home/tansferPicker/transfer_images.dart';
import 'package:huayin_logistics/utils/popUtils.dart';
import 'package:huayin_logistics/view_model/home/transfer_picker_model.dart';

class TransferItem extends StatelessWidget {
  final SpecimenboxArriveItem item;
  final TransferPickerModel model;
  final Function(bool) update;
  TransferItem({this.item, this.model, this.update});

  @override
  Widget build(BuildContext context) {
    bool signed = item.status == 2;
    bool exception = item.exceptionRemark != null;
    return InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
              color: exception ? Color(0xFFfff0f0) : Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xFFf0f0f0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            item.estimateArriveAt.substring(0, 10),
                            style: TextStyle(
                                color: exception
                                    ? Color(0xFFf53740)
                                    : Color(0xFF333333),
                                fontSize: ScreenUtil().setSp(36)),
                          ),
                          Text(
                            item.estimateArriveAt.substring(10, 16),
                            style: TextStyle(
                                color: exception
                                    ? Color(0xFFf53740)
                                    : Color(0xFF333333),
                                fontSize: ScreenUtil().setSp(36)),
                          ),
                        ],
                      ))),
              Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      item.lineName,
                      style: TextStyle(
                          color:
                              exception ? Color(0xFFf53740) : Color(0xFF333333),
                          fontSize: ScreenUtil().setSp(38)),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: InkWell(
                      onTap: () {
                        PopUtils.showPop(
                            opacity: 0.5,
                            clickDismiss: true,
                            child: TransferImages(
                              item: item,
                              isSend: true,
                            ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          item.boxNo,
                          style: TextStyle(
                              color: exception
                                  ? Color(0xFFf53740)
                                  : Color(0xFF333333),
                              fontSize: ScreenUtil().setSp(38)),
                        ),
                      ))),
              Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(children: <Widget>[
                    InkWell(
                      onTap: () {
                        PopUtils.showPop(
                            opacity: 0.5,
                            clickDismiss: true,
                            child: ExceptionConfirm(
                              item: item,
                              model: model,
                              update: () {
                                update?.call(false);
                              },
                            ));
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(170),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20),
                            vertical: ScreenUtil().setWidth(5)),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: exception
                                    ? Color(0xFFf53740)
                                    : DiyColors.heavy_blue),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(40)))),
                        alignment: Alignment.center,
                        child: Text(
                          exception ? '异常' : '正常',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(38),
                              color: exception
                                  ? Color(0xFFf53740)
                                  : DiyColors.heavy_blue),
                        ),
                      ),
                    )
                  ]))),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            PopUtils.showPop(
                                opacity: 0.5,
                                clickDismiss: true,
                                child: signed
                                    ? TransferImages(
                                        item: item,
                                      )
                                    : TransferConfirm(
                                        item: item,
                                        model: model,
                                        success: () {
                                          model.list
                                              .removeWhere((l) => l == item);
                                          update?.call(true);
                                        },
                                      ));
                          },
                          child: Container(
                            width: ScreenUtil().setWidth(170),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(5)),
                            decoration: BoxDecoration(
                                color: signed
                                    ? Color(0xFFf2f2f2)
                                    : Colors.transparent,
                                border: Border.all(
                                    width: 1,
                                    color: signed
                                        ? Color(0xFFdcdcdc)
                                        : DiyColors.heavy_blue),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    ScreenUtil().setWidth(40)))),
                            alignment: Alignment.center,
                            child: Text(
                              signed ? '已签' : '签收',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(38),
                                  color: signed
                                      ? Color(0xFFcccccc)
                                      : DiyColors.heavy_blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
