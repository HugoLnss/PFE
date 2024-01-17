import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

// interface pour la version mobile pour afficher un pdf
class PdfViewPage extends StatelessWidget {
  final Uint8List fileBytes; 

  const PdfViewPage({Key? key, required this.fileBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF View")),
      body: PDFView(
        pdfData: fileBytes,
      ),
    );
  }
}
