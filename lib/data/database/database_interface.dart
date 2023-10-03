import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';
import 'package:qr_code_almox_app/data/models/borrowing.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';
import 'package:qr_code_almox_app/procedures/check_internet_connection.dart';

/// Internal storage folders structure
/// [_appDir]/users/ = [_usersDir]
/// [_appDir]/users/users.json
/// [_appDir]/users/last_user.json
///
/// [_appDir]/inventory_items/ = [_inventoryItemsDir]
/// [_appDir]/inventory_items/inventory_items.json
///
/// [_appDir]/borrowings/ = [_borrowingsDir]
/// [_appDir]/borrowings/borrowings.json
/// [_appDir]/borrowings/[user_uuid]/
/// [_appDir]/borrowings/[user_uuid]/borrowedItems.json
/// [_appDir]/borrowings/[user_uuid]/[borrowing_uuid].pdf
///
/// [_appDir]/devolutions/ = [_devolutionsDir]
/// [_appDir]/devolutions/devolutions.json
/// [_appDir]/devolutions/[user_uuid]/
/// [_appDir]/devolutions/[user_uuid]/[devolution_uuid].pdf
///
/// Firestore relational structure
/// /[C]users/[D][user_uuid]
/// /[C]inventory_items/[D][inventory_item_code]
/// /[C]borrowings/[D][borrowing_uuid]
/// /[C]devolutions/[D][devolution_uuid]
///
/// Firebase Storage structure
/// /borrowings/[user_uuid]/[borrowing_uuid].pdf
/// /devolutions/[user_uuid]/[devolution_uuid].pdf
class DatabaseInterface {
  DatabaseInterface._internal();

  static DatabaseInterface? _instance;

  static Future<DatabaseInterface> get instance async {
    if (_instance == null) {
      _instance = DatabaseInterface._internal();
      await _instance!._initialize();
    }
    return _instance!;
  }

  late final Directory _appDir;
  late final Directory _usersDir;
  late final Directory _inventoryItemsDir;
  late final Directory _borrowingsDir;
  // ignore: unused_field
  late final Directory _devolutionsDir;

  final Map<String, InventoryItem> _inventoryItemsMap = {};
  final List<InventoryItem> _inventoryItemsList = [];

  // Initialization
  bool _initialized = false;
  Future<void> _initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true; // Makes sure its only called once

    // Initialize late fields
    _appDir = await getApplicationDocumentsDirectory();
    _usersDir = await Directory('${_appDir.path}/users').create();
    _inventoryItemsDir =
        await Directory('${_appDir.path}/inventory_items').create();
    _borrowingsDir = await Directory('${_appDir.path}/borrowings').create();
    _devolutionsDir = await Directory('${_appDir.path}/devolutions').create();

    await Firebase.initializeApp();

    if (await InternetConnectivityChecker.instance.isConnected) {
      _inventoryItemsList.addAll(await _getInventoryItemsFromServer());
      _inventoryItemsMap.addAll({
        for (var item in _inventoryItemsList) item.code: item,
      });
      await _saveInventoryItemsLocally(_inventoryItemsList);
    } else {
      _inventoryItemsList.addAll(await _getInventoryItemsLocally());
      _inventoryItemsMap.addAll({
        for (var item in _inventoryItemsList) item.code: item,
      });
    }

    return;
  }

  Future<void> registerNewUser(AppUser appUser) async {
    await _registerNewUserLocally(appUser);
  }

  Future<void> _registerNewUserLocally(AppUser appUser) async {
    final usersFile = File('${_usersDir.path}/users.json');
    final jsonString = await usersFile.readAsString();
    final List<Map<String, dynamic>> mapsList = json.decode(jsonString);

    mapsList.add(appUser.toMap());

    await usersFile.writeAsString(json.encode(mapsList));
  }

  Future<void> _registerNewUserInServer(AppUser appUser) async {
    final firestore = FirebaseFirestore.instance;
    final usersCollection = firestore.collection('users');

    await usersCollection.doc(appUser.uuid).set(appUser.toMap());
  }

  /// Not used but ok
  Future<AppUser?> loadUserFromUuid({required String uuid}) async {
    return await _loadUserFromUuidLocally(uuid: uuid);
  }

  Future<AppUser?> _loadUserFromUuidLocally({required String uuid}) async {
    final usersFile = File('${_usersDir.path}/users.json');
    final jsonString = await usersFile.readAsString();
    final List<Map<String, dynamic>> mapsList = json.decode(jsonString);
    for (var map in mapsList) {
      if (map['uuid'] == uuid) {
        return AppUser.fromMap(map);
      }
    }
    return null;
  }

  /// Get an [AppUser] with [AppUser.name] equals [userName] from database.
  /// Returns null if no user with [userName] is found.
  Future<AppUser?> getUserFromUsername(String userName) async {
    return await _getUserFromUsernameLocally(userName);
  }

  Future<AppUser?> _getUserFromUsernameLocally(String userName) async {
    final usersFile = File('${_usersDir.path}/users.json');
    final jsonString = await usersFile.readAsString();
    final List<Map<String, dynamic>> mapsList = json.decode(jsonString);
    for (var map in mapsList) {
      if (map['name'] == userName) {
        return AppUser.fromMap(map);
      }
    }
    return null;
  }

  Future<AppUser?> _getUserFromUsernameFromServer(String userName) async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('users').get();
    final docsSnapshots = querySnapshot.docs;
    final maps = [for (var docSnapshot in docsSnapshots) docSnapshot.data()];
    for (Map<String, dynamic> map in maps) {
      if (map['name'] == userName) {
        return AppUser.fromMap(map);
      }
    }
    return null;
  }

  Future<void> saveLastUserLocally(AppUser appUser) async {
    final path = _usersDir.path;
    final lastUserFile = File('$path/last_user.json');
    await lastUserFile.writeAsString(appUser.toJson());
  }

  Future<AppUser?> loadLastUserLocally() async {
    final path = _usersDir.path;
    final lastUserFile = File('$path/last_user.json');

    if (!(await lastUserFile.exists())) return null;

    final jsonString = await lastUserFile.readAsString();
    return AppUser.fromJson(jsonString);
  }

  // Inventory Items Methods
  InventoryItem? getInventoryItemFromCode(String code) =>
      _inventoryItemsMap[code];

  List<InventoryItem> searchInventoryItemsFromString(String searchStr) {
    final List<InventoryItem> list = [];
    final List<String> searchStrList = searchStr.split(" ");
    for (var item in _inventoryItemsList) {
      for (var str in searchStrList) {
        if (item.toString().toUpperCase().contains(str.toUpperCase())) {
          list.add(item);
        }
      }
    }
    return list;
  }

  // Borrowings Methods
  Future<File?> getBorrowingPdfFile({required Borrowing borrowing}) async {
    return await getBorrowingPdfFileLocally(borrowing: borrowing);
  }

  Future<File?> getBorrowingPdfFileLocally(
      {required Borrowing borrowing}) async {
    final String borrowingsDirPath = _borrowingsDir.path;
    final String userUuid = borrowing.userUuid;
    final String borrowingUuid = borrowing.uuid;
    final Directory userPdfsDirectory =
        await Directory('$borrowingsDirPath/$userUuid').create();
    final file = File('${userPdfsDirectory.path}/$borrowingUuid.pdf');
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<File?> getBorrowingPdfFileFromServer(
      {required Borrowing borrowing}) async {
    if (!(await InternetConnectivityChecker.instance.isConnected)) return null;
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final borrowingRef = storageRef
          .child('borrowings/${borrowing.userUuid}/${borrowing.uuid}.pdf');
      try {
        final pdfBytes = await borrowingRef.getData();
        return await _savePdfLocally(borrowing: borrowing, pdfBytes: pdfBytes!);
      } catch (e) {
        debugPrint('[DEBUG] ERRO AO DOWNLOAD DO ARQUIVO');
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<List<String>> getBorrowedItemsCodes({
    required String userUuid,
  }) async {
    return await _getBorrowedItemsCodesLocally(userUuid);
  }

  Future<List<String>> _getBorrowedItemsCodesLocally(String userUuid) async {
    final String userBorrowingsPath =
        (await _getUserBorrowingsDirectory(userUuid: userUuid)).path;
    final borrowedItemsFile = File('$userBorrowingsPath/borrowedItems.json');

    if (await borrowedItemsFile.exists()) {
      final String borrowedItemsJson = await borrowedItemsFile.readAsString();
      if (borrowedItemsJson.isNotEmpty) {
        return json.decode(borrowedItemsJson) as List<String>;
      }
    }
    return [];
  }

  // OK ATÉ AQUI // OK ATÉ AQUI // OK ATÉ AQUI // OK ATÉ AQUI // OK ATÉ AQUI
  Future<void> saveBorrowingLocally({
    required Borrowing borrowing,
    required Uint8List pdfBytes,
  }) async {
    await _savePdfLocally(borrowing: borrowing, pdfBytes: pdfBytes);
    await _addToBorrowedItemsCodesLocally(
        userUuid: borrowing.userUuid, itemsCodes: borrowing.itemsCodes);
  }

  Future<bool> uploadBorrowingToServer({
    required Borrowing borrowing,
  }) async {
    if (!(await InternetConnectivityChecker.instance.isConnected)) return false;
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('borrowings')
          .doc(borrowing.uuid)
          .set(borrowing.toJsonMap());

      for (var code in borrowing.itemsCodes) {
        /// /[C]inventory_items/[D][inventory_item_code]
        firestore.collection('inventory_items').doc(code).update({
          'borrowed': true,
          'borrowerUuid': borrowing.userUuid,
        });
      }
      final pdfFile = await getBorrowingPdfFileLocally(borrowing: borrowing);
      final pdfBytes = await pdfFile!.readAsBytes();
      _uploadBorrowingPdfToServer(borrowing: borrowing, pdfBytes: pdfBytes);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> _uploadBorrowingPdfToServer({
    required Borrowing borrowing,
    required Uint8List pdfBytes,
  }) async {
    if (!(await InternetConnectivityChecker.instance.isConnected)) return false;
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final borrowingRef = storageRef
          .child('borrowings/${borrowing.userUuid}/${borrowing.uuid}.pdf');
      try {
        await borrowingRef.putData(
          pdfBytes,
          SettableMetadata(
            contentType: "application/pdf",
          ),
        );
        borrowing.pdfUrl = await borrowingRef.getDownloadURL();
      } catch (e) {
        debugPrint('[DEBUG] ERRO AO FAZER UPLOAD');
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> _addToBorrowedItemsCodesLocally({
    required String userUuid,
    required List<String> itemsCodes,
  }) async {
    debugPrint('Adicionando localmente aos itens emprestados!');
    List<String> borrowedItemsCodes =
        await getBorrowedItemsCodes(userUuid: userUuid);
    borrowedItemsCodes.addAll(itemsCodes);
    // remove any possible duplicates
    borrowedItemsCodes = [
      ...{...borrowedItemsCodes}
    ];
    final String userBorrowingsPath =
        (await _getUserBorrowingsDirectory(userUuid: userUuid)).path;
    final borrowedItemsFile = File('$userBorrowingsPath/borrowedItems.json');
    borrowedItemsFile.writeAsString(json.encode(borrowedItemsCodes));
    debugPrint('Itens Adicionados!');
  }

  Future<Directory> _getUserBorrowingsDirectory(
      {required String userUuid}) async {
    final String borrowingsDirPath = _borrowingsDir.path;
    return await Directory('$borrowingsDirPath/$userUuid').create();
  }

  Future<File> _savePdfLocally({
    required Borrowing borrowing,
    required Uint8List pdfBytes,
  }) async {
    debugPrint('Iniciando salvamento local do PDF!');
    final String userBorrowingsPath =
        (await _getUserBorrowingsDirectory(userUuid: borrowing.userUuid)).path;
    final pdfFile = File('$userBorrowingsPath/${borrowing.uuid}.pdf');
    await pdfFile.writeAsBytes(pdfBytes);
    debugPrint('Salvo!');
    return pdfFile;
  }

  /// [_appDir]/inventory_items/ = [_inventoryItemsDir]
  /// [_appDir]/inventory_items/inventory_items.json
  Future<List<InventoryItem>> _getInventoryItemsLocally() async {
    final inventoryItemsFile =
        File('${_inventoryItemsDir.path}/inventory_items.json');
    final itemsJson = await inventoryItemsFile.readAsString();
    final List<Map<String, dynamic>> mapsList = json.decode(itemsJson);
    final itemsList = [
      for (Map<String, dynamic> map in mapsList)
        InventoryItem.fromFirestoreMap(map)
    ];
    itemsList.sort((a, b) => a.code.compareTo(b.code));
    return itemsList;
  }

  /// [_appDir]/inventory_items/ = [_inventoryItemsDir]
  /// [_appDir]/inventory_items/inventory_items.json
  Future<void> _saveInventoryItemsLocally(
      List<InventoryItem> inventoryItems) async {
    final inventoryItemsFile =
        File('${_inventoryItemsDir.path}/inventory_items.json');
    final List<Map<String, dynamic>> mapsList = [
      for (var item in inventoryItems) item.toJsonMap()
    ];
    await inventoryItemsFile.writeAsString(json.encode(mapsList));
  }

  // TODO(danielassis-dev): delete in production (Used only to fix the database)
  Future<List<InventoryItem>> _getInventoryItemsFromAssets() async {
    final String jsonStr =
        await rootBundle.loadString('assets/database/inventory_items.json');
    final jsonMaps = json.decode(jsonStr);
    return [for (var map in jsonMaps) InventoryItem.fromJsonMap(map)];
  }

  Future<void> _uploadInventoryItemsToServer(
      {required List<InventoryItem> inventoryItems}) async {
    final firestore = FirebaseFirestore.instance;
    for (var item in inventoryItems) {
      /// /[C]inventory_items/[D][inventory_item_code]
      await firestore
          .collection('inventory_items')
          .doc(item.code)
          .set(item.toFirestoreMap());
    }
  }
}
