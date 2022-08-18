import 'flutter_inline_webview_macos_platform_interface.dart';

class FlutterInlineWebviewMacos {
  Future<String?> getPlatformVersion() {
    return FlutterInlineWebviewMacosPlatform.instance.getPlatformVersion();
  }
}
