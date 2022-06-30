import 'dart:convert';

List<Show> showFromJson(String str) =>
    List<Show>.from(json.decode(str).map((x) => Show.fromJson(x)));

String showToJson(List<Show> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Show {
  Show({
    this.id,
    this.createdAt,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
  });

  int? id;
  DateTime? createdAt;
  String title;
  String description;
  String imageUrl;
  DateTime startDate;
  DateTime endDate;

  factory Show.fromJson(Map<String, dynamic> json) => Show(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        title: json["title"],
        description: json["description"],
        imageUrl: json["image_url"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
      };
}
