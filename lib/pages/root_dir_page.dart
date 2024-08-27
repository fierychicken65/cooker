import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class RootDirPage extends StatefulWidget {
  const RootDirPage({super.key});
  static String id = 'root_dir_screen';
  @override
  State<RootDirPage> createState() => _RootDirPageState();
}

class _RootDirPageState extends State<RootDirPage> {
  String current_path = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    late String? image = _auth.currentUser?.photoURL;
    final storage = FirebaseStorage.instance;
    final User? user = _auth.currentUser;
    final String? username = user!.displayName;
    int _selectedIndex = 0;
    final String uid = user.uid;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;

        if (_selectedIndex == 1) {
          current_path = '';
        } else if (_selectedIndex == 0) {
          if (current_path.isNotEmpty) {
            List<String> pathSegments = current_path.split('/');
            print(pathSegments);
            if (pathSegments.isNotEmpty) {
              if (pathSegments.last.isEmpty) {
                pathSegments.removeLast();
              }
              pathSegments.removeLast();
              current_path = pathSegments.join('/');
            }
          } else if (_selectedIndex == 2) {}
        }
      });
    }

    Stream<ListResult> listFilesStream(String path) async* {
      final storageRef = storage.ref().child(path);
      while (true) {
        yield await storageRef.listAll();
        await Future.delayed(Duration(seconds: 10)); // Poll every 10 seconds
      }
    }

    Future<void> _pickAndUploadFile() async {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = file.path.split('/').last;
        // Create a reference to the location you want to upload to in Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('$uid/$current_path/$fileName');

        // Upload the file
        try {
          await storageRef.putFile(file);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('File uploaded successfully')));
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to upload file: $e')));
        }
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No file selected')));
      }
    }

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 10,
          toolbarHeight: 70,
          backgroundColor: Colors.black54,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                position: PopupMenuPosition.under,
                enableFeedback: true,
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onSelected: (int result) {
                  if (result == 0) {
                    // Action for first menu item
                  } else if (result == 1) {
                    // Action for second menu item
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Sign Out'),
                  ),
                ],
                child: Hero(
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
                ),
              ),
              Center(
                child: Text(
                  '$username',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ],
          )),
      backgroundColor: Colors.cyan,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Storage\n$username/$current_path',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            StreamBuilder<ListResult>(
              stream: listFilesStream('$uid/$current_path'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                  return Center(
                      child: Text(
                    'No files found',
                    style: TextStyle(color: Colors.white),
                  ));
                } else {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: snapshot.data!.items.length + snapshot.data!.prefixes.length,
                      itemBuilder: (context, index) {
                        if (index < snapshot.data!.prefixes.length) {
                          // Display folder
                          final folder = snapshot.data!.prefixes[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white10),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              splashColor: Colors.blueGrey,
                              onPressed: () {
                                setState(() {
                                  current_path = '${current_path}${folder.name}/';
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('images/folder.png', height: 50),
                                  Text(
                                    folder.name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Display file
                          final file = snapshot.data!.items[index - snapshot.data!.prefixes.length];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white10),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              splashColor: Colors.blueGrey,
                              onPressed: () {
                                // Handle file click
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('images/cook1.png', height: 50),
                                  Text(
                                    file.name,
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
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
                  onPressed: _pickAndUploadFile,
                  color: Colors.green,
                  elevation: 20,
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
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [
          Icons.arrow_back,
          Icons.home,
          Icons.create_new_folder,
        ],
        activeIndex: _selectedIndex,
        onTap: _onItemTapped,
        gapLocation: GapLocation.none,
        leftCornerRadius: 30,
        rightCornerRadius: 30,
        elevation: 10,
        height: 60,
        activeColor: Colors.black,
        inactiveColor: Colors.black,
        backgroundColor: Colors.transparent,
        splashRadius: 10,
        borderColor: Colors.green,
      ),
    );
  }
}
