import 'package:flutter/material.dart';
import 'package:cooker/network/firebase_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static String id = 'profile_page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    late String? image = auth.currentUser?.photoURL;
    final User? user = auth.currentUser;
    final String? username = user!.displayName;

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
                      Hero(
                        tag: 'profile',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              60), // Set the desired border radius here
                          child: Image.network(
                            image!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '$username',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
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
          ],
        ),
      ),
    );
  }
}
