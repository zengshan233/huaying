import 'dart:convert';
import 'dart:ui';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class StringUtils {
	static String toMD5(String data) {
		var content = new Utf8Encoder().convert(data);
		var digest = md5.convert(content);
		return hex.encode(digest.bytes);
	}
	static Color hexToColor(int hex,{double alpha = 1}) {
		// StringUtils.hexColor(0x3caafa)//透明度为1
		// StringUtils.hexColor(0x3caafa,alpha: 0.5)//透明度为0.5
		if (alpha < 0){
			alpha = 0;
		}else if (alpha > 1){
			alpha = 1;
		}
		return Color.fromRGBO((hex & 0xFF0000) >> 16 ,
			(hex & 0x00FF00) >> 8,
			(hex & 0x0000FF) >> 0,
			alpha);
	}

	static String enumName(String enumToString) {
    	List<String> paths = enumToString.split(".");
    	return paths[paths.length - 1];
  	}
}
