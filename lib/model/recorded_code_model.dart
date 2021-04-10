class CodeItem {
  final String date;
  final String billno;
  final String number;
  final String status;
  CodeItem({this.date, this.billno, this.number, this.status});
}

class CodeDetailItem {
  final String number;
  final String specimen;
  final String date;
  final String end;
  final List<CodeProject> projects;
  final List<String> pics;
  CodeDetailItem(
      {this.number,
      this.specimen,
      this.date,
      this.end,
      this.projects,
      this.pics});
}

class CodeProject {
  final String name;
  final String category;
  final String type;
  CodeProject({this.name, this.category, this.type});
}
