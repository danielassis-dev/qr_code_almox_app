import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            FilledButton(
                onPressed: () async {
                  final logoRrDomo = pw.MemoryImage(
                      (await rootBundle.load('assets/images/rr_domo_logo.png'))
                          .buffer
                          .asUint8List());
                  final pdf = pw.Document();

                  pdf.addPage(
                    pw.Page(
                      build: (pw.Context context) => pw.Column(
                        children: [
                          pw.Container(
                            child: pw.Table(
                              border: pw.TableBorder.all(),
                              columnWidths: {
                                0: const pw.FixedColumnWidth(50),
                                1: const pw.FixedColumnWidth(350),
                                2: const pw.FixedColumnWidth(110),
                              },
                              tableWidth: pw.TableWidth.min,
                              children: [
                                pw.TableRow(
                                  verticalAlignment:
                                      pw.TableCellVerticalAlignment.middle,
                                  children: [
                                    pw.Container(
                                      margin: const pw.EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: pw.Center(
                                        child: pw.Image(logoRrDomo, width: 40),
                                      ),
                                    ),
                                    pw.Center(
                                        child: pw.Text(
                                      '''
RR Domótica - Serviços de Automação e Manutenção
Industrial e Residencial
''',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                    )),
                                    pw.Center(
                                        child: pw.Text(
                                            DateFormat('d/MM/y - HH:mm')
                                                .format(DateTime.now()))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            child: pw.Table(
                              border: pw.TableBorder.all(),
                              columnWidths: {0: const pw.FixedColumnWidth(510)},
                              tableWidth: pw.TableWidth.min,
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.Center(
                                      child: pw.Text('CAUTELA DE FERRAMENTAS',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 5.0),
                            child: pw.Table(
                              border: pw.TableBorder.all(),
                              columnWidths: {
                                0: const pw.FixedColumnWidth(90),
                                1: const pw.FixedColumnWidth(420),
                              },
                              tableWidth: pw.TableWidth.min,
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('Responsável:')),
                                    pw.Container(
                                      margin:
                                          const pw.EdgeInsets.only(left: 5.0),
                                      child: pw.Text(
                                        'Daniel Assis Carneiro Daniel Assis Carneiro',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            margin: const pw.EdgeInsets.only(top: 5.0),
                            child: pw.Table(
                              border: pw.TableBorder.all(),
                              columnWidths: {0: const pw.FixedColumnWidth(510)},
                              tableWidth: pw.TableWidth.min,
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.Center(
                                      child: pw.Text(
                                          'Lista de Ferramentas Emprestadas',
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            child: pw.Table(
                              border: pw.TableBorder.all(),
                              columnWidths: {
                                0: const pw.FixedColumnWidth(40),
                                1: const pw.FixedColumnWidth(70),
                                2: const pw.FixedColumnWidth(400),
                              },
                              tableWidth: pw.TableWidth.min,
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('Item')),
                                    pw.Center(child: pw.Text('Código')),
                                    pw.Center(child: pw.Text('Descrição')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            child: pw.Table(
                              border: pw.TableBorder.all(),
                              columnWidths: {
                                0: const pw.FixedColumnWidth(40),
                                1: const pw.FixedColumnWidth(70),
                                2: const pw.FixedColumnWidth(400),
                              },
                              tableWidth: pw.TableWidth.min,
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('01')),
                                    pw.Center(child: pw.Text('RRD_0078')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('01')),
                                    pw.Center(child: pw.Text('RRD_0078')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                                pw.TableRow(
                                  children: [
                                    pw.Center(child: pw.Text('02')),
                                    pw.Center(child: pw.Text('RRD_0079')),
                                    pw.Text(
                                        'Caixa de ferramentas de plástico 16" Millenium'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                  pdf.addPage(pw.Page(
                    build: (context) => pw.Column(
                      children: [
                        pw.Text('Foto 1:'),
                        pw.Image(logoRrDomo, width: 510),
                      ],
                    ),
                  ));

                  debugPrint('Iniciando salvamento!');

                  Directory? tempDir = await getExternalStorageDirectory();
                  final path = tempDir?.path;
                  final file = File('$path/example.pdf');
                  await file.writeAsBytes(await pdf.save());
                  debugPrint(file.path);
                  debugPrint('Salvo!');

                  final storageRef = FirebaseStorage.instance.ref();
                  final borrowRef = storageRef.child('borrow/example - 03.pdf');

                  final db = FirebaseFirestore.instance;

                  // Create a new user with a first and last name
                  final user = <String, dynamic>{
                    "first": "Ada",
                    "last": "Lovelace",
                    "born": 1815
                  };

                  // Add a new document with a generated ID
                  db.collection("users").add(user).then((DocumentReference
                          doc) =>
                      debugPrint('DocumentSnapshot added with ID: ${doc.id}'));

                  try {
                    await borrowRef.putData(
                      await pdf.save(),
                      SettableMetadata(
                        contentType: "application/pdf",
                      ),
                    );
                    debugPrint(
                        '[DEBUG] URL p/ Download: ${await borrowRef.getDownloadURL()}');
                  } catch (e) {
                    debugPrint('[DEBUG] ERRO AO FAZER UPLOAD');
                  }
                },
                child: const Text('Gerar PDF!')),
          ],
        ),
      ),
    );
  }
}
