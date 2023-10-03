import 'dart:io';

import 'package:flutter/services.dart';
import 'package:qr_code_almox_app/data/database/database_interface.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';
import 'package:qr_code_almox_app/data/models/borrowing.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';
import 'package:qr_code_almox_app/procedures/generate_pdf.dart';

class InventoryManager {
  InventoryManager._internal();

  static final InventoryManager _instance = InventoryManager._internal();

  factory InventoryManager() => _instance;

  Future<Borrowing> borrowItems({
    required AppUser appUser,
    required List<InventoryItem> items,
    required List<File> imageFiles,
  }) async {
    final db = await DatabaseInterface.instance;
    final Borrowing borrowing = Borrowing(
      userUuid: appUser.uuid,
      itemsCodes: [for (var item in items) item.code],
    );
    final Uint8List pdfBytes = await generatePDF(
      appUser: appUser,
      inventoryItems: items,
      imageFiles: imageFiles,
      dateTime: borrowing.borrowDateTime,
    );
    await db.saveBorrowingLocally(borrowing: borrowing, pdfBytes: pdfBytes);
    return borrowing;
  }

  Future<List<InventoryItem>> getBorrowedItems(
      {required AppUser appUser}) async {
    final db = await DatabaseInterface.instance;
    return await db.getBorrowedItemsCodes(userUuid: appUser.uuid);
  }
}
