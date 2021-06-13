import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/screens/home.dart';

import 'package:flutter/services.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter/request_models.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:relateddigital_flutter/recommendation_filter.dart';
import 'package:relateddigital_flutter/rd_story_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RDExample());
}



class RDExample extends StatefulWidget {
  @override
  _RDExample createState() => _RDExample();
}

class _RDExample extends State<RDExample> with SingleTickerProviderStateMixin {
  TabController controller;
  final GlobalKey<NavigatorState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    //initPlatformState();
    //addFlutterTag();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey:key,
      title: "RDExample",
      initialRoute: "/home",
      routes: {
        '/home': (context) => homeView(),
        '/': (context) => tabBarView(),
      },
    );
  }

  Widget homeView() {
    return Home();
  }

  Widget tabBarView() {
    return WillPopScope(
        onWillPop: null,
        child: Scaffold(
          body: TabBarView(
            children: <Widget>[],
            controller: controller,
          ),
          bottomNavigationBar: bottomNavigationBar(),
        ));
  }

  Widget bottomNavigationBar() {
    return Material(
      // set the color of the bottom navigation bar
      color: Styles.borders,
      // set the tab bar as the child of bottom navigation bar
      child: TabBar(
        indicatorColor: Styles.airshipRed,
        tabs: <Tab>[
          Tab(
            // set icon to the tab
            icon: Icon(Icons.home),
          ),
          Tab(
            icon: Icon(Icons.inbox),
          ),
          Tab(
            icon: Icon(Icons.settings),
          ),
        ],
        // setup the controller
        controller: controller,
      ),
    );
  }

}