import 'dart:io';

import 'package:relateddigital_flutter/relateddigital_flutter.dart';
import 'package:relateddigital_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RDStoryView extends StatefulWidget {
  final String actionId;
  final Function(Map<String, String> result) onItemClick;
  final RelateddigitalFlutter relatedDigitalPlugin;

  RDStoryView({this.actionId, this.onItemClick, this.relatedDigitalPlugin});

  @override
  _RDStoryViewState createState() => _RDStoryViewState();
}

class _RDStoryViewState extends State<RDStoryView> {
  StoryPlatformCallbackHandler _platformCallbackHandler;

  @override
  void initState() {
    super.initState();
    _platformCallbackHandler = StoryPlatformCallbackHandler(widget);
  }

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    final String viewType = Constants.STORY_VIEW_NAME;
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
          if (widget.relatedDigitalPlugin != null) {
            widget.relatedDigitalPlugin
                .setStoryPlatformHandler(_platformCallbackHandler);
          }
        },
      );
    }

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int id) {
        if (widget.relatedDigitalPlugin != null) {
          widget.relatedDigitalPlugin
              .setStoryPlatformHandler(_platformCallbackHandler);
        }
      },
    );

    // return PlatformViewLink(
    //   viewType: viewType,
    //   surfaceFactory:
    //       (BuildContext context, PlatformViewController controller) {
    //     return AndroidViewSurface(
    //       controller: controller,
    //       gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
    //       hitTestBehavior: PlatformViewHitTestBehavior.opaque,
    //     );
    //   },
    //   onCreatePlatformView: (PlatformViewCreationParams params) {
    //     return PlatformViewsService.initSurfaceAndroidView(
    //       id: params.id,
    //       viewType: viewType,
    //       layoutDirection: TextDirection.ltr,
    //       creationParams: creationParams,
    //       creationParamsCodec: StandardMessageCodec(),
    //     )
    //       ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
    //       ..addOnPlatformViewCreatedListener((int id) {
    //         if(widget.onViewCreated != null) {
    //           widget.onViewCreated();
    //         }
    //       })
    //       ..create();
    //   },
    // );
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
    if (storyView.onItemClick != null) {
      storyView.onItemClick(result);
    }
  }
}
