class ProductImage {
  int? id;
  String? image;

  ProductImage({this.id, this.image});

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json['id'] as int?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
      };
}
