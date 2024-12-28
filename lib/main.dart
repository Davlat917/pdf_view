import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_app/pdf_w.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    loadManifest();
  }

  Future<void> loadManifest() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/manifest.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        pdfFiles = List<String>.from(jsonData['pdfs']);
      });
    } catch (e) {
      print("Error loading manifest: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: pdfFiles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pdfFiles.length,
              itemBuilder: (context, index) {
                final pdfPath = pdfFiles[index];
                return ListTile(
                  title: Text('PDF ${index + 1}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPdfViewer(assetPath: pdfPath),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
