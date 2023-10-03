import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/models/change_notifier_list.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';
import 'package:qr_code_almox_app/widgets/animated_show_floating_action_button.dart';

class DevolutionView extends StatelessWidget {
  const DevolutionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeNotifierList<InventoryItem>>(
      create: (context) => ChangeNotifierList<InventoryItem>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Devolver Itens'),
          ),
          body: const Column(
            children: [Placeholder()],
          ),
          floatingActionButton: AnimatedShowFloaingActionButton(
            duration: const Duration(milliseconds: 500),
            showButton:
                context.watch<ChangeNotifierList<InventoryItem>>().isNotEmpty,
            label: const Text('Adicionar Fotos'),
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        );
      }),
    );
  }
}
