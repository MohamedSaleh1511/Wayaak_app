class Data {
  String? name;
  String? email;
  String? message;

  Data({this.name, this.email, this.message});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json['name'] as String?,
        email: json['email'] as String?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'message': message,
      };
}
