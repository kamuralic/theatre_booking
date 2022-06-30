import 'package:flutter/cupertino.dart';
import 'package:theatrol/model/performance.dart';

import '../remote_repository/performances.dart';

class PerformancesService with ChangeNotifier {
  List<Performance>? performances;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  setIsLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  getPerformances() async {
    setIsLoaded(false);
    RemotePerformancesService().getPerformances().then((value) {
      performances = value;
      notifyListeners();
      setIsLoaded(true);
    });
  }
}
