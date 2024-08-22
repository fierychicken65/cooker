import 'package:cooker/pages/registration.dart';
import 'package:cooker/pages/login_confirm.dart';
import 'package:flutter/material.dart';
import 'package:cooker/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cooker/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomePage.id,
      routes: {
        WelcomePage.id : (context) => const WelcomePage(),
        ScreenPage.id : (context) => const ScreenPage(),
      },
    );
  }
}

