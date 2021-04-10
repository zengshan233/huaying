import 'package:flutter/material.dart';

class GlobalConfig {
  	//颜色
  	static const Color borderColor =Color.fromRGBO(288, 288, 288, 0.1); //border颜色

	//全局路由指代，避免使用content
	static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();	

}
