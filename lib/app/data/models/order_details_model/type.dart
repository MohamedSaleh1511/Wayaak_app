class VehicleType {
  int? id;
  String? name;
  String? image;

  VehicleType({this.id, this.name, this.image});

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
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
