import 'package:flutter_inline_webview_macos/example/flutter_inline_webview_macos_method_channel.dart';
import 'package:flutter_inline_webview_macos/example/flutter_inline_webview_macos_platform_interface.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterInlineWebviewMacosPlatform
    with MockPlatformInterfaceMixin
    implements FlutterInlineWebviewMacosPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterInlineWebviewMacosPlatform initialPlatform =
      FlutterInlineWebviewMacosPlatform.instance;

  test('$MethodChannelFlutterInlineWebviewMacos is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelFlutterInlineWebviewMacos>());
  });

  test('getPlatformVersion', () async {
    FlutterInlineWebviewMacos flutterInlineWebviewMacosPlugin =
        FlutterInlineWebviewMacos();
    MockFlutterInlineWebviewMacosPlatform fakePlatform =
        MockFlutterInlineWebviewMacosPlatform();
    FlutterInlineWebviewMacosPlatform.instance = fakePlatform;

    expect(await flutterInlineWebviewMacosPlugin.getPlatformVersion(), '42');
  });
}
