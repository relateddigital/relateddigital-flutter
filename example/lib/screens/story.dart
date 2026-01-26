import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/rd_story_view.dart';
import 'package:relateddigital_flutter_example/styles.dart';

class Story extends StatefulWidget {
  final RelateddigitalFlutter relatedDigitalPlugin;

  Story({required this.relatedDigitalPlugin});

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
  TextEditingController tController = TextEditingController();
  String actionId = '2139';

  @override
  void initState() {
    super.initState();
    tController.text = '2139';
  }

  @override
  void dispose() {
    tController.dispose();
    super.dispose();
  }

  void _showStory() {
    setState(() {
      actionId = tController.text;
    });
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
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Action ID',
                            hintText: 'Action ID giriniz',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _showStory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Styles.relatedBlue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Göster'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: RDStoryView(
                      key: ValueKey(actionId),
                      actionId: actionId,
                      relatedDigitalPlugin: widget.relatedDigitalPlugin,
                      onItemClick: (Map<String, String> result) {
                        print(result);
                      },
                    ),
                  ),
                ),
              ],
            )));
  }
}
