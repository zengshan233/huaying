import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/global_config.dart';
import 'package:huayin_logistics/config/resource_mananger.dart';
import 'package:huayin_logistics/ui/helper/gaps.dart';
import 'package:huayin_logistics/ui/widget/dialog/alert_dialog.dart';

class MutilProjects extends StatelessWidget {
  List<Map<String, dynamic>> submitData;
  final Function(String) addProject;
  final Function(String) delete;
  MutilProjects({Key key, this.submitData, this.addProject, this.delete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return new Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(60)),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0)),
      child: _listView(context),
    );
  }

  Widget _listView(BuildContext context) {
    return submitData.length <= 5
        ? Column(
            children: List.generate(
                submitData.length, (index) => _recordItem(context, index)),
          )
        : Container(
            height: ScreenUtil().setHeight(700),
            child: ListView(
              children: List.generate(
                  submitData.length, (index) => _recordItem(context, index)),
            ),
          );

    // CustomScrollView(
    //   slivers: <Widget>[
    //     SliverList(
    //       delegate: SliverChildBuilderDelegate(
    //         (ctx, index) => _recordItem(context, index),
    //         childCount: submitData.length,
    //       ),
    //     )
    //   ],
    // );
  }

  Widget _recordItem(BuildContext context, int index) {
    var item = submitData[index];
    String barCode = item['main']['barCode'].toString();
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Text(
                    (submitData.length - index).toString(),
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                  flex: 8,
                  child: Text(
                    barCode,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(44),
                        color: Color.fromRGBO(90, 90, 91, 1)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Image.asset(
                        ImageHelper.wrapAssets(item['items'].length > 0
                            ? 'record_project_select.png'
                            : 'record_project_unselect.png'),
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                        fit: BoxFit.scaleDown,
                      ),
                      onPressed: () {
                        addProject(barCode);
                      },
                    ),
                  )),
              Gaps.hGap8,
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Image.asset(
                      ImageHelper.wrapAssets(item['imageIds'].length > 0
                          ? 'record_photo.png'
                          : 'record_photo_empty.png'),
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setWidth(60),
                      fit: BoxFit.scaleDown,
                    ),
                  )),
              Gaps.hGap8,
              Expanded(
                  flex: 2,
                  child: Container(
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Image.asset(
                        ImageHelper.wrapAssets('delete.png'),
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                        fit: BoxFit.scaleDown,
                      ),
                      onPressed: () {
                        yyAlertDialogWithDivider(
                            tip: "确认是否删除？",
                            success: () {
                              delete(item['main']['barCode']);
                            });
                      },
                    ),
                  )),
            ],
          ),
          Divider(color: GlobalConfig.borderColor, height: 0.5),
        ],
      ),
    );
  }
}
