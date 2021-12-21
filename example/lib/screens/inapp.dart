import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/rd_story_view.dart';
import 'package:relateddigital_flutter_example/styles.dart';

class InApp extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  InApp({required this.relatedDigitalPlugin});

  @override
  _InAppState createState() => _InAppState();
}

class _InAppState extends State<InApp> {
  TextEditingController tController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Story'),
              backgroundColor: Styles.relatedPurple,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    child: RDStoryView(
                      actionId: '454',
                      relatedDigitalPlugin: widget.relatedDigitalPlugin,
                      onItemClick: (Map<String, String?> result) {
                        print(result);
                      },
                    )),
              ]).toList(),
            )));
  }
}
