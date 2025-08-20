import 'package:amar_hisab/services/google_drive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

class InvoicingScreen extends StatelessWidget {
  const InvoicingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GoogleDriveService googleDriveService = GoogleDriveService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoicing'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            onPressed: () => googleDriveService.backupData(context),
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => googleDriveService.restoreData(context),
          ),
        ],
      ),
      body: Consumer<InvoiceProvider>(
        builder: (context, invoiceProvider, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: invoiceProvider.invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoiceProvider.invoices[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.receipt_long),
                  ),
                  title: Text('Invoice #${invoice.id.substring(0, 6)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${invoice.clientName} - \$${invoice.amount.toStringAsFixed(2)}'),
                      Text('Due: ${invoice.date.toLocal().toString().split(' ')[0]}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(invoice.isPaid ? 'Paid' : 'Unpaid', style: TextStyle(color: invoice.isPaid ? Colors.green : Colors.red)),
                      Switch(
                        value: invoice.isPaid,
                        onChanged: (value) {
                          invoiceProvider.toggleInvoiceStatus(invoice.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteInvoice(context, invoiceProvider, invoice),
                      ),
                    ],
                  ),
                  onTap: () => _showInvoiceDialog(context, invoiceProvider, invoice),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInvoiceDialog(context, Provider.of<InvoiceProvider>(context, listen: false)),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteInvoice(BuildContext context, InvoiceProvider invoiceProvider, Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Invoice'),
          content: const Text('Are you sure you want to delete this invoice?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                invoiceProvider.deleteInvoice(invoice.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showInvoiceDialog(BuildContext context, InvoiceProvider invoiceProvider, [Invoice? invoice]) {
    final clientNameController = TextEditingController(text: invoice?.clientName ?? '');
    final amountController = TextEditingController(text: invoice?.amount.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(invoice == null ? 'Add Invoice' : 'Edit Invoice'),
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
                final amount = double.tryParse(amountController.text) ?? 0.0;

                if (clientName.isNotEmpty && amount > 0) {
                  if (invoice == null) {
                    invoiceProvider.addInvoice(
                      Invoice(
                        id: DateTime.now().toString(),
                        clientName: clientName,
                        amount: amount,
                        date: DateTime.now(),
                        isPaid: false,
                      ),
                    );
                  } else {
                    invoiceProvider.updateInvoice(
                      Invoice(
                        id: invoice.id,
                        clientName: clientName,
                        amount: amount,
                        date: invoice.date,
                        isPaid: invoice.isPaid,
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
}
