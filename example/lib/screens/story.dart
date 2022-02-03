import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/rd_story_view.dart';
import 'package:relateddigital_flutter_example/styles.dart';

class Story extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  Story({@required this.relatedDigitalPlugin});

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
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
              backgroundColor: Styles.relatedBlue,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    child: RDStoryView(
                      actionId: '497',
                      relatedDigitalPlugin: widget.relatedDigitalPlugin,
                      onItemClick: (Map<String, String> result) {
                        print(result);
                      },
                    )),
              ]).toList(),
            )));
  }
}
