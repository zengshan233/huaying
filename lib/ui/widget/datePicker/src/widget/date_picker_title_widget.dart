import 'package:flutter/material.dart';

import '../date_picker_constants.dart';
import '../date_picker_theme.dart';
import '../i18n/date_picker_i18n.dart';

/// DatePicker's title widget.
///
/// @author dylan wu
/// @since 2019-05-16
class DatePickerTitleWidget extends StatelessWidget {
  DatePickerTitleWidget({
    Key key,
    this.pickerTheme,
    this.locale,
    this.title,
    @required this.onCancel,
    @required this.onConfirm,
  }) : super(key: key);

  final DateTimePickerTheme pickerTheme;
  final DateTimePickerLocale locale;
  final DateVoidCallback onCancel, onConfirm;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (pickerTheme.title != null) {
      return pickerTheme.title;
    }
    return Container(
      height: pickerTheme.titleHeight,
      decoration: BoxDecoration(
          color: pickerTheme.backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderCancelWidget(context),
          _renderTitleWidget(),
          _renderConfirmWidget(context),
        ],
      ),
    );
  }

  Widget _renderTitleWidget() {
    return title == null
        ? Container()
        : Container(
            child: Text(
            title,
            style: TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ));
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // has custom title button widget
      if (pickerTheme.cancel == null) {
        return Offstage();
      }
    }

    Widget cancelWidget = pickerTheme.cancel;
    if (cancelWidget == null) {
      TextStyle textStyle = pickerTheme.cancelTextStyle ??
          TextStyle(
            color: Color(0xFF666666),
            fontSize: 14.0,
          );
      cancelWidget = Text(
        DatePickerI18n.getLocaleCancel(locale),
        style: textStyle,
      );
    }

    return Container(
      height: pickerTheme.titleHeight,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: cancelWidget,
        onPressed: () => this.onCancel(),
      ),
    );
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // has custom title button widget
      if (pickerTheme.confirm == null) {
        return Offstage();
      }
    }

    Widget confirmWidget = pickerTheme.confirm;
    if (confirmWidget == null) {
      TextStyle textStyle = pickerTheme.confirmTextStyle ??
          TextStyle(
            color: Color(0xFF4080ff),
            fontSize: 14.0,
          );
      confirmWidget = Text(
        DatePickerI18n.getLocaleDone(locale),
        style: textStyle,
      );
    }

    return Container(
      height: pickerTheme.titleHeight,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: confirmWidget,
        onPressed: () => this.onConfirm(),
      ),
    );
  }

  bool isCustomTitleWidget() {
    return pickerTheme.cancel != null ||
        pickerTheme.confirm != null ||
        pickerTheme.title != null;
  }
}
