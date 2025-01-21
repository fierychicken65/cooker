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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          ],
        ),
      ),
    );
  }
}
