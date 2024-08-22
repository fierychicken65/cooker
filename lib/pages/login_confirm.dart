import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});
  static const String id = 'screen_page';

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String? image = _auth.currentUser?.photoURL;
  late String? username = _auth.currentUser?.displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (image != null)
                ? Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(60), // Set the desired border radius here
                        child: Image.network(
                          image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          username!,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                : Container(
                    child: const Text('No image available'),
                  ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Confirm this is your account',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: MaterialButton(
                child: Text('CONTINUE'),
                color: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 40),
                onPressed: () {
                  print(_auth.currentUser?.photoURL);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: MaterialButton(
                child: Text('SIGN OUT'),
                color: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 40),
                onPressed: () async {
                  await _auth.signOut();
                  await GoogleSignIn().signOut();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text('Signed Out'),
                          margin: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
