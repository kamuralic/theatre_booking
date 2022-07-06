import 'dart:convert';

List<Ticket> ticketFromJson(String str) =>
    List<Ticket>.from(json.decode(str).map((x) => Ticket.fromJson(x)));

String ticketToJson(List<Ticket> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ticket {
  Ticket({
    this.id,
    this.createdAt,
    required this.seatId,
    required this.showId,
    required this.performanceId,
    required this.userId,
  });

  int? id;
  DateTime? createdAt;
  int seatId;
  int showId;
  int performanceId;
  int userId;

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        seatId: json["seat_id"],
        performanceId: json["performance_id"],
        userId: json["user_id"],
        showId: json["show_id"],
      );

  Map<String, dynamic> toJson() => {
        "seat_id": seatId,
        "show_id": showId,
        "performance_id": performanceId,
        "user_id": userId,
      };
}
