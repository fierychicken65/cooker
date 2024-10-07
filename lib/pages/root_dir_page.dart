import 'package:flutter/material.dart';
import 'package:cooker/Components/grid_builder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cooker/network/firebase_login.dart';
import 'dart:io';

int _selectedIndex = 0;

class RootDirPage extends StatefulWidget {
  const RootDirPage({super.key});
  static String id = 'root_dir_screen';
  @override
  State<RootDirPage> createState() => _RootDirPageState();
}

class _RootDirPageState extends State<RootDirPage> {
  String currentPath = '';
  late String uid;

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickAndUploadFile() async {
    // Pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last;
      // Create a reference to the location you want to upload to in Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('$uid/$currentPath/$fileName');

      // Upload the file
      try {
        await storageRef.putFile(file);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File uploaded successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload file: $e')));
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No file selected')));
    }
  }

  void _onPathChanged(String newPath) {
    setState(() {
      currentPath = newPath;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 1) {
        currentPath = '';
      } else if (_selectedIndex == 0) {
        if (currentPath.isNotEmpty) {
          List<String> pathSegments = currentPath.split('/');
          print(pathSegments);
          if (pathSegments.isNotEmpty) {
            if (pathSegments.last.isEmpty) {
              pathSegments.removeLast();
            }
            pathSegments.removeLast();
            currentPath = pathSegments.join('/');
            currentPath += '/';
            _onPathChanged(currentPath);
          }
        }
      } else if (_selectedIndex == 2) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('AlertDialog Title'),
            content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    late String? image = auth.currentUser?.photoURL;
    final User? user = auth.currentUser;
    final String? username = user!.displayName;

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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
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
                'Storage\n$username/$currentPath',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Gridview(
            path: currentPath,
            onPathChanged: _onPathChanged,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back_sharp), label: 'back'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.create_new_folder), label: 'create folder'),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
