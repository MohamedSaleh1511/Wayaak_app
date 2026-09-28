class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? birthDate;
  String? language;
  String? avatar;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.language,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        gender: json['gender'] as String?,
        birthDate: json['birth_date'] as String?,
        language: json['language'] as String?,
        avatar: json['avatar'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'birth_date': birthDate,
        'language': language,
        'avatar': avatar,
      };
}
