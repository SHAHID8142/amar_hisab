import 'package:amar_hisab/models/account.dart';
import 'package:amar_hisab/models/expense.dart';
import 'package:amar_hisab/models/invoice.dart';

final List<Account> dummyAccounts = [
  Account(
    id: 'a1',
    accountName: 'Cash',
    accountNumber: 'N/A',
    balance: 50000.0,
  ),
  Account(
    id: 'a2',
    accountName: 'Bank Account',
    accountNumber: '123456789',
    balance: 250000.0,
  ),
];

final List<Expense> dummyExpenses = [
  Expense(
    id: 'e1',
    description: 'Office Rent',
    amount: 15000.0,
    date: DateTime.now().subtract(const Duration(days: 15)),
    category: 'Office',
  ),
  Expense(
    id: 'e2',
    description: 'Utilities',
    amount: 5000.0,
    date: DateTime.now().subtract(const Duration(days: 10)),
    category: 'Utilities',
  ),
];

final List<Invoice> dummyInvoices = [
  Invoice(
    id: 'i1',
    clientName: 'John Doe',
    amount: 25000.0,
    date: DateTime.now().add(const Duration(days: 10)),
    isPaid: false,
  ),
  Invoice(
    id: 'i2',
    clientName: 'Jane Smith',
    amount: 45000.0,
    date: DateTime.now().add(const Duration(days: 20)),
    isPaid: true,
  ),
];