import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final FirebaseStorage _instance = FirebaseStorage.instance;

  static Future<String> getIcon() => _instance.ref('/icon.png').getDownloadURL();
}
