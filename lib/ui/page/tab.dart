import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './home/home.dart';
import './news/news.dart';
import './mine/mine.dart';

List<Widget> pages = <Widget>[Home(), News(), Mine()];

class TabNavigator extends StatefulWidget {
  TabNavigator({Key key}) : super(key: key);

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  var _pageController = PageController();
  int _selectedIndex = 0;
  DateTime _lastPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            if (_lastPressed == null ||
                DateTime.now().difference(_lastPressed) >
                    Duration(seconds: 1)) {
              //两次点击间隔超过1秒则重新计时
              _lastPressed = DateTime.now();
              return false;
            }
            return true;
          },
          child: PageView.builder(
            itemBuilder: (ctx, index) => pages[index],
            itemCount: pages.length,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              //print('索引--'+index.toString());
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
           bottomNavigationBar: BottomNavigationBar(
             type: BottomNavigationBarType.fixed,
             items: <BottomNavigationBarItem>[
               BottomNavigationBarItem(
                 icon: Image.asset(_selectedIndex == 0
					 ? 'assets/images/main_home_selected.png'
					 : 'assets/images/main_home_normal.png',
					 width: ScreenUtil().setWidth(100),
					 height: ScreenUtil().setWidth(100)),
                 title: Text('首页'),
               ),
               BottomNavigationBarItem(
                 icon: Image.asset(_selectedIndex == 1
					 ? 'assets/images/main_message_selected.png'
					 : 'assets/images/main_message_normal.png',
					 width: ScreenUtil().setWidth(100),
					 height: ScreenUtil().setWidth(100)),
                 title: Text('消息'),
               ),
               BottomNavigationBarItem(
                 icon: Image.asset(_selectedIndex == 2
					 ? 'assets/images/main_mine_selected.png'
					 : 'assets/images/main_mine_normal.png',
					 width: ScreenUtil().setWidth(100),
					 height: ScreenUtil().setWidth(100)),
                 title: Text('我的'),
               ),
             ],
             currentIndex: _selectedIndex,
             onTap: (index) {
               _pageController.jumpToPage(index);
             },
           ));
  }

  @override
  void initState() {
    super.initState();
  }
}
