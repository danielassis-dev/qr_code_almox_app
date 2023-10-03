import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/constants.dart';
import 'package:qr_code_almox_app/data/database/database_interface.dart';
import 'package:qr_code_almox_app/data/managers/inventory_manager.dart';
import 'package:qr_code_almox_app/data/managers/user_manager.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';
import 'package:qr_code_almox_app/data/models/change_notifier_list.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';
import 'package:qr_code_almox_app/views/append_pictures_view/append_pictures_view.dart';
import 'package:qr_code_almox_app/views/qr_read_view/qr_read_view.dart';
import 'package:qr_code_almox_app/widgets/animated_show_floating_action_button.dart';
import 'package:qr_code_almox_app/widgets/list_item_widget.dart';

class BorrowView extends StatefulWidget {
  const BorrowView({super.key});

  @override
  State<BorrowView> createState() => _BorrowViewState();
}

class _BorrowViewState extends State<BorrowView> {
  final listKey = GlobalKey<AnimatedListState>();
  TextEditingController? inputController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeNotifierList<InventoryItem>>(
      create: (context) => ChangeNotifierList<InventoryItem>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Carrinho'),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Autocomplete<InventoryItem>(
                        optionsBuilder: (textEditingValue) async =>
                            (await DatabaseInterface.instance)
                                .searchInventoryItemsFromString(
                                    textEditingValue.text),
                        displayStringForOption: (option) => option.toString(),
                        onSelected: (item) {
                          insertItem(context, item);
                          inputController?.clear();
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          final ScrollController scrollController =
                              ScrollController();
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: Material(
                                elevation: 4,
                                child: SizedBox(
                                  height: 200,
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: scrollController,
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: options.length,
                                      itemBuilder: (context, index) {
                                        return TextButton(
                                          onPressed: () => onSelected(
                                              options.elementAt(index)),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              options
                                                  .elementAt(index)
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) {
                          inputController = textEditingController;
                          return TextField(
                            controller: inputController,
                            focusNode: focusNode,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: const InputDecoration(
                              labelText: "Selecione uma ferramenta",
                              hintText: "RRD_9999 - Alicate",
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    height: 70.0,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        onPressed: () => readQrCode(context),
                        child: const Icon(Icons.qr_code_scanner)),
                  ),
                ],
              ),
              Expanded(
                child: AnimatedList(
                  key: listKey,
                  itemBuilder: _itemBuilder,
                ),
              ),
            ],
          ),
          floatingActionButton: AnimatedShowFloaingActionButton(
            duration: const Duration(milliseconds: 500),
            showButton:
                context.watch<ChangeNotifierList<InventoryItem>>().isNotEmpty,
            label: const Text('Adicionar Fotos'),
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              final List<InventoryItem> inventoryItems =
                  context.read<ChangeNotifierList<InventoryItem>>().toList();
              final List<File>? imageFiles =
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Provider<List<InventoryItem>>(
                            create: (context) => inventoryItems,
                            builder: (context, child) =>
                                const AppendPicturesView(),
                          )));
              if (imageFiles == null) return;
              if (!context.mounted) return;

              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('Processando...'),
                  content: SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              );
              final AppUser appUser = context.read<UserManager>().appUser!;
              final iManager = InventoryManager();
              await iManager.borrowItems(
                appUser: appUser,
                items: inventoryItems,
                imageFiles: imageFiles,
              );

              if (context.mounted) Navigator.of(context).pop();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(borrowingsViewName);
              }
            },
          ),
        );
      }),
    );
  }

  Future<void> readQrCode(BuildContext context) async {
    final String data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrReadView()),
    );

    if (!context.mounted) return;

    final code = data;
    final db = await DatabaseInterface.instance;
    InventoryItem? listItem = db.getInventoryItemFromCode(code);
    if (!context.mounted) return;
    if (listItem != null) {
      insertItem(context, listItem);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Atenção"),
          content: const Text("Ferramenta não encontrada no banco de dados"),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context, 'Ok'),
                child: const Text('Ok'))
          ],
        ),
      );
    }
  }

  Widget _itemBuilder(
      BuildContext context, int index, Animation<double> animation) {
    return ListItemWidget(
      item: context.watch<ChangeNotifierList<InventoryItem>>()[index],
      animation: animation,
      onClicked: () => removeItem(context, index),
    );
  }

  void removeItem(BuildContext context, int index) {
    final inventoryItems = context.read<ChangeNotifierList<InventoryItem>>();

    InventoryItem item = inventoryItems[index];
    inventoryItems.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      duration: const Duration(milliseconds: 600),
      (context, animation) {
        return ListItemWidget(
            item: item, animation: animation, onClicked: () => {});
      },
    );
  }

  void insertItem(BuildContext context, InventoryItem listItem) {
    final inventoryItems = context.read<ChangeNotifierList<InventoryItem>>();
    for (var inventoryItem in inventoryItems) {
      if (inventoryItem.code == listItem.code) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Atenção"),
            content: const Text("Item já está na lista!"),
            actions: [
              FilledButton(
                  onPressed: () => Navigator.pop(context, 'Ok'),
                  child: const Text('Ok'))
            ],
          ),
        );
        return;
      }
    }
    inventoryItems.insert(0, listItem);
    listKey.currentState!.insertItem(
      0,
      duration: const Duration(milliseconds: 600),
    );
  }
}
