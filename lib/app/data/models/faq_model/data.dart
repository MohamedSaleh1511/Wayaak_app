import 'fa_q.dart';

class Data {
  List<FaQ>? faQs;

  Data({this.faQs});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        faQs: (json['FAQs'] as List<dynamic>?)
            ?.map((e) => FaQ.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'FAQs': faQs?.map((e) => e.toJson()).toList(),
      };
}
