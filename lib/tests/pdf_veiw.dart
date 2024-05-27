import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewPage extends StatelessWidget {
  final String pdfUrl;
  final String pdfDescription;

  PDFViewPage({required this.pdfUrl, required this.pdfDescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pdfDescription),
      ),
      body: PDFView(
        filePath: pdfUrl,
      ),
    );
  }
}
