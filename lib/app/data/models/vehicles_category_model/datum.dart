class VehiclesDatum {
  int? id;
  String? name;
  String? image;

  VehiclesDatum({this.id, this.name, this.image});

  factory VehiclesDatum.fromJson(Map<String, dynamic> json) => VehiclesDatum(
        id: json['id'] as int?,
        name: json['name'] as String?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };
}
