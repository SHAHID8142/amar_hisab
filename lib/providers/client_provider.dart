import 'package:flutter/material.dart';
import 'package:amar_hisab/models/client.dart';

class ClientProvider with ChangeNotifier {
  List<Client> _clients = [];

  List<Client> get clients => _clients;

  set clients(List<Client> clients) {
    _clients = clients;
    notifyListeners();
  }

  void addClient(Client client) {
    _clients.add(client);
    notifyListeners();
  }

  void updateClient(Client client) {
    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index != -1) {
      _clients[index] = client;
      notifyListeners();
    }
  }

  void deleteClient(String id) {
    _clients.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}