import 'package:flutter/material.dart';
import 'package:cooker/network/firebase_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  @override
  void initState() {
    super.initState();
    currentPath = widget.path;
    final User? user = auth.currentUser;
    uid = user!.uid;
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ListResult>(
      stream: listFilesStream('$uid/$currentPath'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            (snapshot.data!.items.isEmpty && snapshot.data!.prefixes.isEmpty)) {
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
              itemCount:
                  snapshot.data!.items.length + snapshot.data!.prefixes.length,
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      splashColor: Colors.blueGrey,
                      onPressed: () {
                        setState(() {
                          currentPath = '$currentPath${folder.name}/';
                          widget.onPathChanged(currentPath);
                        });
                        print(currentPath);
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
                  final file = snapshot
                      .data!.items[index - snapshot.data!.prefixes.length];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      splashColor: Colors.blueGrey,
                      onPressed: () {
                        print(currentPath);
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
    );
  }
}
