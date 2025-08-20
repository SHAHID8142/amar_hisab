import 'package:flutter/material.dart';
import '../models/account.dart';

class AccountProvider with ChangeNotifier {
  final List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  double get totalBalance => _accounts.fold(0, (sum, item) => sum + item.balance);

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }

  void addAccounts(List<Account> accounts) {
    _accounts.addAll(accounts);
    notifyListeners();
  }

  void updateAccount(Account account) {
    final index = _accounts.indexWhere((a) => a.accountNumber == account.accountNumber);
    if (index != -1) {
      _accounts[index] = account;
      notifyListeners();
    }
  }

  void deleteAccount(String accountNumber) {
    _accounts.removeWhere((a) => a.accountNumber == accountNumber);
    notifyListeners();
  }
}