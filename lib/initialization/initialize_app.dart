import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/app_user.dart';

Future<Map<String, dynamic>> initializeApp() async {
  // Load Last User. If there none is found, send a new empty logged-out user
  final Map<String, dynamic> returnMap = {};
  returnMap['lastUser'] = await loadLastUser();

  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  final List<CameraDescription> cameras = await availableCameras();
  returnMap['availableCameras'] = cameras;

  return returnMap;
}

Future<AppUser> loadLastUser() async {
  final appDir = await getApplicationDocumentsDirectory();
  final usersDir = await Directory('${appDir.path}/users').create();
  final path = usersDir.path;
  final lastUserFile = File('$path/last_user.json');

  if (!(await lastUserFile.exists())) return AppUser();

  final jsonString = await lastUserFile.readAsString();

  final lastUser = AppUser.fromJson(jsonString);
  lastUser.isLogedInLocally = true;
  return lastUser;
}
