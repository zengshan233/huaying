import 'package:firexcode/firexcode.dart';
import 'colors_picker.dart';

class ColorPiskersSlider extends StatefulWidget {
  @override
  _ColorPiskersSliderState createState() => _ColorPiskersSliderState();
}

class _ColorPiskersSliderState extends State<ColorPiskersSlider> {
  @override
  Widget build(BuildContext context) {
    return xColumn.list(
      [
        '色彩'.toUpperCase().text().toCenter(),
        Divider(
            // height: 1,
            ),
        20.0.sizedHeight(),
        '模糊度'.text(),
        //   10.0.sizedHeight(),
        xRowCC.list([
          BarColorPicker(
              width: 300,
              thumbColor: Colors.white,
              cornerRadius: 10,
              pickMode: PickMode.Color,
              colorListener: (int value) {
                setState(() {
                  //  currentColor = Color(value);
                });
              }).xExpanded(),
          '重置'.text().xFlatButton(onPressed: () {})
        ]),
        5.0.sizedHeight(),
        Text('透明度'),
        10.0.sizedHeight(),
        xRow.list([
          Slider(value: 0.1, min: 0.0, max: 1.0, onChanged: (v) {}).xExpanded(),
          '重置'.text().xFlatButton(onPressed: () {})
        ]),
      ],
    ).toContainer(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      padding: EdgeInsets.all(20),
      height: 240,
      color: Colors.white,
    );
  }
}
