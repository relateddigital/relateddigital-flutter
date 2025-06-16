import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'relateddigital_flutter.dart';
import 'constants.dart';

class RDBannerView extends StatefulWidget {
  final Function(Map<String, String> result) onItemClick;
  final Function(Map<String, String> result) onRequestResult;
  final RelateddigitalFlutter relatedDigitalPlugin;
  final Map<String, String> properties;

  const RDBannerView({
    required super.key,
    required this.onItemClick,
    required this.onRequestResult,
    required this.relatedDigitalPlugin,
    this.properties = const {},
  });

  @override
  RDBannerViewState createState() => RDBannerViewState();
}

class RDBannerViewState extends State<RDBannerView> {
  late BannerPlatformCallbackHandler _platformCallbackHandler;

  @override
  void initState() {
    super.initState();
    _platformCallbackHandler = BannerPlatformCallbackHandler(widget);
  }

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = Constants.BANNER_VIEW_NAME;
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = widget.properties;

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          widget.relatedDigitalPlugin
              .setBannerPlatformHandler(_platformCallbackHandler);
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
            .setBannerPlatformHandler(_platformCallbackHandler);
      },
    );
  }
}

abstract class BannerCallbackHandler {
  void onRequestResult(Map<String, String> result);
  void onItemClick(Map<String, String> result);
}

class BannerPlatformCallbackHandler implements BannerCallbackHandler {
  RDBannerView bannerView;

  BannerPlatformCallbackHandler(this.bannerView);

  @override
  void onRequestResult(Map<String, String> result) {
    bannerView.onRequestResult(result);
  }

  @override
  void onItemClick(Map<String, String> result) {
    bannerView.onItemClick(result);
  }
}
