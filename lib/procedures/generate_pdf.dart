import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code_almox_app/data/models/app_user.dart';
import 'package:qr_code_almox_app/data/models/inventory_item.dart';

pw.Widget _header({
  required DateTime dateTime,
  required pw.MemoryImage logo,
  required String userName,
}) {
  return pw.Column(
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
              verticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 5.0),
                  child: pw.Center(
                    child: pw.Image(logo, width: 40),
                  ),
                ),
                pw.Center(
                    child: pw.Text(
                  '''
                      RR Domótica - Serviços de Automação e Manutenção
                      Industrial e Residencial
                      ''',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                )),
                pw.Center(
                    child: pw.Text(
                        DateFormat('dd/MM/yyyy - HH:mm').format(dateTime))),
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
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                  margin: const pw.EdgeInsets.only(left: 5.0),
                  child: pw.Text(
                    userName,
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
                  child: pw.Text('Lista de Ferramentas Emprestadas',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _itemsTable({
  required List<InventoryItem> inventoryItems,
}) {
  final tableRows = <pw.TableRow>[];
  for (int i = 0; i < inventoryItems.length; i++) {
    tableRows.add(pw.TableRow(
      children: [
        pw.Center(child: pw.Text(NumberFormat('00').format(i + 1))),
        pw.Center(child: pw.Text(inventoryItems[i].code)),
        pw.Container(
          margin: const pw.EdgeInsets.only(left: 5.0),
          child: pw.Text(inventoryItems[i].description),
        ),
      ],
    ));
  }
  return pw.Column(
    children: [
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
            ...tableRows,
          ],
        ),
      ),
    ],
  );
}

Future<List<pw.Page>> _anexedImages({
  required pw.MemoryImage logo,
  required List<File> imageFiles,
}) async {
  const int groupLen = 2;
  List<pw.Page> pages = <pw.Page>[];
  for (int i = 0; i < imageFiles.length / groupLen; i++) {
    List<pw.Widget> widgetList = <pw.Widget>[];
    for (int j = 0; j < groupLen; j++) {
      int index = groupLen * i + j;
      if (index < imageFiles.length) {
        Uint8List imageBytes = await imageFiles[index].readAsBytes();
        widgetList.add(pw.Column(
          children: [
            pw.Text('Foto ${index + 1}:'),
            pw.Image(
              pw.MemoryImage(imageBytes),
              height: 12 * PdfPageFormat.cm,
            ),
          ],
        ));
      }
    }
    pages.add(pw.Page(
      build: (context) {
        return pw.Column(children: widgetList);
      },
    ));
  }
  return pages;
}

Future<Uint8List> generatePDF(
    {required AppUser appUser,
    required List<InventoryItem> inventoryItems,
    required List<File> imageFiles,
    required DateTime dateTime}) async {
  final pw.MemoryImage logoRrDomo = pw.MemoryImage(
      (await rootBundle.load('assets/images/rr_domo_logo.png'))
          .buffer
          .asUint8List());
  final anexedImages = await _anexedImages(
    logo: logoRrDomo,
    imageFiles: imageFiles,
  );

  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            _header(
              dateTime: dateTime,
              logo: logoRrDomo,
              userName: appUser.name,
            ),
            _itemsTable(inventoryItems: inventoryItems),
          ],
        );
      },
    ),
  );

  for (var anexPage in anexedImages) {
    pdf.addPage(anexPage);
  }

  final Uint8List pdfBytes = await pdf.save();
  return pdfBytes;
}
