class Driver {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? birthDate;
  String? language;
  String? driverPhoto;
  dynamic carPhoto;
  dynamic frontLicense;
  dynamic backLicense;
  String? confirmDocuments;
  String? location;
  String? wallet;
  String? notifiable;
  String? fcmToken;

  Driver({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.birthDate,
    this.language,
    this.driverPhoto,
    this.carPhoto,
    this.frontLicense,
    this.backLicense,
    this.confirmDocuments,
    this.location,
    this.wallet,
    this.notifiable,
    this.fcmToken,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json['id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        gender: json['gender'] as String?,
        birthDate: json['birth_date'] as String?,
        language: json['language'] as String?,
        driverPhoto: json['driver_photo'] as String?,
        carPhoto: json['car_photo'] as dynamic,
        frontLicense: json['front_license'] as dynamic,
        backLicense: json['back_license'] as dynamic,
        confirmDocuments: json['confirm_documents'] as String?,
        location: json['location'] as String?,
        wallet: json['wallet'].toString(),
        notifiable: '${json['notifiable']}' as String?,
        fcmToken: json['fcm_token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'birth_date': birthDate,
        'language': language,
        'driver_photo': driverPhoto,
        'car_photo': carPhoto,
        'front_license': frontLicense,
        'back_license': backLicense,
        'confirm_documents': confirmDocuments,
        'location': location,
        'wallet': wallet,
        'notifiable': notifiable,
        'fcm_token': fcmToken,
      };
}
