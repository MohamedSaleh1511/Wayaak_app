class BannerData {
  String? image;
  String? title;
  dynamic link;
  dynamic brief;

  BannerData({this.image, this.title, this.link, this.brief});

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
        image: json['image'] as String?,
        title: json['title'] as String?,
        link: json['link'] as dynamic,
        brief: json['brief'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'title': title,
        'link': link,
        'brief': brief,
      };
}
