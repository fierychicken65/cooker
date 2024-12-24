import 'package:flutter/material.dart';
import 'package:cooker/network/firebase_login.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class FileSummary extends StatefulWidget {
  const FileSummary({super.key});
  static const String id = 'fsummary';

  @override
  State<FileSummary> createState() => _FileSummaryState();
}

class _FileSummaryState extends State<FileSummary> {
  Future<String> generatedText(Map arguments) async {
    final prompt = TextPart("Explain this file in 500 words? Do not skip any detail and explain such that you cover every concept in this file");
    final response = await http.get(Uri.parse(arguments['url']));
    if (response.statusCode == 200) {
      final fileBytes = response.bodyBytes;
      final mimeType = lookupMimeType(arguments['url']) ?? 'application/octet-stream';
      final filePart = DataPart(mimeType, fileBytes);

      final generatedResponse = await model.generateContent([
        Content.multi([prompt, filePart])
      ]);
      return generatedResponse.text!;
    } else {
      throw Exception('Failed to load file');
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          (arguments['path'].split('/').last).split('.').first,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: FutureBuilder<String>(
            future: generatedText(arguments),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(arguments['path'], style: TextStyle(color: Colors.white)),
                    SizedBox(height: 20),
                    Text(snapshot.data ?? 'No content generated', style: TextStyle(fontSize: 15, color: Colors.white)),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}