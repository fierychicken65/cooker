import 'package:cooker/pages/login_confirm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  static const String id = 'welcome_page';
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'images/cook1.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  'COOKER',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .then(delay: 200.ms), // baseline=800ms.slide(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          showLoading = true;
                        });

                        final GoogleSignInAccount? googleUser =
                            await GoogleSignIn().signIn();

                        final GoogleSignInAuthentication? googleAuth =
                            await googleUser?.authentication;

                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth?.accessToken,
                          idToken: googleAuth?.idToken,
                        );
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        Navigator.pushNamed(context, ScreenPage.id);
                        setState(() {
                          showLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text('Login Succesful'),
                                margin: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        );
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Exception: $e')),
                        );
                        print(e);
                      }
                    },
                    height: 50,
                    minWidth: 5000,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'images/google_logo.png',
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
