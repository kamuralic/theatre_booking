import 'package:shared_preferences/shared_preferences.dart';
import 'package:theatrol/model/user.dart';

class PrefService {
  Future createUser(User user) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', user.id!);
    prefs.setString('username', user.username);
  }

  Future<Map> getUser() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    var username = prefs.getString('username');

    return {'id': id, 'username': username};
  }

  Future deleteUser() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.remove('id');
    var username = prefs.remove('username');

    return {'id': id, 'username': username};
  }

  // Future addToTicketCat(User user) async {
  //   // Obtain shared preferences.
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('id', user.id!);
  //   prefs.setString('username', user.username);
  // }
}
