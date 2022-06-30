import 'package:theatrol/model/seat.dart';
import 'package:http/http.dart' as http;
import 'package:theatrol/utils/api_end_points.dart';

class RemoteSeatsService {
  Future<List<Seat>?> getSeats() async {
    var client = http.Client();
    var uri = Uri.parse(seatsGetUrl);
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var json = response.body;
      return seatFromJson(json);
    }
    return null;
  }
}
