class Paginated<DataType> {
  final int limit;
  final int page;
  final String sort;
  final int total;
  final int pages;
  final List<DataType> rows;

  Paginated({
    required this.limit,
    required this.page,
    required this.sort,
    required this.total,
    required this.pages,
    required this.rows,
  });

  factory Paginated.fromJson(Map<String, dynamic> json, DataType Function(Map<String, dynamic>) fromJson) {
    return Paginated(
      limit: json['limit'],
      page: json['page'],
      sort: json['sort'],
      total: json['total'],
      pages: json['pages'],
      rows: (json['rows'] as List).map((e) => fromJson(e)).toList(),
    );
  }
}