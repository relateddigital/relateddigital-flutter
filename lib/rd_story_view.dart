import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'relateddigital_flutter.dart';
import 'constants.dart';

class RDStoryView extends StatefulWidget {
  final String actionId;
  final Function(Map<String, String> result) onItemClick;
  final RelatedDigital relatedDigitalPlugin;

  const RDStoryView(
      {required super.key,
      required this.actionId,
      required this.onItemClick,
      required this.relatedDigitalPlugin});

  @override
  RDStoryViewState createState() => RDStoryViewState();
}

class RDStoryViewState extends State<RDStoryView> {
  late StoryPlatformCallbackHandler _platformCallbackHandler;

  @override
  void initState() {
    super.initState();
    _platformCallbackHandler = StoryPlatformCallbackHandler(widget);
  }

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = Constants.STORY_VIEW_NAME;
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'actionId': widget.actionId
    };

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget.relatedDigitalPlugin
              .setStoryPlatformHandler(_platformCallbackHandler);
        },
      );
    }

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int id) {
        widget.relatedDigitalPlugin
            .setStoryPlatformHandler(_platformCallbackHandler);
      },
    );
  }
}

abstract class StoryCallbackHandler {
  void onItemClick(Map<String, String> result);
}

class StoryPlatformCallbackHandler implements StoryCallbackHandler {
  RDStoryView storyView;

  StoryPlatformCallbackHandler(this.storyView);

  @override
  void onItemClick(Map<String, String> result) {
    storyView.onItemClick(result);
  }
}
