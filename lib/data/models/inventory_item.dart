// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InventoryItem {
  final String code;
  final String description;
  final DateTime entryDate;
  final bool landable;
  final String imageUrl;

  InventoryItem({
    required this.code,
    required this.description,
    required this.entryDate,
    required this.landable,
    required this.imageUrl,
  });

  @override
  String toString() {
    return "$code - $description";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'description': description,
      'entryDate': entryDate.millisecondsSinceEpoch,
      'landable': landable,
      'imageUrl': imageUrl,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      code: map['code'] as String,
      description: map['description'] as String,
      entryDate: DateTime.fromMillisecondsSinceEpoch(map['entryDate'] as int),
      landable: map['landable'] as bool,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryItem.fromJson(String source) =>
      InventoryItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
