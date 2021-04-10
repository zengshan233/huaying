import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

showPickerDate(BuildContext context,{Function callBack}) {
    new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
			type:PickerDateTimeType.kYMDHM,
			isNumberMonth: true,
        ),
        title: new Text("选择时间"),		
		cancelText:'取消',
		confirmText: '确认',
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          	//print((picker.adapter as DateTimePickerAdapter).value.toString().split('.')[0]);
			var valStr=((picker.adapter as DateTimePickerAdapter).value.toString().split('.')[0]).toString();
			callBack(valStr);
		}
    ).showDialog(context);
}


showPickerDateRange(BuildContext context,Function callBack) {
    //print("canceltext: ${PickerLocalizations.of(context).cancelText}");

    Picker ps = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          	return ((picker.adapter as DateTimePickerAdapter).value.toString().split(' ')[0]).toString();
        }
    );

    Picker pe = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(type: PickerDateTimeType.kYMD,isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          return ((picker.adapter as DateTimePickerAdapter).value.toString().split(' ')[0]).toString();
        }
    );

    List<Widget> actions = [
		FlatButton(
			onPressed: () {
				Navigator.pop(context);
			},
			child: new Text('取消')
		),
		FlatButton(
			onPressed: () {
				Navigator.pop(context);
				var sTimg=ps.onConfirm(ps, ps.selecteds);
				var seTimg=pe.onConfirm(pe, pe.selecteds);
				callBack(sTimg,seTimg);
			},
			child: new Text('确定')
		)
    ];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("选择时间"),
            actions: actions,
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("开始时间:"),
                  ps.makePicker(),
                  Text("结束时间:"),
                  pe.makePicker()
                ],
              ),
            ),
          );
	});
}

