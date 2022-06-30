import 'package:flutter/cupertino.dart';
import 'package:theatrol/model/seat.dart';

import '../remote_repository/seats.dart';

class SeatsService with ChangeNotifier {
  List<Seat>? seats;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  setIsLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  getSeats() async {
    setIsLoaded(false);
    RemoteSeatsService().getSeats().then((value) {
      seats = value;
      notifyListeners();
      setIsLoaded(true);
    });
  }
}
