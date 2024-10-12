import 'package:flutter/material.dart';
import 'package:cooker/Components/grid_builder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cooker/network/firebase_login.dart';
import 'dart:io';
import 'dart:typed_data';

int _selectedIndex = 0;
ValueNotifier<bool> appBarNotify = ValueNotifier<bool>(true);
List<String> deleteList = [];
ValueNotifier<int> deleteCountNotifier = ValueNotifier<int>(0);

class RootDirPage extends StatefulWidget {
  const RootDirPage({super.key});
  static String id = 'root_dir_screen';
  @override
  State<RootDirPage> createState() => _RootDirPageState();
}

class _RootDirPageState extends State<RootDirPage> {
  String currentPath = '';
  late String uid;
  late TextEditingController _folderNameController;
  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid;
    _folderNameController = TextEditingController();
  }

  @override
  void dispose() {
    _folderNameController = TextEditingController();
    deleteList.clear();
    deleteCountNotifier.value = deleteList.length;
    appBarNotify.value = true;
    super.dispose();
  }

  Future<void> _pickAndUploadFile() async {
    // Pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last;
      // Create a reference to the location you want to upload to in Firebase Storage
      final storageRef = storage.ref().child('$uid/$currentPath/$fileName');

      // Upload the file
      try {
        await storageRef.putFile(file);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('File uploaded successfully'))));
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text('Failed to upload file: $e'))));
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text('No file selected'))));
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
            title: const Center(child: Text('Create Folder')),
            content: TextField(
              controller: _folderNameController,
              keyboardType: TextInputType.text,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _folderNameController.clear();
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String folderName = _folderNameController.text;
                      if (folderName.isNotEmpty) {
                        try {
                          // Create a reference to the new folder in Firebase Storage
                          final folderRef = storage
                              .ref()
                              .child('$uid/$currentPath/$folderName/');

                          // Create the folder by uploading an empty file
                          await folderRef
                              .child('delete this')
                              .putData(Uint8List(0));
                          setState(() {
                            currentPath = currentPath;
                          });
                          // Notify the user about the successful folder creation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Center(
                                  child: Text('Folder created successfully')),
                            ),
                          );

                          // Clear the text field
                          _folderNameController.clear();
                        } catch (e) {
                          // Notify the user about the failure
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to create folder: $e')),
                          );
                        }
                      } else {
                        // Notify the user to enter a folder name
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a folder name')),
                        );
                      }
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> _deleteItems(List<String> deleteList) async {
    for (String item in deleteList) {
      try {
        final ref = storage.ref().child(item);
        final listResult = await ref.listAll();
        final emptyCheck = await ref.listAll();
        if (emptyCheck.items.isEmpty && emptyCheck.prefixes.isEmpty) {
          await ref.delete();
        }
        // Delete all files in the folder
        for (var fileRef in listResult.items) {
          await fileRef.delete();
        }

        // Recursively delete all subfolders
        for (var folderRef in listResult.prefixes) {
          await _deleteItems([folderRef.fullPath]);
        }

        // Finally, delete the folder itself if it is empty
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text('Failed to delete: $e'))),
        );
      }
    }
    setState(() {
      deleteList.clear();
      deleteCountNotifier.value = deleteList.length;
      appBarNotify.value = true;
    });
  }

  AppBar buildAppBar() {
    late String? image = auth.currentUser?.photoURL;
    final User? user = auth.currentUser;
    final String? username = user!.displayName;

    return AppBar(
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              style:
                  TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  AppBar delAppBar() {
    late String? image = auth.currentUser?.photoURL;
    final User? user = auth.currentUser;
    final String? username = user!.displayName;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 10,
      toolbarHeight: 70,
      backgroundColor: Colors.red,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MaterialButton(
            onPressed: () {
              setState(() {
                appBarNotify.value = !appBarNotify.value;
                deleteList = [];
                deleteCountNotifier.value = deleteList.length;
                print(deleteList);
              });
            },
            child: const Icon(Icons.cancel),
          ),
          ValueListenableBuilder<int>(
            valueListenable: deleteCountNotifier,
            builder: (context, count, child) {
              return Text('$count Selected');
            },
          ),
          MaterialButton(
            onPressed: () {
              _deleteItems(deleteList);
              appBarNotify.value = !appBarNotify.value;
              deleteList = [];
              deleteCountNotifier.value = deleteList.length;
              print(deleteList);
            },
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final String? username = user!.displayName;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Set the height of the AppBar
        child: ValueListenableBuilder<bool>(
          valueListenable: appBarNotify,
          builder: (context, appBar, child) {
            return appBar ? buildAppBar() : delAppBar();
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
        Column(
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
          ],
        ),
        Positioned(
          bottom: 40,
          right: 30,
          child: MaterialButton(
            onPressed: _pickAndUploadFile,
            onLongPress: () {},
            color: Colors.redAccent,
            elevation: 20,
            splashColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70),
            ),
            height: 50,
            minWidth: 50,
            child: Image.asset(
              'images/upload.png',
              height: 40,
            ),
          ),
        ),
      ]),
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
