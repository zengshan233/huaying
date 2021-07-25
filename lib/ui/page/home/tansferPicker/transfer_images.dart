import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:huayin_logistics/base/flavor_config.dart';
import 'package:huayin_logistics/model/specimen_box_arrive_data_model.dart';
import 'package:huayin_logistics/ui/color/DiyColors.dart';
import 'package:huayin_logistics/ui/widget/comon_widget.dart';
import 'package:huayin_logistics/ui/widget/image_swiper.dart';

class TransferImages extends StatelessWidget {
  final bool isSend;
  final SpecimenboxArriveItem item;
  TransferImages({this.isSend = false, this.item});

  @override
  Widget build(BuildContext context) {
    List<ImageItem> receiveImages =
        (isSend ? item.sendImages : item.receiveImages) ?? [];
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
                isSend ? '上传的图片' : '已签收',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(44),
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              )),
          Container(
            width: ScreenUtil().setWidth(700),
            // height: ScreenUtil().setWidth(500),
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(35)),
            child: receiveImages.isEmpty
                ? Container(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      noDataWidget(text: '暂无图片'),
                    ],
                  ))
                : Wrap(
                    spacing: ScreenUtil().setWidth(70),
                    children: receiveImages
                        .map((e) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ImageSwiper(
                                            index: receiveImages
                                                .indexWhere((i) => i == e),
                                            imgUrls: receiveImages
                                                .map((r) => r.url)
                                                .toList(),
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(40)),
                              width: ScreenUtil().setWidth(158),
                              height: ScreenUtil().setWidth(158),
                              color: Color(0xFFf0f2f5),
                              child: Image.network(
                                FlavorConfig.instance.imgPre +
                                    (e.thumbnailUrl ?? e.url ?? ''),
                                fit: BoxFit.cover,
                              ),
                            )))
                        .toList()),
          ),
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  width: ScreenUtil().setWidth(850),
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(40)),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(width: 0.5, color: Color(0xFFe5e5e5)),
                    bottom: BorderSide(width: 0.5, color: Color(0xFFe5e5e5)),
                  )),
                  alignment: Alignment.center,
                  child: Text(
                    '确定',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(44),
                      fontWeight: FontWeight.bold,
                      color: DiyColors.heavy_blue,
                    ),
                  ))),
        ],
      ),
    );
  }
}
