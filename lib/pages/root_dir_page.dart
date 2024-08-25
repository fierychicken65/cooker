import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    final storage = FirebaseStorage.instance;

    Stream<ListResult> listFilesStream() async* {
      final storageRef = storage.ref();
      while (true) {
        yield await storageRef.listAll();
        await Future.delayed(Duration(seconds: 10)); // Poll every 10 seconds
      }
    }



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
          )),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Storage',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ),
          StreamBuilder<ListResult>(
            stream: listFilesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                return Center(child: Text('No files found'));
              } else {
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: snapshot.data!.items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white10),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/folder.png', height: 50),
                            Text(
                              snapshot.data!.items[index].name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: MaterialButton(
                onPressed: () {},
                color: Colors.deepPurple,
                elevation: 30,
                splashColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70),
                ),
                height: 70,
                minWidth: 90,
                child: Image.asset(
                  'images/upload.png',
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
