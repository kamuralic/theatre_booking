import 'package:flutter/cupertino.dart';
import 'package:theatrol/model/ticket.dart';

import '../remote_repository/tickets.dart';

class TicketsService with ChangeNotifier {
  List<Ticket>? tickets;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  setIsLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  getTickets() async {
    setIsLoaded(false);
    tickets = await RemoteTicketsService().getTickets();
    notifyListeners();
    setIsLoaded(true);
    return tickets;
  }
}
