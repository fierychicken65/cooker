import 'package:flutter/material.dart';

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
    print(arguments['path'].split('/').last);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          (arguments['path'].split('/').last).split('.').first,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Stack(
          children: [
            Column(
              children: [
                Text(arguments['path'],style: TextStyle(color: Colors.white),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
