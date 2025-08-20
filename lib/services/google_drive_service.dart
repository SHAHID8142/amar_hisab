import 'dart:convert';
import 'dart:io';
import 'package:amar_hisab/models/client.dart';
import 'package:amar_hisab/models/expense.dart';
import 'package:amar_hisab/models/invoice.dart';
import 'package:amar_hisab/models/loan.dart';
import 'package:amar_hisab/models/task.dart';
import 'package:amar_hisab/providers/client_provider.dart';
import 'package:amar_hisab/providers/expense_provider.dart';
import 'package:amar_hisab/providers/invoice_provider.dart';
import 'package:amar_hisab/providers/loan_provider.dart';
import 'package:amar_hisab/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String>? _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers ?? {}));
  }
}

class GoogleDriveService {
  final _googleSignIn = GoogleSignIn.instance;

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    try {
      final googleUser = await _googleSignIn.authenticate();

      // ignore: unnecessary_null_comparison
      if (googleUser == null) {
        return null;
      }

      final headers = await googleUser.authorizationClient
          .authorizationHeaders([drive.DriveApi.driveFileScope]);

      final client = GoogleAuthClient(headers ?? {});
      return drive.DriveApi(client);
    } catch (e) {
      return null;
    }
  }

  Future<void> backupData(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backing up data...')),
    );

    try {
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);
      final loanProvider = Provider.of<LoanProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final invoiceProvider =
          Provider.of<InvoiceProvider>(context, listen: false);
      final expenseProvider =
          Provider.of<ExpenseProvider>(context, listen: false);

      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Drive authentication failed.')),
          );
        }
        return;
      }

      final backupData = {
        'clients': clientProvider.clients.map((e) => e.toJson()).toList(),
        'loans': loanProvider.loans.map((e) => e.toJson()).toList(),
        'tasks': taskProvider.tasks.map((e) => e.toJson()).toList(),
        'invoices': invoiceProvider.invoices.map((e) => e.toJson()).toList(),
        'expenses': expenseProvider.expenses.map((e) => e.toJson()).toList(),
      };

      final backupJson = jsonEncode(backupData);
      final tempDir = await getTemporaryDirectory();
      final backupFile = File('${tempDir.path}/backup.json');
      await backupFile.writeAsString(backupJson);

      final driveFile = drive.File();
      driveFile.name = 'amar_hisab_backup.json';

      await driveApi.files.create(
        driveFile,
        uploadMedia: drive.Media(backupFile.openRead(), backupFile.lengthSync()),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup successful!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup failed: $e')),
        );
      }
    }
  }

  Future<void> restoreData(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restoring data...')),
    );

    try {
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);
      final loanProvider = Provider.of<LoanProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final invoiceProvider =
          Provider.of<InvoiceProvider>(context, listen: false);
      final expenseProvider =
          Provider.of<ExpenseProvider>(context, listen: false);

      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google Drive authentication failed.')),
          );
        }
        return;
      }

      final fileList =
          await driveApi.files.list(q: "name='amar_hisab_backup.json'");
      if (fileList.files == null || fileList.files!.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No backup file found.')),
          );
        }
        return;
      }

      final backupFileId = fileList.files!.first.id!;
      final media = await driveApi.files
          .get(backupFileId, downloadOptions: drive.DownloadOptions.fullMedia)
          as drive.Media;

      final tempDir = await getTemporaryDirectory();
      final backupFile = File('${tempDir.path}/backup.json');

      List<int> dataStore = [];
      await media.stream.forEach((element) {
        dataStore.addAll(element);
      });

      await backupFile.writeAsBytes(dataStore);

      final backupJson = await backupFile.readAsString();
      final backupData = jsonDecode(backupJson);

      clientProvider.clients = (backupData['clients'] as List)
          .map((e) => Client.fromJson(e))
          .toList();
      loanProvider.loans = (backupData['loans'] as List)
          .map((e) => Loan.fromJson(e))
          .toList();
      taskProvider.tasks = (backupData['tasks'] as List)
          .map((e) => Task.fromJson(e))
          .toList();
      invoiceProvider.invoices = (backupData['invoices'] as List)
          .map((e) => Invoice.fromJson(e))
          .toList();
      expenseProvider.expenses = (backupData['expenses'] as List)
          .map((e) => Expense.fromJson(e))
          .toList();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore successful!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    }
  }
}