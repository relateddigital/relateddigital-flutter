import 'package:flutter/material.dart';
import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/rd_banner_view.dart';
import 'package:relateddigital_flutter_example/constants.dart';
import 'package:relateddigital_flutter_example/styles.dart';
import 'package:relateddigital_flutter_example/widgets/text_input_list_tile.dart';

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
              title: const Text('Banner'),
              backgroundColor: Styles.relatedPurple,
              automaticallyImplyLeading: false,
            ),
            body: ListView(
              children: ListTile.divideTiles(context: context, tiles: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    child: RDBannerView(
                      key: null,
                      relatedDigitalPlugin: widget.relatedDigitalPlugin,
                      properties: {'key1': 'value1', 'key2': 'value2','OM.baris': 'baris'},
                      onItemClick: (Map<String, String> result) {
                        print("onItemClick client: $result");
                      },
                      onRequestResult: (Map<String, String> result) {
                        print("onRequestResult client: $result");
                      },
                    )
                ),
              ]).toList(),
            )));
  }
}
