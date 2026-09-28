class Message {
  String? ar;
  String? en;

  Message({this.ar, this.en});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        ar: json['ar'] as String?,
        en: json['en'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'ar': ar,
        'en': en,
      };
}
