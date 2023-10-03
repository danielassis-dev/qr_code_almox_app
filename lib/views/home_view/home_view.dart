import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/constants.dart';
import 'package:qr_code_almox_app/data/managers/user_manager.dart';
import 'package:qr_code_almox_app/procedures/check_internet_connection.dart';
import 'package:qr_code_almox_app/views/login_view/login_view.dart';

import '../../widgets/user_icon_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          UserIconButton(
            isLoggedIn: userManager.isLoggedIn,
            firstName: userManager.appUser?.firstName,
            onPressed: () {
              userManager.logout();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginView()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            FilledButton(
              onPressed: userManager.isLoggedIn
                  ? () => Navigator.of(context).pushNamed(borrowViewName)
                  : null,
              child: const Text('Emprestar'),
            ),
            FilledButton(
              onPressed: userManager.isLoggedIn
                  ? () => Navigator.of(context).pushNamed(devolutionViewName)
                  : null,
              child: const Text('Devolver'),
            ),
            FilledButton(
              onPressed: userManager.isLoggedIn
                  ? () => Navigator.of(context).pushNamed(borrowingsViewName)
                  : null,
              child: const Text('Consultar Empréstimos'),
            ),
            FilledButton(
              onPressed: userManager.isLoggedIn
                  ? () => Navigator.of(context).pushNamed(devolutionsViewName)
                  : null,
              child: const Text('Consultar Devoluções'),
            ),
            context
                    .watch<InternetConnectivityChecker>()
                    .watchableConnectionStatus
                ? const Text(
                    'CONECTADO',
                    style: TextStyle(color: Colors.green),
                  )
                : const Text(
                    'NÃO CONCETADO',
                    style: TextStyle(color: Colors.red),
                  ),
          ],
        ),
      ),
    );
  }
}
