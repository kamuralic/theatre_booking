// To parse this JSON data, do
//
//     final seat = seatFromJson(jsonString);

import 'dart:convert';

List<Seat> seatFromJson(String str) =>
    List<Seat>.from(json.decode(str).map((x) => Seat.fromJson(x)));

String seatToJson(List<Seat> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Seat {
  Seat({
    this.id,
    this.createdAt,
    required this.row,
    required this.column,
  });

  final int? id;
  final DateTime? createdAt;
  final String row;
  final int column;

  factory Seat.fromJson(Map<String, dynamic> json) => Seat(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        row: json["row"],
        column: json["column"],
      );

  Map<String, dynamic> toJson() => {
        "row": row,
        "column": column,
      };
}
