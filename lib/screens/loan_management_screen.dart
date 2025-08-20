import 'package:amar_hisab/models/loan.dart';
import 'package:amar_hisab/providers/loan_provider.dart';
import 'package:amar_hisab/services/google_drive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoanManagementScreen extends StatefulWidget {
  const LoanManagementScreen({super.key});

  @override
  LoanManagementScreenState createState() => LoanManagementScreenState();
}

class LoanManagementScreenState extends State<LoanManagementScreen> {
  final GoogleDriveService _googleDriveService = GoogleDriveService();

  void _addLoan() {
    _showLoanDialog();
  }

  void _editLoan(Loan loan) {
    _showLoanDialog(loan: loan);
  }

  void _deleteLoan(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Loan'),
          content: const Text('Are you sure you want to delete this loan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<LoanProvider>(context, listen: false).deleteLoan(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showLoanDialog({Loan? loan}) {
    final clientNameController = TextEditingController(text: loan?.clientName);
    final amountController = TextEditingController(text: loan?.amount.toString());
    final interestRateController = TextEditingController(text: loan?.interestRate.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loan == null ? 'Add Loan' : 'Edit Loan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: interestRateController,
                decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final clientName = clientNameController.text;
                final amount = double.tryParse(amountController.text) ?? 0;
                final interestRate = double.tryParse(interestRateController.text) ?? 0;

                if (clientName.isNotEmpty && amount > 0) {
                  if (loan == null) {
                    Provider.of<LoanProvider>(context, listen: false).addLoan(
                      Loan(
                        id: DateTime.now().toString(),
                        clientName: clientName,
                        amount: amount,
                        interestRate: interestRate,
                        date: DateTime.now(),
                      ),
                    );
                  } else {
                    Provider.of<LoanProvider>(context, listen: false).updateLoan(
                      Loan(
                        id: loan.id,
                        clientName: clientName,
                        amount: amount,
                        interestRate: interestRate,
                        date: loan.date,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);
    final loans = loanProvider.loans;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Management'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            onPressed: () => _googleDriveService.backupData(context),
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => _googleDriveService.restoreData(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.monetization_on),
              ),
              title: Text(loan.clientName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Amount: \$${loan.amount.toStringAsFixed(2)} @ ${loan.interestRate}%'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _editLoan(loan),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteLoan(loan.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLoan,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}