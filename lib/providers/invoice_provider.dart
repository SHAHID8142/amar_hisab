import 'package:flutter/material.dart';
import 'package:amar_hisab/models/invoice.dart';

class InvoiceProvider with ChangeNotifier {
  List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  double get totalIncome => _invoices.where((invoice) => invoice.isPaid).fold(0, (sum, invoice) => sum + invoice.amount);

  set invoices(List<Invoice> invoices) {
    _invoices = invoices;
    notifyListeners();
  }

  void addInvoice(Invoice invoice) {
    _invoices.add(invoice);
    notifyListeners();
  }

  void addInvoices(List<Invoice> invoices) {
    _invoices.addAll(invoices);
    notifyListeners();
  }

  void updateInvoice(Invoice invoice) {
    final index = _invoices.indexWhere((i) => i.id == invoice.id);
    if (index != -1) {
      _invoices[index] = invoice;
      notifyListeners();
    }
  }

  void deleteInvoice(String id) {
    _invoices.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void toggleInvoiceStatus(String id) {
    final index = _invoices.indexWhere((i) => i.id == id);
    if (index != -1) {
      _invoices[index] = Invoice(
        id: _invoices[index].id,
        clientName: _invoices[index].clientName,
        amount: _invoices[index].amount,
        date: _invoices[index].date,
        isPaid: !_invoices[index].isPaid,
      );
      notifyListeners();
    }
  }

  double getTotalUnpaidInvoices() {
    return _invoices
        .where((invoice) => !invoice.isPaid)
        .fold(0, (sum, invoice) => sum + invoice.amount);
  }
}