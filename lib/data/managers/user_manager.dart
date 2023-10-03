import 'package:flutter/foundation.dart';
import 'package:qr_code_almox_app/data/database/database_interface.dart';

import 'package:qr_code_almox_app/data/models/app_user.dart';

class UserManager with ChangeNotifier {
  UserManager({
    AppUser? appUser,
  }) : _appUser = appUser;

  AppUser? _appUser;

  AppUser? get appUser => _appUser;

  bool get isLoggedIn => _appUser != null ? true : false;

  Future<void> login(String name) async {
    DatabaseInterface db = await DatabaseInterface.instance;
    AppUser? appUser = await db.getUserFromUsername(name);

    // Logs in if ser already Registered. Creates New User otherwise.
    if (appUser != null) {
      _appUser = appUser;
    } else {
      _appUser = AppUser(name: name);
      await db.registerNewUser(_appUser!);
    }
    db.saveLastUserLocally(_appUser!);
    notifyListeners();
    return;
  }

  Future<void> loadLastUser() async {
    final db = await DatabaseInterface.instance;
    _appUser = await db.loadLastUserLocally();
    notifyListeners();
  }

  void logout() {
    _appUser = null;
    notifyListeners();
  }
}
