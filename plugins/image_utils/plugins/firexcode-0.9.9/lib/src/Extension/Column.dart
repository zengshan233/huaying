import 'package:flutter/material.dart';

extension ColumnWudget on List<Widget?> {
  Widget xcolumn(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnSS(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnBS(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.start,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnES(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnSTS(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      key: key,
      children: this as List<Widget>,
    );
  }

  //----------------------------------------------------------  end  start

  Widget xcolumnSTC(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnSC(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnEC(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnCC(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnBC(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.center,
      key: key,
      children: this as List<Widget>,
    );
  }

  // ------------------------------------------------------------ emd center

  Widget xcolumnSTE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnSE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnEE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnCE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnBE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.end,
      key: key,
      children: this as List<Widget>,
    );
  }

  // ------------------------------------------------------------ emd end

  Widget xcolumnSTSA(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnSSA(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnESA(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnCSA(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnBSA(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      key: key,
      children: this as List<Widget>,
    );
  }

  // ------------------------------------------------------------- end spaceAround

  Widget xcolumnSTSB(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnSSB(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnESB(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnCSB(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnBSB(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      key: key,
      children: this as List<Widget>,
    );
  }

  // ------------------------------------------------------------- end spaceBetween
  Widget xcolumnSTSE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnSSE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnESE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnCSE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      key: key,
      children: this as List<Widget>,
    );
  }

  Widget xcolumnBSE(
      {Key? key,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      TextBaseline? textBaseline,
      TextDirection? textDirection,
      VerticalDirection verticalDirection = VerticalDirection.down}) {
    return Column(
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      key: key,
      children: this as List<Widget>,
    );
  }
}
