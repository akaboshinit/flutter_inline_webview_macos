import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_inline_webview_macos_method_channel.dart';

abstract class FlutterInlineWebviewMacosPlatform extends PlatformInterface {
  /// Constructs a FlutterInlineWebviewMacosPlatform.
  FlutterInlineWebviewMacosPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterInlineWebviewMacosPlatform _instance = MethodChannelFlutterInlineWebviewMacos();

  /// The default instance of [FlutterInlineWebviewMacosPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterInlineWebviewMacos].
  static FlutterInlineWebviewMacosPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterInlineWebviewMacosPlatform] when
  /// they register themselves.
  static set instance(FlutterInlineWebviewMacosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
