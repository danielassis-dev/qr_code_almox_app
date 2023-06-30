import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';

class UserIconButton extends StatelessWidget {
  final AppUser appUser;
  final void Function() onPressed;

  const UserIconButton({
    required this.appUser,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: appUser.isLogedInLocally
          ? Row(
              children: [
                Text('${appUser.firstName}'),
                const Icon(Icons.logout),
              ],
            )
          : const Row(
              children: [
                Text('Login'),
                Icon(Icons.login),
              ],
            ),
    );
  }
}
