import 'package:flutter/material.dart';
import '../models/receipt.dart';

class ReceiptProvider with ChangeNotifier {
  final List<Receipt> _receipts = [];

  List<Receipt> get receipts => _receipts;

  void addReceipt(Receipt receipt) {
    _receipts.add(receipt);
    notifyListeners();
  }

  void updateReceipt(Receipt receipt) {
    final index = _receipts.indexWhere((r) => r.receiptNumber == receipt.receiptNumber);
    if (index != -1) {
      _receipts[index] = receipt;
      notifyListeners();
    }
  }

  void deleteReceipt(String receiptNumber) {
    _receipts.removeWhere((r) => r.receiptNumber == receiptNumber);
    notifyListeners();
  }
}