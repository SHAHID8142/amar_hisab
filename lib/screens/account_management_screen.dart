import 'package:amar_hisab/models/account.dart';
import 'package:amar_hisab/providers/account_provider.dart';
import 'package:amar_hisab/services/google_drive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  AccountManagementScreenState createState() => AccountManagementScreenState();
}

class AccountManagementScreenState extends State<AccountManagementScreen> {
  final GoogleDriveService _googleDriveService = GoogleDriveService();

  void _showAccountDialog({Account? account}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: account?.accountName);
    final numberController =
        TextEditingController(text: account?.accountNumber);
    final balanceController =
        TextEditingController(text: account?.balance.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(account == null ? 'Add Account' : 'Edit Account'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Account Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an account name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: numberController,
                  decoration:
                      const InputDecoration(labelText: 'Account Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an account number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: balanceController,
                  decoration: const InputDecoration(labelText: 'Balance'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a balance';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newAccount = Account(
                    id: account?.id ?? DateTime.now().toString(),
                    accountName: nameController.text,
                    accountNumber: numberController.text,
                    balance: double.parse(balanceController.text),
                  );
                  if (account == null) {
                    Provider.of<AccountProvider>(context, listen: false)
                        .addAccount(newAccount);
                  } else {
                    Provider.of<AccountProvider>(context, listen: false)
                        .updateAccount(newAccount);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(account == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Management'),
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
      body: Consumer<AccountProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.accounts.length,
            itemBuilder: (context, index) {
              final account = provider.accounts[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      account.accountName[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(account.accountName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(account.accountNumber),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${account.balance.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showAccountDialog(account: account),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<AccountProvider>(context, listen: false)
                              .deleteAccount(account.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAccountDialog(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}