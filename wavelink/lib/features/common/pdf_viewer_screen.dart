import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PDFViewerScreen extends StatefulWidget {
  final String url;

  const PDFViewerScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF();
  }

  Future<void> _downloadAndSavePDF() async {
    try {
      final data = await http.get(Uri.parse(widget.url));

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/temp.pdf");

      await file.writeAsBytes(data.bodyBytes);

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      print("PDF load error → $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("View Document", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : localPath == null
              ? const Center(
                  child: Text("Failed to load PDF",
                      style: TextStyle(color: Colors.red)),
                )
              : PDFView(
                  filePath: localPath!,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                ),
    );
  }
}
