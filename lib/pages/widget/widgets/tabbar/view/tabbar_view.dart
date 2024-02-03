import 'package:birabase_ui/pages/home/view/home_view.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../../../../file/view/file_view.dart';

class TappBarView extends StatefulWidget {
  const TappBarView({super.key});

  @override
  State<TappBarView> createState() => _TappBarViewState();
}

class _TappBarViewState extends State<TappBarView>
    with TickerProviderStateMixin {
  late TabController tabController;

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
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color[backgroundColor],
        bottom: TabBar(
          tabs: [
            Tab(
              text: "NOT",
            ),
            Tab(
              text: "FILE",
            ),
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          HomeView(),
          FileView()
        ],
      ),
    );
  }
}
