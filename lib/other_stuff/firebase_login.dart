import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
late String? image = _auth.currentUser?.photoURL;
final storage = FirebaseStorage.instance;
final User? user = _auth.currentUser;
final String? username = user!.displayName;
final String uid = user!.uid;
