import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class NotService {
  static final rbd = FirebaseDatabase.instance.ref();
  static TextEditingController title = TextEditingController();
  static TextEditingController decription = TextEditingController();
  static const path = "NOT";


  static Future<void> creade(String path, Map<String, dynamic> data) async {
    String? key = await rbd.child(path).push().key;
    await rbd.child(path).child(key!).set(data);
  }

  static Future<List<DataSnapshot>> GET(String path) async {
    List<DataSnapshot> list = [];
    var paretPath = rbd.child(path);
    DatabaseEvent childPath = await paretPath.once();
    for (var e in childPath.snapshot.children) {
      list.add(e);
    }
    return list;
  }
  
  static Future<void> DELET(String path,String documetId) async {
    await rbd.child(path).child(documetId).remove();
  }

  static Future<void> PUT(String path,String documetId,Map<String,dynamic> data) async {
    await rbd.child(path).child(documetId).update(data);
  }
}
