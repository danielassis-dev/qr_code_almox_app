import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';
import 'package:qr_code_almox_app/views/cart_view/cart_view.dart';
import 'package:qr_code_almox_app/views/login_view/login_view.dart';

import '../../widgets/user_icon_button.dart';
import '../pdf_view/pdf_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          UserIconButton(
            appUser: context.watch<AppUser>(),
            onPressed: () {
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
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartView()));
              },
              child: const Text('Emprestar!'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CartView()));
              },
              child: const Text('Devolver!'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PdfView()));
              },
              child: const Text('Gerar PDF!'),
            ),
          ],
        ),
      ),
    );
  }
}
