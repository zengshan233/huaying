import 'package:flutter/material.dart';
import 'package:huayin_logistics/base/flavor_config.dart';

class ImageSwiper extends StatefulWidget {
  final int index;
  final List<String> imgUrls;
  ImageSwiper({this.index, this.imgUrls});
  @override
  State<StatefulWidget> createState() {
    return _ImageSwiperState();
  }
}

class _ImageSwiperState extends State<ImageSwiper>
    with SingleTickerProviderStateMixin {
  _ImageSwiperState();

  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: widget.imgUrls.isEmpty
                ? Container()
                : PageView(
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    reverse: false,
                    children: widget.imgUrls.map((url) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Image.network(
                                FlavorConfig.instance.imgPre + url,
                                fit: BoxFit.fitWidth,
                              )));
                    }).toList())));
  }
}
