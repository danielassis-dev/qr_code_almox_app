// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class AppUser with ChangeNotifier {
  String? _name;

  String? get name => _name;

  String? get firstName => _name?.split(' ')[0];

  set name(String? value) {
    _name = value?.trim();
    notifyListeners();
  }

  String? _uuid;

  String? get uuid => _uuid;

  set uuid(String? value) {
    _uuid = value;
    notifyListeners();
  }

  bool _isLogedInLocally = false;

  bool get isLogedInLocally => _isLogedInLocally;

  set isLogedInLocally(bool value) {
    _isLogedInLocally = value;
    notifyListeners();
  }

  AppUser({String? name, String? uuid})
      : _uuid = uuid,
        _name = name {
    uuid = uuid ?? const Uuid().v1();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uuid': uuid,
      'isLogedInLocally': isLogedInLocally,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] != null ? map['name'] as String : null,
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
