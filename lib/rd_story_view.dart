import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'relateddigital_flutter.dart';
import 'constants.dart';

class RDStoryView extends StatefulWidget {
  static double get fallbackHeight => Platform.isAndroid ? 280 : 100;

  final String actionId;
  final Function(Map<String, String> result) onItemClick;
  final RelateddigitalFlutter relatedDigitalPlugin;
  /// `null` = native shape geldikten sonra otomatik boyutlan.
  final double? height;
  final Color? backgroundColor;

  const RDStoryView(
      {required super.key,
      required this.actionId,
      required this.onItemClick,
      required this.relatedDigitalPlugin,
      this.height,
      this.backgroundColor});

  @override
  RDStoryViewState createState() => RDStoryViewState();
}

class RDStoryViewState extends State<RDStoryView> {
  late StoryPlatformCallbackHandler _platformCallbackHandler;
  double? _autoHeight;

  static final Set<Factory<OneSequenceGestureRecognizer>> _gestureRecognizers =
      <Factory<OneSequenceGestureRecognizer>>{
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  double get _resolvedHeight =>
      widget.height ?? _autoHeight ?? RDStoryView.fallbackHeight;

  @override
  void initState() {
    super.initState();
    _platformCallbackHandler = StoryPlatformCallbackHandler(widget);
    _platformCallbackHandler.onHeight = _onNativeHeight;
  }

  @override
  void didUpdateWidget(RDStoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _platformCallbackHandler.storyView = widget;
    if (oldWidget.actionId != widget.actionId) {
      _autoHeight = null;
    }
  }

  void _onNativeHeight(double height) {
    if (widget.height != null || !mounted) {
      return;
    }
    if (_autoHeight == height) {
      return;
    }
    setState(() {
      _autoHeight = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = Constants.STORY_VIEW_NAME;
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'actionId': widget.actionId,
      if (widget.backgroundColor != null)
        'backgroundColor': widget.backgroundColor!.value,
    };

    final Widget platformView = Platform.isIOS
        ? UiKitView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            gestureRecognizers: _gestureRecognizers,
            onPlatformViewCreated: (int id) {
              widget.relatedDigitalPlugin
                  .setStoryPlatformHandler(_platformCallbackHandler);
            },
          )
        : AndroidView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            gestureRecognizers: _gestureRecognizers,
            onPlatformViewCreated: (int id) {
              widget.relatedDigitalPlugin
                  .setStoryPlatformHandler(_platformCallbackHandler);
            },
          );

    return SizedBox(
      width: double.infinity,
      height: _resolvedHeight,
      child: platformView,
    );
  }
}

abstract class StoryCallbackHandler {
  void onItemClick(Map<String, String> result);
  void onRequestResult(Map<String, String> result);
}

class StoryPlatformCallbackHandler implements StoryCallbackHandler {
  RDStoryView storyView;
  void Function(double height)? onHeight;

  StoryPlatformCallbackHandler(this.storyView);

  @override
  void onItemClick(Map<String, String> result) {
    storyView.onItemClick(result);
  }

  @override
  void onRequestResult(Map<String, String> result) {
    final parsed = double.tryParse(result['height'] ?? '');
    if (parsed != null && parsed > 0) {
      onHeight?.call(parsed);
    }
  }
}
