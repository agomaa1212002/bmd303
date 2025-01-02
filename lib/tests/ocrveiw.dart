import 'package:flutter/material.dart';

class OcrResultPage extends StatelessWidget {
  final String extractedText;

  OcrResultPage({required this.extractedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR Result'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            extractedText,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
