class Receiver {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;

  Receiver({this.id, this.name, this.email, this.phone, this.avatar});

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        id: json['id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        avatar: json['avatar'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
      };
}
