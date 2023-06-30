import 'package:qr_code_almox_app/data/database/inventory_items.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';

class LocalDatabase {
  // TODO(danielassis-dev): implement getter from database
  static InventoryItem? getFromCode(String code) {
    for (var item in inventoryItems) {
      if (item.code == code) {
        return item;
      }
    }
    return null;
  }

  // TODO(danielassis-dev): make a more sophisticated search
  static List<InventoryItem> searchFromString(String searchStr) {
    List<InventoryItem> list = [];
    List<String> searchStrList = searchStr.split(" ");
    for (var item in inventoryItems) {
      for (var str in searchStrList) {
        if (item.toString().toUpperCase().contains(str.toUpperCase())) {
          list.add(item);
        }
      }
    }
    return list;
  }
}
