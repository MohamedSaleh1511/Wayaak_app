class Data {
  String? actualCost;
  String? minCost;
  String? maxCost;
  String? urgent;

  Data({this.actualCost, this.minCost, this.maxCost, this.urgent});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        actualCost: json['actual_cost'].toString(),
        minCost: json['min_cost'].toString(),
        maxCost: json['max_cost'].toString(),
        urgent: json['urgent'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'actual_cost': actualCost,
        'min_cost': minCost,
        'max_cost': maxCost,
        'urgent': urgent,
      };
}
