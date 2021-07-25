class PageResponse<T> {
  int rowsCount;
  int pageNumber;
  int pageSize;
  int pageCount;
  List<T> records;
  PageResponse({
    this.rowsCount,
    this.pageNumber,
    this.pageSize,
    this.pageCount,
    this.records,
  });

  PageResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJson) {
    rowsCount = json['rowsCount'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    pageCount = json['pageCount'];
    if (json['records'] != null) {
      records = new List<T>();
      json['records'].forEach((v) {
        records.add(fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(Function(T) json) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowsCount'] = this.rowsCount;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['pageCount'] = this.pageCount;
    if (this.records != null) {
      data['records'] = this.records.map((v) => json(v)).toList();
    }
    return data;
  }
}
