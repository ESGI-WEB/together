class JWT {
  String token;

  JWT({required this.token});

  factory JWT.fromJson(Map<String, dynamic> json) {
    return JWT(token: json['token']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    return data;
  }
}
