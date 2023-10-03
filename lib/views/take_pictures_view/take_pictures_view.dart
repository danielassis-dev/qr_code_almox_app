import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePicturesView extends StatefulWidget {
  const TakePicturesView({
    super.key,
    required this.cameraDescription,
  });

  final CameraDescription cameraDescription;

  @override
  State<TakePicturesView> createState() => _TakePicturesViewState();
}

class _TakePicturesViewState extends State<TakePicturesView> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameraDescription,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tire uma foto')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 70.0,
                width: 70.0,
                child: FilledButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _cameraController.takePicture();

                        if (!mounted) return;

                        Navigator.of(context).pop<String>(image.path);
                        return;
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                    child: const Icon(Icons.camera)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
