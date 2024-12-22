import 'package:cooker/pages/file_summary.dart';
import 'package:cooker/pages/root_dir_page.dart';
import 'package:flutter/material.dart';
import 'package:cooker/network/firebase_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cooker/Components/folderItem.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_icon/file_icon.dart';

Stream<ListResult> listFilesStream(String path) async* {
  final storageRef = storage.ref().child(path);
  while (true) {
    yield await storageRef.listAll();
    await Future.delayed(Duration(seconds: 10)); // Poll every 10 seconds
  }
}

class Gridview extends StatefulWidget {
  final String path;
  final ValueChanged<String> onPathChanged;

  const Gridview({super.key, required this.path, required this.onPathChanged});

  @override
  State<Gridview> createState() => _GridviewState();
}

class _GridviewState extends State<Gridview> {
  late String currentPath;
  late String uid;
  late bool initialLoad;

  @override
  void initState() {
    super.initState();
    currentPath = widget.path;
    final User? user = auth.currentUser;
    uid = user!.uid;
    initialLoad = false;
  }

  @override
  //Using this function to update currentPath in root_dir_page and Grid_builder
  //We are making sure the value of currentPath is in sync in both directories
  void didUpdateWidget(covariant Gridview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.path != oldWidget.path) {
      setState(() {
        currentPath = widget.path;
      });
    }
  }

  void _updateDeleteList(String filepath) {
    if (deleteList.contains(filepath)) {
      deleteList.remove(filepath);
      deleteCountNotifier.value = deleteList.length;
    } else {
      deleteList.add(filepath);
      deleteCountNotifier.value = deleteList.length;
    }
    if (deleteCountNotifier.value == 0) {
      appBarNotify.value = !appBarNotify.value;
    }
  }

  Color bgFolderColor(filepath) {
    return deleteList.contains(filepath) ? Colors.red : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ListResult>(
      stream: listFilesStream('$uid/$currentPath'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !initialLoad) {
          initialLoad = true;
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            (snapshot.data!.items.isEmpty && snapshot.data!.prefixes.isEmpty)) {
          return const Center(
              child: Text(
            'No files found',
            style: TextStyle(color: Colors.white),
          ));
        } else {
          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount:
                  snapshot.data!.items.length + snapshot.data!.prefixes.length,
              itemBuilder: (context, index) {
                if (index < snapshot.data!.prefixes.length) {
                  // Display folder
                  final folder = snapshot.data!.prefixes[index];
                  return FolderItem(
                    filepath: folder.fullPath,
                    name: folder.name,
                    isSelected: deleteList.contains(folder.fullPath),
                    onTap: () {
                      String filepath = folder.fullPath;
                      if (!appBarNotify.value) {
                        setState(() {
                          _updateDeleteList(filepath);
                        });
                        print(deleteList);
                      } else {
                        setState(() {
                          initialLoad = false;
                          currentPath = '$currentPath${folder.name}/';
                          widget.onPathChanged(currentPath);
                        });
                      }
                    },
                    onLongPress: () {
                      String filepath = folder.fullPath;
                      if (appBarNotify.value) {
                        setState(() {
                          _updateDeleteList(filepath);
                          appBarNotify.value = !appBarNotify.value;
                        });
                      }
                      print(deleteList);
                    },
                  );
                } else {
                  // Display file
                  final file = snapshot
                      .data!.items[index - snapshot.data!.prefixes.length];
                  return (file.name != 'delete this')
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white10),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            splashColor: Colors.blueGrey,
                            color: bgFolderColor(file.fullPath),
                            onPressed: () {
                              String filepath = file.fullPath;
                              if (!appBarNotify.value) {
                                setState(() {
                                  _updateDeleteList(filepath);
                                });
                                return;

                              }
                              Navigator.pushNamed(context, FileSummary.id, arguments: {'path':file.fullPath});
                              print(file.fullPath);
                            },
                            onLongPress: () {
                              String filepath = file.fullPath;
                              if (appBarNotify.value) {
                                setState(() {
                                  _updateDeleteList(filepath);
                                  appBarNotify.value = !appBarNotify.value;
                                });
                              }
                              print(deleteList);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FileIcon(
                                  '.${file.name.split('.').last}',
                                  size: 50,
                                ),
                                Text(
                                  file.name,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        )
                      : null;
                }
              },
            ),
          );
        }
      },
    );
  }
}
