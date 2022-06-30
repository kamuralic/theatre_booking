import 'dart:convert';

List<Performance> performanceFromJson(String str) => List<Performance>.from(
    json.decode(str).map((x) => Performance.fromJson(x)));

String performanceToJson(List<Performance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Performance {
  Performance({
    this.id,
    this.createdAt,
    required this.performanceType,
    required this.totalSeats,
    required this.pricePerSeat,
  });

  int? id;
  DateTime? createdAt;
  String performanceType;
  int totalSeats;
  int pricePerSeat;

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        performanceType: json["performance_type"],
        totalSeats: json["total_seats"],
        pricePerSeat: json["price_per_seat"],
      );

  Map<String, dynamic> toJson() => {
        "performance_type": performanceType,
        "total_seats": totalSeats,
        "price_per_seat": pricePerSeat,
      };
}
