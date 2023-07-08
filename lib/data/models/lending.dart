// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:qr_code_almox_app/data/models/app_user.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';

class Lending with ChangeNotifier {
  AppUser appUser;
  List<InventoryItem> inventoryItems;
  DateTime lendingDateTime = DateTime.now();
  String uuid;

  Lending({
    required this.appUser,
    this.inventoryItems = const [],
    DateTime? lendingDateTime,
    String? uuid,
  })  : lendingDateTime = lendingDateTime ?? DateTime.now(),
        uuid = uuid ?? const Uuid().v1();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'inventoryItems': inventoryItems.map((x) => x.toMap()).toList(),
      'appUser': appUser.toMap(),
      'lendingDateTime': lendingDateTime.millisecondsSinceEpoch,
      'uuid': uuid,
    };
  }

  factory Lending.fromMap(Map<String, dynamic> map) {
    return Lending(
      appUser: AppUser.fromMap(map['appUser'] as Map<String, dynamic>),
      inventoryItems: List<InventoryItem>.from(
        (map['inventoryItems'] as List<int>).map<InventoryItem>(
          (x) => InventoryItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      lendingDateTime:
          DateTime.fromMillisecondsSinceEpoch(map['lendingDateTime'] as int),
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lending.fromJson(String source) =>
      Lending.fromMap(json.decode(source) as Map<String, dynamic>);
}
