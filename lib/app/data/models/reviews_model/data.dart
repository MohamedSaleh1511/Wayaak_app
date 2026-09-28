import 'review.dart';

class Data {
  String? myTotalStars;
  int? usersGive1Star;
  int? usersGive2Stars;
  int? usersGive3Stars;
  int? usersGive4Stars;
  int? usersGive5Stars;
  List<Review>? reviews;

  Data({
    this.myTotalStars,
    this.usersGive1Star,
    this.usersGive2Stars,
    this.usersGive3Stars,
    this.usersGive4Stars,
    this.usersGive5Stars,
    this.reviews,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        myTotalStars: json['my total stars'] as String?,
        usersGive1Star: json['users give 1 star'] as int?,
        usersGive2Stars: json['users give 2 stars'] as int?,
        usersGive3Stars: json['users give 3 stars'] as int?,
        usersGive4Stars: json['users give 4 stars'] as int?,
        usersGive5Stars: json['users give 5 stars'] as int?,
        reviews: (json['reviews'] as List<dynamic>?)
            ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'my total stars': myTotalStars,
        'users give 1 star': usersGive1Star,
        'users give 2 stars': usersGive2Stars,
        'users give 3 stars': usersGive3Stars,
        'users give 4 stars': usersGive4Stars,
        'users give 5 stars': usersGive5Stars,
        'reviews': reviews?.map((e) => e.toJson()).toList(),
      };
}
