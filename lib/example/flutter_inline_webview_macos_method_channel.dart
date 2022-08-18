import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_inline_webview_macos_platform_interface.dart';

/// An implementation of [FlutterInlineWebviewMacosPlatform] that uses method channels.
class MethodChannelFlutterInlineWebviewMacos extends FlutterInlineWebviewMacosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_inline_webview_macos');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
