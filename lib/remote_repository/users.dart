import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:theatrol/model/user.dart';
import 'package:theatrol/utils/api_end_points.dart';

class RemoteAuthService {
  Future<User?> login(
      {required String username, required String password}) async {
    var client = http.Client();
    var uri = Uri.parse(loginUrl);
    Map data = {'username': username, 'password': password};
    var response = await client.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(data));
    if (response.statusCode == 200) {
      var json = response.body;

      return User.fromJson(jsonDecode(json));

      //return userFromJson(json);
    }
    return null;
  }
}
