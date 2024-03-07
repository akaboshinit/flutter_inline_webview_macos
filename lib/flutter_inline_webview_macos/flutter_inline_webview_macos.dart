import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/flutter_inline_webview_macos_controller.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/types.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/webview.dart';

class InlineWebViewMacOs extends StatefulWidget implements WebView {
  const InlineWebViewMacOs({
    Key? key,
    required this.width,
    required this.height,
    this.controller,
    this.windowId,
    this.onWebViewCreated,
    this.initialUrlRequest,
    this.onLoadStart,
    this.onLoadStop,
    this.onLoadError,
    this.onLoadHttpError,
    this.gestureRecognizers,
    this.onDispose,
  }) : super(key: key);

  @override
  final URLRequest? initialUrlRequest;

  @override
  final void Function(InlineWebViewMacOsController? controller)?
      onWebViewCreated;

  @override
  final void Function(InlineWebViewMacOsController? controller, Uri? url)?
      onLoadStart;
  @override
  final void Function(InlineWebViewMacOsController? controller, Uri? url)?
      onLoadStop;

  @override
  final void Function()? onDispose;

  @override
  final void Function(
    InlineWebViewMacOsController? controller,
    Uri? url,
    int code,
    String message,
  )? onLoadError;

  @override
  final void Function(
    InlineWebViewMacOsController? controller,
    Uri? url,
    int statusCode,
    String description,
  )? onLoadHttpError;

  ///The window id of a [CreateWindowAction.windowId].
  @override
  final int? windowId;
  final double width;
  final double height;
  final InlineWebViewMacOsController? controller;

  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  @override
  InlineWebViewMacOsState createState() => InlineWebViewMacOsState();
}

class InlineWebViewMacOsState extends State<InlineWebViewMacOs> {
  late InlineWebViewMacOsController _controller;
  final GlobalKey _key = GlobalKey();
  Size? _size;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // size change listen
      if (_size != null && _key.currentContext?.size != _size) {
        _controller.changeSize(_size!);
        _size = _key.currentContext?.size;
      }
    });

    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: AppKitView(
          key: _key,
          viewType: 'dev.akaboshinit/flutter_inline_webview_macos',
          onPlatformViewCreated: _onPlatformViewCreated,
          gestureRecognizers: widget.gestureRecognizers,
          creationParams: <String, dynamic>{
            'args': 'test',
            'initialUrlRequest': widget.initialUrlRequest?.toMap(),
            'windowId': widget.windowId,
          },
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }

    return Text(
      '$defaultTargetPlatform is not yet supported by the flutter_webview_macos plugin',
    );
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    _controller.dispose();
    super.dispose();
  }

  void _onPlatformViewCreated(int id) {
    _size = _key.currentContext?.size ?? const Size(0, 0);
    _controller =
        InlineWebViewMacOsController(id: id, webView: widget, size: _size!);
    if (widget.onWebViewCreated != null) {
      widget.onWebViewCreated!(_controller);
    }
  }
}
