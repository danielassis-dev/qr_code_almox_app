// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:uuid/uuid.dart';

class AppUser {
  String _name;

  String get name => _name;

  String get firstName => name.split(' ')[0];

  set name(String value) {
    _name = value.trim();
  }

  String _uuid;

  String get uuid => _uuid;

  /// Creates an [AppUser] object. [uuid] must be provided unless its a new user.
  /// If [uuid] is not provied one is created and assigned (used for new users).
  AppUser({required String name, String? uuid})
      : _uuid = uuid ?? const Uuid().v1(),
        _name = name.trim();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': _name,
      'uuid': _uuid,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'],
      uuid: map['uuid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
