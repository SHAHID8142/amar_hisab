import 'package:flutter/material.dart';
import 'package:amar_hisab/models/loan.dart';

class LoanProvider with ChangeNotifier {
  List<Loan> _loans = [];

  List<Loan> get loans => _loans;

  set loans(List<Loan> loans) {
    _loans = loans;
    notifyListeners();
  }

  void addLoan(Loan loan) {
    _loans.add(loan);
    notifyListeners();
  }

  void updateLoan(Loan loan) {
    final index = _loans.indexWhere((l) => l.id == loan.id);
    if (index != -1) {
      _loans[index] = loan;
      notifyListeners();
    }
  }

  void deleteLoan(String id) {
    _loans.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  double getTotalLoanAmount() {
    return _loans.fold(0, (sum, loan) => sum + loan.amount);
  }

  double getTotalInterestAmount() {
    return _loans.fold(0, (sum, loan) => sum + (loan.amount * loan.interestRate / 100));
  }
}