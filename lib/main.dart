import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/models/app_user.dart';
import 'package:qr_code_almox_app/initialization/initialize_app.dart';
import 'package:qr_code_almox_app/views/home_view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppUser()),
      ],
      child: Builder(builder: (context) {
        return FutureBuilder(
            future: initializeApp(context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return MaterialApp(
                  debugShowCheckedModeBanner: true,
                  title: 'Erro',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
              if (snapshot.connectionState == ConnectionState.done) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Escaner Almoxarifado',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
                    useMaterial3: true,
                  ),
                  home: const HomeView(),
                );
              }
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Carregando',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
            });
      }),
    );
  }
}
