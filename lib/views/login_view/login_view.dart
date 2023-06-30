import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final nameController = TextEditingController();

  Future<void> registerUser(BuildContext context, String name) async {
    final appUser = context.read<AppUser>();

    final appDir = await getApplicationDocumentsDirectory();
    final usersDir = await Directory('${appDir.path}/users').create();
    final path = usersDir.path;
    final usersFile = File('$path/users.json');
    final lastUserFile = File('$path/last_user.json');

    List<AppUser> appUsers = [];

    if (await usersFile.exists()) {
      final jsonString = await usersFile.readAsString();
      debugPrint(jsonString);
      appUsers.addAll(List<AppUser>.from(
          (json.decode(jsonString)).map((e) => AppUser.fromMap(e))));
    }

    appUser.name = name;
    appUser.isLogedInLocally = true;

    int userIndex =
        appUsers.indexWhere((element) => element.name == appUser.name);
    if (userIndex != -1) {
      appUser.uuid = appUsers[userIndex].uuid;
      appUsers[userIndex] = appUser;
    } else {
      appUsers.add(appUser);
    }

    debugPrint('Iniciando salvamento do usuario!');
    await usersFile
        .writeAsString(json.encode(appUsers.map((e) => e.toMap()).toList()));
    await lastUserFile.writeAsString(appUser.toJson());
    debugPrint(usersFile.path);
    debugPrint('Salvo!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(32),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Login",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  hintText: "Nome Completo"),
              controller: nameController,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  registerUser(context, nameController.text);
                  Navigator.of(context).pop();
                },
                child: const Text("Login"),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
