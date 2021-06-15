import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/screens/event.dart';
import 'package:relateddigital_flutter_example/screens/push.dart';
import 'package:relateddigital_flutter_example/screens/story.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RDExample());
}

class RDExample extends StatefulWidget {
  @override
  _RDExample createState() => _RDExample();
}

class _RDExample extends State<RDExample> with SingleTickerProviderStateMixin {
  final RelateddigitalFlutter relatedDigitalPlugin = RelateddigitalFlutter();
  TabController controller;
  final GlobalKey<NavigatorState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  void _readNotificationCallback(dynamic result) {
    print('_readNotificationCallback');
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: key,
      title: "RDExample",
      initialRoute: "/home",
      routes: {
        '/home': (context) => homeView(),
        '/tabBarView': (context) => tabBarView(),
      },
    );
  }

  Widget homeView() {
    return Home(
      relatedDigitalPlugin: relatedDigitalPlugin,
      notificationHandler: _readNotificationCallback,
    );
  }

  Widget eventView() {
    return Event(relatedDigitalPlugin: relatedDigitalPlugin);
  }

  Widget pushView() {
    return Push(relatedDigitalPlugin: relatedDigitalPlugin);
  }

  Widget storyView() {
    return Story(relatedDigitalPlugin: relatedDigitalPlugin);
  }

  Widget tabBarView() {
    return WillPopScope(
        onWillPop: null,
        child: Scaffold(
          body: TabBarView(
            children: <Widget>[eventView(), pushView(), storyView()],
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
        indicatorColor: Styles.relatedRed,
        tabs: <Tab>[
          Tab(
            // set icon to the tab
            icon: Icon(Icons.analytics),
          ),
          Tab(
            icon: Icon(Icons.messenger),
          ),
          Tab(
            icon: Icon(Icons.data_usage_sharp),
          ),
        ],
        // setup the controller
        controller: controller,
      ),
    );
  }
}
