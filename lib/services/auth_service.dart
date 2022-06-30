import 'package:flutter/cupertino.dart';
import 'package:theatrol/model/user.dart';
import 'package:theatrol/remote_repository/users.dart';
import 'package:theatrol/services/preferences_service.dart';

class AuthService with ChangeNotifier {
  List<User>? users;
  User? user;

  String? userNamePrefs;
  int? userIdPrefs;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  PrefService prefService = PrefService();
  setIsLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  login({required String username, required String password}) async {
    setIsLoaded(false);
    user =
        await RemoteAuthService().login(username: username, password: password);
    setIsLoaded(true);

    if (user != null) {
      prefService.createUser(user!);
    }

    if (user == null) {
      return 'Invalid Username or Password';
    }
    return '';
  }

  logout() {
    prefService.deleteUser().then((value) {
      getUserId();
      getUserName();
    });
  }

  getUserName() {
    prefService.getUser().then((value) {
      userNamePrefs = value['username'];
      notifyListeners();
    });
  }

  getUserId() {
    prefService.getUser().then((value) {
      userIdPrefs = value['id'];
      notifyListeners();
    });
  }
}
