import 'dart:convert';

import 'package:theatrol/model/show.dart';
import 'package:http/http.dart' as http;
import 'package:theatrol/utils/api_end_points.dart';

class RemoteShowsService {
  Future<List<Show>?> getShows() async {
    var client = http.Client();
    var uri = Uri.parse(showsGetUrl);
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var json = response.body;
      return showFromJson(json);
    }
    return null;
  }

  Future<Show> createShow({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse(createShowUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        "description": description,
        "image_url": imageUrl,
        "start_date": startDate,
        "end_date": endDate
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      return Show.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create Show');
    }
  }
}
