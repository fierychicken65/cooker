import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootDirPage extends StatefulWidget {
  const RootDirPage({super.key});
  static String id = 'root_dir_screen';
  @override
  State<RootDirPage> createState() => _RootDirPageState();
}

class _RootDirPageState extends State<RootDirPage> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    late String? image = _auth.currentUser?.photoURL;
    late String? username = _auth.currentUser?.displayName;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 10,
        backgroundColor: Colors.deepPurpleAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                'ROOT',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Hero(
              tag: 'profile',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  image!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
