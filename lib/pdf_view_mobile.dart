import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfViewPage extends StatelessWidget {
  final String filePath;

  const PdfViewPage({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Open the PDF file immediately when the page is built.
    _openFile(filePath, context);

    return Container();
    
  }

  // This method uses open_filex to open the file.
  void _openFile(String filePath, BuildContext context) async {

    final byteData = await rootBundle.load(filePath);
    final tempDir = await getTemporaryDirectory();
    final fileName = filePath.split('/').last;
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes), flush: true);

    final result = await OpenFilex.open(tempFile.path);

    // If the PDF couldn't be opened, show an error.
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to open the file: ${result.message}"),
        ),
      );
    }
  }
}

