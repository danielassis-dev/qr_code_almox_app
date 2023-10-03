import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/constants.dart';
import 'package:qr_code_almox_app/data/managers/inventory_manager.dart';
import 'package:qr_code_almox_app/data/managers/user_manager.dart';
import 'package:qr_code_almox_app/procedures/check_internet_connection.dart';

import 'package:qr_code_almox_app/views/borrow_view/borrow_view.dart';
import 'package:qr_code_almox_app/views/borrowings_view/borrowings_view.dart';
import 'package:qr_code_almox_app/views/devolution_view/devolution_view.dart';
import 'package:qr_code_almox_app/views/devolutions_view/devolutions_view.dart';
import 'package:qr_code_almox_app/views/home_view/home_view.dart';
import 'package:qr_code_almox_app/views/login_view/login_view.dart';

void main() {
  runApp(const QrCodeAlmoxApp());
}

class QrCodeAlmoxApp extends StatelessWidget {
  const QrCodeAlmoxApp({super.key});

  Future<void> initializeApp(BuildContext context) async {
    final userManager = context.read<UserManager>();
    final cameras = context.read<List<CameraDescription>>();

    // Load Last User. If there none is found, send a new empty logged-out user
    await userManager.loadLastUser();

    WidgetsFlutterBinding.ensureInitialized();
    cameras.addAll(await availableCameras());

    return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserManager()),
        Provider(create: (context) => <CameraDescription>[]),
        ChangeNotifierProvider<InternetConnectivityChecker>(
            create: (context) => InternetConnectivityChecker.instance),
        Provider(
          create: (context) => InventoryManager(),
        )
      ],
      child: Builder(builder: (context) {
        ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);
        colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primaryContainer: colorScheme.primary,
          onPrimaryContainer: colorScheme.onPrimary,
        );
        return FutureBuilder(
            future: initializeApp(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Carregando',
                  theme: ThemeData(
                    colorScheme: colorScheme,
                    useMaterial3: true,
                  ),
                  home: Scaffold(
                    appBar: AppBar(
                      title: const Text('Carregando'),
                    ),
                    body: const Center(
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: CircularProgressIndicator(strokeWidth: 5.0),
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.hasError ||
                  (context.watch<List<CameraDescription>>().isEmpty)) {
                return MaterialApp(
                  debugShowCheckedModeBanner: true,
                  title: 'Erro',
                  theme: ThemeData(
                    colorScheme: colorScheme,
                    useMaterial3: true,
                  ),
                  home: Scaffold(
                    appBar: AppBar(
                      title: const Text('Erro ao Iniciar!'),
                    ),
                    body: const Center(
                      child: Text('Erro ao Iniciar!',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                );
              }
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Escaner Almoxarifado',
                theme: ThemeData(
                  colorScheme: colorScheme,
                  useMaterial3: true,
                ),
                routes: {
                  loginViewName: (context) => LoginView(),
                  borrowViewName: (context) => const BorrowView(),
                  borrowingsViewName: (context) => const BorrowingsView(),
                  devolutionViewName: (context) => const DevolutionView(),
                  devolutionsViewName: (context) => const DevolutionsView(),
                },
                home: const HomeView(),
              );
            });
      }),
    );
  }
}
