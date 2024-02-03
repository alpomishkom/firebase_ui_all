import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../service/service.dart';

class FileView extends StatefulWidget {
  const FileView({super.key});

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  bool isLoading = true;

  static Future<File> getFile() async {
    File file = File("");

    FilePickerResult? pickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      "zip",
      "mp3",
      "jpg",
      'mp3',
      'm4a',
    ]);
    if (pickerResult != null) {
      file = File(pickerResult.files.single.path!);
    }
    return file;
  }

  Future<void> uploadFile() async {
    FileService.uploud(
      FileService.path,
      await getFile(),
    );
  }

  List<String> list = [];

  Future<List<String>> get() async {
    list = await FileService.GET(FileService.path);
    setState(() {});
    isLoading = false;
    setState(() {});
    return list;
  }

  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  Map<String, Color> color = {
    "deepOrangeAccent": Colors.deepOrangeAccent,
    "brown": Colors.brown,
    "purpleAccent": Colors.purpleAccent,
    "grey": Colors.grey,
    "pink": Colors.pink,
    "orange": Colors.orange,
  };

  var backgroundColor = "";

  Future<void> init() async {
    await remoteConfig.setDefaults({'background_Colors': backgroundColor});
    await fetch();
    remoteConfig.onConfigUpdated.listen((event) async {
      await fetch();
    });
    setState(() {});
  }

  Future<void> fetch() async {
    await remoteConfig.fetchAndActivate().then((value) {
      backgroundColor = remoteConfig.getString("background_Colors");
      setState(() {});
    });
  }

  @override
  void initState() {
    init();
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color[backgroundColor],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: color[backgroundColor],
        onPressed: () async {
          await uploadFile();
          await get();
        },
        child: Icon(CupertinoIcons.camera),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    title: Text(list[index].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.save_alt,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await FileService.DELET(list[index].toString());
                            await get();
                          },
                          icon: Icon(
                            CupertinoIcons.delete,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
