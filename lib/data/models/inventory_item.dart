// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String code;
  final String description;
  final DateTime entryDate;
  final bool lendable;
  final String imageUrl;
  bool borrowed;
  String? borrowerUuid;

  InventoryItem({
    required this.code,
    required this.description,
    required this.entryDate,
    required this.lendable,
    required this.imageUrl,
    this.borrowed = false,
    this.borrowerUuid,
  });

  @override
  String toString() {
    return "$code - $description";
  }

  Map<String, dynamic> toJsonMap() {
    return <String, dynamic>{
      'code': code,
      'description': description,
      'entryDate': entryDate.millisecondsSinceEpoch,
      'lendable': lendable,
      'imageUrl': imageUrl,
      'borrowed': borrowed,
      'borrowerUuid': borrowerUuid,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      'code': code,
      'description': description,
      'entryDate': entryDate,
      'lendable': lendable,
      'imageUrl': imageUrl,
      'borrowed': borrowed,
      'borrowerUuid': borrowerUuid,
    };
  }

  factory InventoryItem.fromJsonMap(Map<String, dynamic> map) {
    return InventoryItem(
      code: map['code'],
      description: map['description'],
      entryDate: DateTime.fromMillisecondsSinceEpoch(map['entryDate'] as int),
      lendable: map['lendable'],
      imageUrl: map['imageUrl'],
      borrowed: map['borrowed'] ?? false,
      borrowerUuid: map['borrowerUuid'],
    );
  }

  factory InventoryItem.fromFirestoreMap(Map<String, dynamic> map) {
    return InventoryItem(
      code: map['code'],
      description: map['description'],
      entryDate: (map['entryDate'] as Timestamp).toDate(),
      lendable: map['lendable'],
      imageUrl: map['imageUrl'],
      borrowed: map['borrowed'] ?? false,
      borrowerUuid: map['borrowerUuid'],
    );
  }

  String toJson() => json.encode(toJsonMap());

  factory InventoryItem.fromJson(String source) =>
      InventoryItem.fromJsonMap(json.decode(source) as Map<String, dynamic>);
}
