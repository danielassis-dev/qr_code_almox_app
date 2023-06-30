import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../data/models/app_user.dart';

Future<void> initializeApp(BuildContext context) async {
  await loadLastUser(context);
  await Firebase.initializeApp();
}

Future<void> loadLastUser(BuildContext context) async {
  final appUser = context.read<AppUser>();

  final appDir = await getApplicationDocumentsDirectory();
  final usersDir = await Directory('${appDir.path}/users').create();
  final path = usersDir.path;
  final lastUserFile = File('$path/last_user.json');

  if (!(await lastUserFile.exists())) return;

  final jsonString = await lastUserFile.readAsString();

  final lastUser = AppUser.fromJson(jsonString);
  appUser.isLogedInLocally = true;
  appUser.name = lastUser.name;
  appUser.uuid = lastUser.uuid;
}
