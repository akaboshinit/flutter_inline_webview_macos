import 'package:flutter/services.dart';
import 'package:flutter_inline_webview_macos/example/flutter_inline_webview_macos_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MethodChannelFlutterInlineWebviewMacos platform =
      MethodChannelFlutterInlineWebviewMacos();
  const MethodChannel channel = MethodChannel('flutter_inline_webview_macos');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
