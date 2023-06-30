import 'package:flutter/material.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';

class ListItemWidget extends StatelessWidget {
  final InventoryItem item;
  final Animation<double> animation;
  final void Function()? onClicked;

  const ListItemWidget({
    super.key,
    required this.item,
    required this.animation,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      key: ValueKey(item.description),
      child: buildItem(),
    );
  }

  Card buildItem() {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          radius: 32,
          child: Icon(Icons.qr_code),
        ),
        title: Text(
          item.toString(),
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        trailing: IconButton(
          onPressed: onClicked,
          icon: const Icon(Icons.delete, color: Colors.red, size: 32),
        ),
      ),
    );
  }
}
