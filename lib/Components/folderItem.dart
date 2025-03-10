import 'package:flutter/material.dart';

class FolderItem extends StatefulWidget {
  final String filepath;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FolderItem({
    Key? key,
    required this.filepath,
    required this.name,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);


  @override
  _FolderItemState createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: widget.isSelected ? Colors.red : Colors.black,
        splashColor: Colors.blueGrey,
        onPressed: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/folder.png', height: 50),
            Text(
              widget.name,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
