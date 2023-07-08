import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/models/change_notifier_list.dart';
import 'package:qr_code_almox_app/views/take_pictures_view/take_pictures_view.dart';

class AppendPicturesView extends StatelessWidget {
  const AppendPicturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeNotifierFileList>(
      create: (context) => ChangeNotifierFileList(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Adicione Fotos'),
          ),
          body: Column(
            children: [
              const Center(),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: context.watch<ChangeNotifierFileList>().length + 1,
                  itemBuilder: (context, index) {
                    final imageFiles = context.watch<ChangeNotifierFileList>();
                    // index         is {0, 1, 2, 3...}
                    // images.length is {1, 2, 3, 4...}
                    // itemCount = images.length + 1
                    // we want the last item to be the add button
                    if (index < imageFiles.length) {
                      return ElevatedButton(
                        onPressed: () {
                          final imageFiles =
                              context.read<ChangeNotifierFileList>();
                          // imageFiles.removeAt(index);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Foto do empréstimo'),
                                content: Image.file(imageFiles[index]),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        imageFiles.removeAt(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Excluir Imagem',
                                        style: TextStyle(color: Colors.red),
                                      )),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Manter'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(18.0)))),
                        child: Image.file(imageFiles[index]),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () async {
                        final cameras = context.read<List<CameraDescription>>();
                        final ChangeNotifierFileList imageFiles =
                            context.read<ChangeNotifierFileList>();

                        final imagePath = await Navigator.of(context)
                            .push<String>(MaterialPageRoute(
                                builder: (context) => TakePicturesView(
                                    cameraDescription: cameras.first)));
                        if (imagePath == null) return;
                        debugPrint('[DEBUG - APP]: $imagePath');
                        imageFiles.add(File(imagePath));
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStatePropertyAll<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                      child: const Icon(Icons.add_a_photo),
                    );
                  },
                ),
              ),
              const Center(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add_a_photo),
          ),
        );
      }),
    );
  }
}
