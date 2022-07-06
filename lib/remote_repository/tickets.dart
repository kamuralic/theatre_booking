import 'dart:convert';

import 'package:theatrol/model/ticket.dart';
import 'package:theatrol/utils/api_end_points.dart';
import 'package:http/http.dart' as http;

class RemoteTicketsService {
  Future<Ticket> createTicket({
    required int showId,
    required int seatId,
    required int performanceId,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse(createTicketUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "show_id": showId,
        "seat_id": seatId,
        "performance_id": performanceId,
        "user_id": userId,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      return Ticket.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create Ticket');
    }
  }

  Future<List<Ticket>?> getTickets() async {
    var client = http.Client();
    var uri = Uri.parse(getTicketsUrl);
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var json = response.body;
      return ticketFromJson(json);
    }
    return null;
  }
}
