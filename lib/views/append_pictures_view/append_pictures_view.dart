import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AppendPicturesView extends StatelessWidget {
  const AppendPicturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          WidgetsFlutterBinding.ensureInitialized();
          final cameras = await availableCameras();
          final firstCamera = cameras.first;
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
