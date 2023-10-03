import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/managers/inventory_manager.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';

class DevolutionsView extends StatelessWidget {
  const DevolutionsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppUser appUser = context.read<AppUser>();
    final InventoryManager inventoryFlowManager =
        context.read<InventoryManager>();
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: inventoryFlowManager.getBorrowedItems(appUser: appUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            // TODO(danielassiz-dev): implement body
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Text('Erro Desconhecido');
        },
      ),
    );
  }
}
