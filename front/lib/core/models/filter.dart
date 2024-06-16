class Filter {
  final String column;
  final String operator;
  final String value;

  Filter({
    required this.column,
    required this.operator,
    required this.value,
  });

  toJson() {
    return {
      'column': column,
      'operator': operator,
      'value': value,
    };
  }
}
