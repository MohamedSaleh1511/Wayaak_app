class Driver {
  int? id;
  String? name;
  String? driverPhoto;
  String? rate;

  Driver({this.id, this.name, this.driverPhoto, this.rate});

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json['id'] as int?,
        name: json['name'] as String?,
        driverPhoto: json['driver_photo'] as String?,
        rate: json['rate'].toString(),
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'driver_photo': driverPhoto, 'rate': rate};
}
