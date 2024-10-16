import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final storage = FirebaseStorage.instance;
final model =
    FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
