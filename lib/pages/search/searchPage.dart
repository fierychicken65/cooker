import 'package:flutter/material.dart';
import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static String id = 'search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchBarController;
  late String prompt;
  String response = "";
  bool circularLoading = false;
  final model =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchBarController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: AnimatedTextField(
              controller: _searchBarController,
              cursorColor: Colors.red,
              animationType: Animationtype.typer,
              hintTextStyle: const TextStyle(
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
              hintTexts: const [
                'search for king pics in  gallery',
                'I need my 12th mark sheet',
                'give me books on data analytics',
              ],
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 4),
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
          Center(
            child: MaterialButton(
              onPressed: () async {
                setState(() {
                  circularLoading = true;
                });
                prompt = _searchBarController.text;
                print(prompt);
                final query = [
                  Content.text(prompt +
                      " in this format name: \n  description: \n only these 2 features should be mentioned in 50 words max")
                ];
                final resp = await model.generateContent(query);
                setState(() {
                  response = resp.text!;
                  circularLoading = false;
                });
                print(response);
                _searchBarController.clear();
              },
              color: Colors.red,
              child: Icon(
                Icons.search,
              ),
            ),
          ),
          circularLoading
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: 500,
                    child: SingleChildScrollView(
                      child: Text(
                        '$response',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
          Container(
            height: 100,
            child: Text('yes'),
          ),
        ],
      ),
    );
  }
}
