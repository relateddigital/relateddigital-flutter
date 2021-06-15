import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';

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
              backgroundColor: Styles.borders,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                TextInputListTile(
                  title: Constants.appAlias,
                  controller: tController, onSubmitted: null,),
                ListTile(
                  subtitle: Column(
                    children: <Widget>[
                      TextButton(
                          child: Text('INITIALIZE'),
                          style: Styles.buttonStyle,
                          onPressed: () {
                            //submit();
                          })
                    ],
                  ),
                )
              ]).toList(),
            )));
  }
}
