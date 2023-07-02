import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_almox_app/data/database/local_database.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';
import 'package:qr_code_almox_app/views/qr_read_view/qr_read_view.dart';
import 'package:qr_code_almox_app/views/take_pictures_view/take_pictures_view.dart';
import 'package:qr_code_almox_app/widgets/list_item_widget.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final listKey = GlobalKey<AnimatedListState>();
  final itemsList = <InventoryItem>[];
  TextEditingController? inputController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Autocomplete<InventoryItem>(
                optionsBuilder: (textEditingValue) =>
                    LocalDatabase.searchFromString(textEditingValue.text),
                displayStringForOption: (option) => option.toString(),
                onSelected: (item) {
                  insertItem(item);
                  inputController?.clear();
                  FocusScope.of(context).unfocus();
                },
                optionsViewBuilder: (context, onSelected, options) {
                  final ScrollController scrollController = ScrollController();
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
                                return FilledButton(
                                  onPressed: () =>
                                      onSelected(options.elementAt(index)),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      options.elementAt(index).toString(),
                                      style: const TextStyle(fontSize: 10),
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
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  inputController = textEditingController;
                  return TextField(
                    controller: inputController,
                    focusNode: focusNode,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: "Procure uma ferramenta",
                      hintText: "RRD_9999 - Alicate",
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: listKey,
              itemBuilder: _itemBuilder,
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: FilledButton(
                onPressed: () async {
                  final cameras = await availableCameras();
                  final cameraDescription = cameras.first;
                  // TODO(danielassis-dev): fix use_build_context_synchronously
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TakePicturesView(
                          cameraDescription: cameraDescription)));
                },
                child: const Text("Emprestar!"),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          readQrCode();
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Future<void> readQrCode() async {
    final String data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrReadView()),
    );

    if (!context.mounted) return;

    final code = data;
    InventoryItem? listItem = LocalDatabase.getFromCode(code);
    if (listItem != null) {
      insertItem(listItem);
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
      item: itemsList[index],
      animation: animation,
      onClicked: () => removeItem(index),
    );
  }

  void removeItem(int index) {
    InventoryItem item = itemsList[index];
    itemsList.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      duration: const Duration(milliseconds: 600),
      (context, animation) {
        return ListItemWidget(
            item: item, animation: animation, onClicked: () => {});
      },
    );
  }

  void insertItem(InventoryItem listItem) {
    for (var item in itemsList) {
      if (item.code == listItem.code) {
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
    itemsList.insert(0, listItem);
    listKey.currentState!.insertItem(
      0,
      duration: const Duration(milliseconds: 600),
    );
  }
}
