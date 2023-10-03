// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:qr_code_almox_app/data/managers/inventory_manager.dart';
import 'package:qr_code_almox_app/data/managers/user_manager.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';
import 'package:qr_code_almox_app/data/models/borrowing.dart';

class BorrowingsView extends StatelessWidget {
  const BorrowingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserManager userManager = context.read<UserManager>();
    // Users Shouldn't enter this view without being logged in
    final AppUser appUser = userManager.appUser!;
    final InventoryManager inventoryManager = context.read<InventoryManager>();
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        // TODO(danielassis-dev): Go back to normal in production
        // future: inventoryFlowManager.getBorrowedItems(appUser: appUser),
        future: Future.delayed(const Duration(seconds: 0)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            // TODO(danielassiz-dev): implement body
            return ListView(
              children: [
                const Divider(),
                Text(DateFormat('dd-MMM-yyyy').format(DateTime.now())),
                ...[
                  const Divider(),
                  BorrowingTile(
                      borrowing:
                          Borrowing(userUuid: 'userUuid', itemsCodes: [])),
                ],
                const Divider(),
              ],
            );
          }
          return const Text('Erro Desconhecido');
        },
      ),
    );
  }
}

class BorrowingTile extends StatelessWidget {
  final Borrowing _borrowing;

  const BorrowingTile({
    super.key,
    required Borrowing borrowing,
  }) : _borrowing = borrowing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: const Icon(Icons.document_scanner),
      title: Text(DateFormat('HH:mm').format(DateTime.now())),
      trailing: SizedBox(
        width: 70,
        child: Row(
          children: [
            Icon(Icons.file_open, color: Colors.lightBlue),
            (_borrowing.pdfUrl == null)
                ? Icon(Icons.cloud_done, color: Colors.lightBlue)
                : Icon(Icons.cloud_done, color: Colors.lightBlue),
          ],
        ),
      ),
    );
  }
}
