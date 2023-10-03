import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/managers/user_manager.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userManager = context.read<UserManager>();
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
                onPressed: () async {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text('Fazendo Login'),
                      content: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  );
                  await userManager.login(nameController.text);
                  if (context.mounted) Navigator.of(context).pop();
                  if (context.mounted) Navigator.of(context).pop();
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
