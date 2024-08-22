import 'package:flutter/material.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  static const String id = 'registration_screen';
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: TextField(
                onChanged: (value) {
                  email = value;
                },
                style: const TextStyle(color: Colors.black, fontSize: 20),
                cursorColor: Colors.red,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Enter Email',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                style: const TextStyle(color: Colors.black, fontSize: 20),
                cursorColor: Colors.red,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
            ),

            Hero(
              tag: 'reg',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                child: Material(
                  shadowColor: Colors.purpleAccent,
                  elevation: 10,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    height: 50,
                    minWidth: 5000,
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'REGISTER',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
