class Data {
  String? content;

  Data({this.content});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        content: json['content'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'content': content,
      };
}
