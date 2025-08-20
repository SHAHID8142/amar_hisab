import 'package:amar_hisab/models/receipt.dart';
import 'package:amar_hisab/providers/receipt_provider.dart';
import 'package:amar_hisab/services/google_drive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptGenerationScreen extends StatefulWidget {
  const ReceiptGenerationScreen({super.key});

  @override
  ReceiptGenerationScreenState createState() => ReceiptGenerationScreenState();
}

class ReceiptGenerationScreenState extends State<ReceiptGenerationScreen> {
  final GoogleDriveService _googleDriveService = GoogleDriveService();

  void _createReceipt() {
    _showReceiptDialog();
  }

  void _viewReceipt(Receipt receipt) {
    _showReceiptDialog(receipt: receipt);
  }

  void _deleteReceipt(String receiptNumber) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete this receipt?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Provider.of<ReceiptProvider>(context, listen: false)
                  .deleteReceipt(receiptNumber);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showReceiptDialog({Receipt? receipt}) {
    final receiptNumberController = TextEditingController(text: receipt?.receiptNumber);
    final clientNameController = TextEditingController(text: receipt?.clientName);
    final amountController = TextEditingController(text: receipt?.amount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(receipt == null ? 'Create Receipt' : 'Edit Receipt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: receiptNumberController,
                decoration: const InputDecoration(labelText: 'Receipt Number'),
              ),
              TextField(
                controller: clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
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
                final receiptNumber = receiptNumberController.text;
                final clientName = clientNameController.text;
                final amount = double.tryParse(amountController.text) ?? 0;

                if (receiptNumber.isNotEmpty &&
                    clientName.isNotEmpty &&
                    amount > 0) {
                  if (receipt == null) {
                    Provider.of<ReceiptProvider>(context, listen: false)
                        .addReceipt(
                      Receipt(
                        receiptNumber: receiptNumber,
                        clientName: clientName,
                        amount: amount,
                        date: DateTime.now(),
                      ),
                    );
                  } else {
                    Provider.of<ReceiptProvider>(context, listen: false)
                        .updateReceipt(
                      Receipt(
                        receiptNumber: receipt.receiptNumber,
                        clientName: clientName,
                        amount: amount,
                        date: receipt.date,
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
    final receiptProvider = Provider.of<ReceiptProvider>(context);
    final receipts = receiptProvider.receipts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Generation'),
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
        itemCount: receipts.length,
        itemBuilder: (context, index) {
          final receipt = receipts[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.receipt),
              ),
              title: Text(
                'Receipt ${receipt.receiptNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '${receipt.clientName} - \$${receipt.amount.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${receipt.date.day}/${receipt.date.month}/${receipt.date.year}',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _viewReceipt(receipt),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteReceipt(receipt.receiptNumber),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createReceipt,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}