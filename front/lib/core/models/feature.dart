class Feature {
  final String slug;
  final bool enabled;

  Feature({
    required this.slug,
    required this.enabled,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      slug: json['slug'],
      enabled: json['enabled'],
    );
  }

}
