import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'relateddigital_flutter.dart';
import 'constants.dart';

class RDBannerView extends StatefulWidget {
  /// Android native default when the panel does not send a height.
  static const double fallbackHeight = 110;

  /// Android native sentinel: treat as match-parent / full width.
  static const double _fullWidthSentinel = 600;

  final Function(Map<String, String> result) onItemClick;
  final Function(Map<String, String> result) onRequestResult;
  final RelateddigitalFlutter relatedDigitalPlugin;
  final Map<String, String> properties;

  /// `null` = native height geldikten sonra otomatik boyutlan.
  final double? height;

  /// `null` = native width geldikten sonra otomatik boyutlan (600/0 = tam genişlik).
  final double? width;

  const RDBannerView({
    required super.key,
    required this.onItemClick,
    required this.onRequestResult,
    required this.relatedDigitalPlugin,
    this.properties = const {},
    this.height,
    this.width,
  });

  @override
  RDBannerViewState createState() => RDBannerViewState();
}

class RDBannerViewState extends State<RDBannerView> {
  late BannerPlatformCallbackHandler _platformCallbackHandler;
  double? _autoHeight;
  double? _autoWidth;

  double get _resolvedHeight =>
      widget.height ?? _autoHeight ?? RDBannerView.fallbackHeight;

  double get _resolvedWidth =>
      widget.width ?? _autoWidth ?? double.infinity;

  @override
  void initState() {
    super.initState();
    _platformCallbackHandler = BannerPlatformCallbackHandler(widget);
    _platformCallbackHandler.onSize = _onNativeSize;
  }

  @override
  void didUpdateWidget(RDBannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _platformCallbackHandler.bannerView = widget;
    if (!mapEquals(oldWidget.properties, widget.properties)) {
      _autoHeight = null;
      _autoWidth = null;
    }
  }

  void _onNativeSize(double? height, double? width) {
    if (!mounted) {
      return;
    }

    double? nextHeight = _autoHeight;
    double? nextWidth = _autoWidth;

    if (widget.height == null &&
        height != null &&
        height > 0 &&
        height != _autoHeight) {
      nextHeight = height;
    }

    if (widget.width == null &&
        width != null &&
        width > 0 &&
        width != RDBannerView._fullWidthSentinel &&
        width != _autoWidth) {
      nextWidth = width;
    }

    if (nextHeight == _autoHeight && nextWidth == _autoWidth) {
      return;
    }

    setState(() {
      _autoHeight = nextHeight;
      _autoWidth = nextWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = Constants.BANNER_VIEW_NAME;
    final Map<String, dynamic> creationParams = widget.properties;

    final Widget platformView = Platform.isIOS
        ? UiKitView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (int id) {
              widget.relatedDigitalPlugin
                  .setBannerPlatformHandler(_platformCallbackHandler);
            },
          )
        : AndroidView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (int id) {
              widget.relatedDigitalPlugin
                  .setBannerPlatformHandler(_platformCallbackHandler);
            },
          );

    return SizedBox(
      width: _resolvedWidth,
      height: _resolvedHeight,
      child: platformView,
    );
  }
}

abstract class BannerCallbackHandler {
  void onRequestResult(Map<String, String> result);
  void onItemClick(Map<String, String> result);
}

class BannerPlatformCallbackHandler implements BannerCallbackHandler {
  RDBannerView bannerView;
  void Function(double? height, double? width)? onSize;

  BannerPlatformCallbackHandler(this.bannerView);

  @override
  void onRequestResult(Map<String, String> result) {
    onSize?.call(
      double.tryParse(result['height'] ?? ''),
      double.tryParse(result['width'] ?? ''),
    );
    bannerView.onRequestResult(result);
  }

  @override
  void onItemClick(Map<String, String> result) {
    bannerView.onItemClick(result);
  }
}
