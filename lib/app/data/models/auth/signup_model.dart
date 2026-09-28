class SignupRequestModel {
  String? name;
  String? storeName;
  String? storeAddress;
  String? aboutStore;
  String? type;
  String? email;
  String? phone;
  String? password;
  String? gender;
  String? birthDate;
  String? language;

  SignupRequestModel({
    this.password,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.language,
    this.aboutStore,
    this.storeAddress,
    this.storeName,
    this.type,
  });
  Map<String, dynamic> toJson() => {
        'password': password,
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'birth_date': birthDate,
        'language': language,
        'about_store': aboutStore,
        'store_address': storeAddress,
        'store_name': storeName,
        'type': type,
      };
}
