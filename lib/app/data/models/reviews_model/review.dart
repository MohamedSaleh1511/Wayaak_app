class Review {
  String? user;
  dynamic image;
  String? comment;
  String? rate;
  DateTime? createdAt;

  Review({this.user, this.image, this.comment, this.rate, this.createdAt});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        user: json['user'] as String?,
        image: json['image'] as dynamic,
        comment: json['comment'] as String?,
        rate: json['rate'].toString(),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'user': user,
        'image': image,
        'comment': comment,
        'rate': rate,
        'created_at': createdAt?.toIso8601String(),
      };
}
