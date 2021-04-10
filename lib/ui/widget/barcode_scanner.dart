import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class BarcodeScanner {

	Function success;
	BarcodeScanner({@required this.success});

	Future<void> scanBarcodeNormal() async {
		var barcodeScanRes = await scanner.scan();
		if (barcodeScanRes == null) {
			barcodeScanRes='-1';
		}
		success(barcodeScanRes);
	}
}


//调用方式
// void scan(){
// 	  	var p=new BarcodeScanner(success:(String code){
// 					print('条形码'+code);
// 					if (!mounted) return;
// 					setState(()=>{
// 						_scanBarcode=code
// 					});
// 				});
// 		p.scanBarcodeNormal();
//   }
