import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final Uri _url = Uri.parse(arguments['url']);
    Future<void> _launchUrl() async {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }

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
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        color: Colors.white12,
                        splashColor: Colors.purpleAccent,
                        onPressed: ()async {
                          _launchUrl();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.coffee, size: 50, color: Colors.purple),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'Open File',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
