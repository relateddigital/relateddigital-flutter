import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/response_models.dart';
import 'package:relateddigital_flutter_example/screens/event.dart';
import 'package:relateddigital_flutter_example/screens/inapp.dart';
import 'package:relateddigital_flutter_example/screens/push.dart';
import 'package:relateddigital_flutter_example/screens/story.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/screens/home.dart';
import 'constants.dart';

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
    controller = TabController(length: 4, vsync: this);
  }

  void _readNotificationCallback(dynamic result) async {
    print('_readNotificationCallback');
    print(result);
    showDialog(
        context: key.currentContext,
        builder: (context) => AlertDialog(
              title: Text("_readNotificationCallback"),
              content: Text(result.toString()),
            ));
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

  Widget inAppView() {
    return InApp(relatedDigitalPlugin: relatedDigitalPlugin);
  }

  Widget storyView() {
    return Story(relatedDigitalPlugin: relatedDigitalPlugin);
  }

  Widget tabBarView() {
    return WillPopScope(
        onWillPop: null,
        child: Scaffold(
          body: TabBarView(
            children: <Widget>[
              eventView(),
              pushView(),
              inAppView(),
              storyView(),
            ],
            controller: controller,
          ),
          bottomNavigationBar: bottomNavigationBar(),
        ));
  }

  Widget bottomNavigationBar() {
    return Material(
      // set the color of the bottom navigation bar
      color: Colors.grey[200],
      // set the tab bar as the child of bottom navigation bar
      child: TabBar(
        indicatorColor: Styles.relatedRed,
        labelColor: Colors.black,
        tabs: <Tab>[
          Tab(
            text: Constants.Event,
            icon: Icon(Icons.analytics, color: Styles.relatedOrange),
          ),
          Tab(
            text: Constants.Push,
            icon: Icon(Icons.messenger, color: Styles.relatedRed),
          ),
          Tab(
            text: Constants.InApp,
            icon: Icon(Icons.data_usage_sharp, color: Styles.relatedPurple),
          ),
          Tab(
            text: Constants.Story,
            icon: Icon(Icons.mobile_screen_share, color: Styles.relatedBlue),
          ),
        ],
        // setup the controller
        controller: controller,
      ),
    );
  }
}
