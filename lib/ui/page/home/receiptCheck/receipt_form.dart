import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/model/check_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/info_form_item.dart';
import 'package:huayin_logistics/view_model/home/check_model.dart';

class ReceiptForm extends StatelessWidget {
  final int status;
  final String statusName;
  final CheckModel model;
  ReceiptForm({this.status, this.statusName, this.model});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Column(children: <Widget>[
      InfoFormItem(
          lable: '录单文员',
          text: model.checkDetail?.apply?.recordName ?? '',
          rightWidget: Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
                vertical: ScreenUtil().setWidth(15)),
            decoration: BoxDecoration(
                color: status != 2 ? Colors.white : Color(0xFFd6e6ff),
                border: Border.all(
                    width: status != 2 ? 1 : 0, color: Color(0xFFf0f0f0)),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            alignment: Alignment.center,
            child: Text(
              statusName,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(40),
                  color:
                      status != 2 ? Color(0xFFcccccc) : DiyColors.heavy_blue),
            ),
          )),
      InfoFormItem(
          lable: '录入时间', text: model.checkDetail?.apply?.recordTime ?? ""),
      InfoFormItem(
          lable: '标本条码', text: model.checkDetail?.apply?.barCode ?? ""),
      InfoFormItem(
          lable: '送检单位',
          text: model.checkDetail?.apply?.inspectionUnitName ?? ""),
      InfoFormItem(lable: '姓名', text: model.checkDetail?.apply?.name ?? ""),
      InfoFormItem(lable: '性别', text: model.checkDetail?.apply?.sexName ?? ""),
      InfoFormItem(lable: '年龄', text: model.checkDetail?.apply?.age ?? ""),
      InfoFormItem(
          lable: '出生日期',
          text: model.checkDetail?.apply?.birthDate?.substring?.call(0, 16) ??
              ''),
      InfoFormItem(
          lable: '门诊/住院号',
          text: model.checkDetail?.apply?.outpatientNumber ?? ""),
      InfoFormItem(
          lable: '就诊类型', text: model.checkDetail?.apply?.visitTypeName ?? ""),
      InfoFormItem(lable: '身份证号', text: model.checkDetail?.apply?.idCard ?? ""),
      InfoFormItem(
          lable: '科室/病区', text: model.checkDetail?.apply?.wardName ?? ""),
      InfoFormItem(
          lable: '床号', text: model.checkDetail?.apply?.sickbedNumber ?? ""),
      InfoFormItem(
          lable: '采样时间',
          text:
              model.checkDetail?.apply?.collectorTime?.substring?.call(0, 16) ??
                  ''),
      InfoFormItem(
          lable: '申请日期',
          text: model.checkDetail?.apply?.applyDate?.substring?.call(0, 16) ??
              ''),
      InfoFormItem(
          lable: '送检医生', text: model.checkDetail?.apply?.applyDoctorName ?? ""),
      InfoFormItem(
          lable: '医生电话', text: model.checkDetail?.apply?.doctorPhone ?? ""),
      InfoFormItem(
          lable: '标本状态',
          text: model.checkDetail?.apply?.specimenStatusName ?? ""),
      InfoFormItem(
          lable: '结算方式', text: model.checkDetail?.apply?.finsTypeName ?? ""),
      InfoFormItem(
          lable: '申请单号', text: model.checkDetail?.apply?.applyNo ?? ""),
      InfoFormItem(lable: '手机号码', text: model.checkDetail?.apply?.phone ?? ""),
      InfoFormItem(
          lable: '临床诊断',
          text: model.checkDetail?.apply?.clinicalDiagnosis ?? ""),
      InfoFormItem(lable: '备注', text: model.checkDetail?.apply?.remark ?? ""),
      InfoFormItem(
          lable: '合作医院', text: model.checkDetail?.apply?.th3CustomerName ?? ""),
      InfoFormItem(
          lable: '医院条码', text: model.checkDetail?.apply?.hospitalCode ?? ""),
    ]));
  }
}
