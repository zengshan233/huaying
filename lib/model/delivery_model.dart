class DeliveryItem {
  final String date;
  final String billno;
  final bool confirm;
  final bool check;
  DeliveryItem({this.date, this.billno, this.confirm, this.check});
}

class SpecimenBoxItem {
  final String name;
  final bool ice;
  final String code;
  SpecimenBoxItem({this.name, this.ice, this.code});
}
