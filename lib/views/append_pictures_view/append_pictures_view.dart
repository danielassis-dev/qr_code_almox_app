import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_almox_app/data/models/change_notifier_list.dart';
import 'package:qr_code_almox_app/views/take_pictures_view/take_pictures_view.dart';
import 'package:qr_code_almox_app/widgets/animated_show_floating_action_button.dart';

class AppendPicturesView extends StatelessWidget {
  const AppendPicturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeNotifierFileList>(
      create: (context) => ChangeNotifierFileList(),
      child: Builder(builder: (context) {
        return WillPopScope(
          // clear the cache memory so as to not acumulate.
          // dont know if it's necessary, though. Maybe the android OS does this automatically.
          onWillPop: () async {
            await context.read<ChangeNotifierFileList>().clear();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Adicione Fotos'),
            ),
            body: Column(
              children: [
                const Center(),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount:
                        context.watch<ChangeNotifierFileList>().length + 1,
                    itemBuilder: (context, index) {
                      final imageFiles =
                          context.watch<ChangeNotifierFileList>();
                      // itemCount = images.length + 1
                      // we want the last item to be the add button
                      if (index < imageFiles.length) {
                        return ElevatedButton(
                          onPressed: () {
                            final imageFiles =
                                context.read<ChangeNotifierFileList>();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Foto do empréstimo'),
                                  content: Image.file(imageFiles[index]),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await imageFiles.removeFileAt(index);
                                      },
                                      child: const Text(
                                        'Excluir Imagem',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
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
                          final cameras =
                              context.read<List<CameraDescription>>();
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
                            shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
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
            floatingActionButton: AnimatedShowFloaingActionButton(
              duration: const Duration(milliseconds: 500),
              showButton: context.watch<ChangeNotifierFileList>().isNotEmpty,
              label: const Text('Concluir'),
              icon: const Icon(Icons.arrow_forward),
              onPressed: () async {
                Navigator.of(context)
                    .pop(context.read<ChangeNotifierFileList>().toList());
                return;
              },
            ),
          ),
        );
      }),
    );
  }
}
