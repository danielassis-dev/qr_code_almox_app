// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Borrowing {
  final String _userUuid;
  final List<String> _itemsCodes;
  final DateTime _borrowDateTime;
  final String _uuid;

  String get userUuid => _userUuid;
  List<String> get itemsCodes => [..._itemsCodes];
  DateTime get borrowDateTime => _borrowDateTime;
  String get uuid => _uuid;

  // Meant for new borrowings
  Borrowing({
    required String userUuid,
    required List<String> itemsCodes,
  })  : _userUuid = userUuid,
        _itemsCodes = itemsCodes,
        _borrowDateTime = DateTime.now(),
        _uuid = const Uuid().v1();

  Borrowing.load({
    required String userUuid,
    required List<String> itemsUuids,
    required DateTime borrowDateTime,
    required String uuid,
  })  : _uuid = uuid,
        _borrowDateTime = borrowDateTime,
        _userUuid = userUuid,
        _itemsCodes = itemsUuids;

  factory Borrowing.fromJsonMap(Map<String, dynamic> map) {
    return Borrowing.load(
      userUuid: map['userUuid'],
      itemsUuids: map['itemsUuids'],
      borrowDateTime:
          DateTime.fromMillisecondsSinceEpoch(map['borrowDateTime'] as int),
      uuid: map['uuid'],
    );
  }

  factory Borrowing.fromJson(String source) =>
      Borrowing.fromJsonMap(json.decode(source) as Map<String, dynamic>);

  factory Borrowing.fromFirestoreMap(Map<String, dynamic> map) {
    return Borrowing.load(
      userUuid: map['userUuid'],
      itemsUuids: map['itemsUuids'],
      borrowDateTime: (map['borrowDateTime'] as Timestamp).toDate(),
      uuid: map['uuid'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    return <String, dynamic>{
      'inventoryItems': itemsCodes,
      'userUuid': userUuid,
      'lendingDateTime': borrowDateTime.millisecondsSinceEpoch,
      'uuid': uuid,
    };
  }

  String toJson() => json.encode(toJsonMap());

  Map<String, dynamic> toFirestoreMap() {
    return <String, dynamic>{
      'inventoryItems': itemsCodes,
      'userUuid': userUuid,
      'lendingDateTime': borrowDateTime,
      'uuid': uuid,
    };
  }
}
