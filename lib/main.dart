import 'package:cooker/pages/login_confirm.dart';
import 'package:cooker/pages/root_dir_page.dart';
import 'package:cooker/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cooker/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cooker/pages/profilePage.dart';
import 'package:cooker/pages/searchPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
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
        WelcomePage.id: (context) => const WelcomePage(),
        ScreenPage.id: (context) => const ScreenPage(),
        RootDirPage.id: (context) => const RootDirPage(),
        ProfilePage.id: (context) => const ProfilePage(),
        SearchPage.id: (context) => const SearchPage(),
      },
    );
  }
}
