// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class UserIconButton extends StatelessWidget {
  final bool isLoggedIn;
  final String? firstName;
  final void Function() onPressed;

  const UserIconButton({
    required this.isLoggedIn,
    this.firstName,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: isLoggedIn
          ? Row(
              children: [
                Text(firstName ?? 'USUÁRIO SEM NOME'),
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
