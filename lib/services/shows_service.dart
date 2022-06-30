import 'package:flutter/cupertino.dart';
import 'package:theatrol/model/show.dart';
import 'package:theatrol/remote_repository/shows.dart';

class ShowsService with ChangeNotifier {
  List<Show>? shows;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  setIsLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  getShows() async {
    setIsLoaded(false);
    shows = await RemoteShowsService().getShows();
    notifyListeners();
    setIsLoaded(true);
  }
}
