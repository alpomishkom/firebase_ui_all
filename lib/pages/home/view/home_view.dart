import 'package:birabase_ui/pages/home/model/model.dart';
import 'package:birabase_ui/pages/home/service/service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;

  final remoteConfig = FirebaseRemoteConfig.instance;
  Map<String, Color> color = {
    "red": Colors.red,
    "yellow": Colors.yellow,
    "black": Colors.black,
    "grey": Colors.grey,
    "blue": Colors.blue,
  };
  var backgroundColor = "";

  Future<void> init() async {
    remoteConfig.setDefaults({"background_Color": backgroundColor});
    await fetch();
    remoteConfig.onConfigUpdated.listen((event) async {
      await fetch();
    });
    setState(() {});
  }

  Future<void> fetch() async {
    await remoteConfig.fetchAndActivate().then((value) {
      backgroundColor = remoteConfig.getString("background_Color");
      setState(() {});
    });
  }


  Future<void> cread(Not data) async {
    NotService.creade(NotService.path, data.toJson());
  }

  List<DataSnapshot> list = [];

  Future<void> getAll() async {
    list = await NotService.GET(NotService.path);
    isLoading = false;
    setState(() {});
  }


  @override
  void initState() {
    init();
    getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color[backgroundColor],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: NotService.title,
                      decoration: InputDecoration(
                        hintText: "title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      controller: NotService.decription,
                      decoration: InputDecoration(
                        hintText: "decription",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("CLOUS")),
                  TextButton(
                    onPressed: () async {
                      var title = NotService.title.text;
                      var decription = NotService.title.text;
                      if (title.isNotEmpty && decription.isNotEmpty) {
                        cread(
                          Not(
                            title: title,
                            decription: decription,
                            dataTime: DateTime.now().toIso8601String(),
                          ),
                        );
                        Navigator.pop(context);
                        await getAll();
                      }
                      NotService.title.clear();
                      NotService.decription.clear();
                    },
                    child: Text("SAVE"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        scrollControlDisabledMaxHeightRatio: 0.1,
                        context: context,
                        builder: (context) {
                          var data = DateTime.now().toIso8601String();
                          return Column(
                            children: [Text(data), Divider()],
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text((list[index].value as Map)['title']),
                        subtitle:
                            Text((list[index].value as Map)['decription']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: NotService.title,
                                            decoration: InputDecoration(
                                              hintText: "title",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          TextFormField(
                                            controller: NotService.decription,
                                            decoration: InputDecoration(
                                              hintText: "decription",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("CLOUS"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            var title = NotService.title.text;
                                            var decription =
                                                NotService.title.text;
                                            if (title.isNotEmpty &&
                                                decription.isNotEmpty) {
                                              var data = Not(
                                                  title: title,
                                                  decription: decription,
                                                  dataTime: DateTime.now()
                                                      .toIso8601String());
                                              NotService.PUT(
                                                  NotService.path,
                                                  list[index].key.toString(),
                                                  data.toJson());
                                              Navigator.pop(context);
                                              await getAll();
                                            }
                                            NotService.title.clear();
                                            NotService.decription.clear();
                                          },
                                          child: Text("SAVE"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.refresh_rounded),
                            ),
                            IconButton(
                              onPressed: () async {
                                await NotService.DELET(
                                  NotService.path,
                                  list[index].key.toString(),
                                );
                                await getAll();
                              },
                              icon: Icon(CupertinoIcons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
