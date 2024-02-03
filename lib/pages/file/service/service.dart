import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileService {
  static final FirebaseStorage storage = FirebaseStorage.instance;
  static const String path = 'FILE';

  static Future<String> uploud(String path, File file) async {
    Reference images = storage.ref(path).child("${DateTime.now().toIso8601String()}${file.path.substring(file.path.lastIndexOf('.'))}");
    UploadTask task = images.putFile(file);
    await task.whenComplete(() {});
    return task.toString();
  }

  static Future<List<String>> GET(String path)async {
    ListResult items = await storage.ref(path).listAll();
    List<String> list = [];
    for (var e in items.items)  {
      list.add(await e.getDownloadURL());
    }
    return list;
  }
  static Future<Reference> DELET(String path) async {
   Reference res =  await storage.refFromURL(path);
   res.delete();
   return res;
  }
}
