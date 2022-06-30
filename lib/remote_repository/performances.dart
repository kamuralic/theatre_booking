import 'package:theatrol/model/performance.dart';
import 'package:http/http.dart' as http;
import 'package:theatrol/utils/api_end_points.dart';

class RemotePerformancesService {
  Future<List<Performance>?> getPerformances() async {
    var client = http.Client();
    var uri = Uri.parse(performancesUrl);
    var response = await client.get(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var json = response.body;
      return performanceFromJson(json);
    }
    return null;
  }
}
