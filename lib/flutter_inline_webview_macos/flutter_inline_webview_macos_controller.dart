import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/types.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/webview.dart';

class InlineWebViewMacOsController {
  InlineWebViewMacOsController({
    required dynamic id,
    required WebView webView,
    required Size size,
  }) {
    _id = id;
    _channel = MethodChannel(
      'dev.akaboshinit/flutter_inline_webview_macos_controller_$id',
    );
    _channel.setMethodCallHandler(handleMethod);
    _webView = webView;
    _size = size;

    _init();
  }

  WebView? _webView;
  late MethodChannel _channel;
  // ignore: unused_field
  dynamic _id;
  late Size _size;

  Future<void> _init() async {
    _channel.invokeMethod<bool>('create', {
      'height': _size.height.round(),
      "width": _size.width.round(),
    });

    //  this.ios = IOSInAppWebViewController(channel: _channel);
  }

  void changeSize(Size size) {
    _size = size;
    _channel.invokeMethod<void>('changeSize', {
      'height': _size.height.round(),
      "width": _size.width.round(),
    });
  }

  Future<String?> runJavascript(String javaScript) async {
    final dynamic result = await _channel
        .invokeMethod("evaluateJavaScript", {'javaScript': javaScript});
    if (result is String || result == null) {
      return result;
    }
    return json.encode(result);
  }

  void dispose() {
    _channel.invokeMethod<void>('dispose');
  }

  Future<dynamic> handleMethod(MethodCall call) async {
    final arguments = call.arguments as String;
    print(
      'method:${call.method} InlineWebviewMacOsController arguments:$arguments',
    );

    switch (call.method) {
      case 'onLoadStart':
        // _injectedScriptsFromURL.clear();
        if (_webView != null && _webView!.onLoadStart != null) {
          final url = call.arguments['url'] as String?;
          final uri = url != null ? Uri.parse(url) : null;
          if (_webView != null && _webView!.onLoadStart != null) {
            _webView!.onLoadStart!(this, uri);
          }
        }
        break;
      case 'onLoadStop':
        if (_webView != null && _webView!.onLoadStop != null) {
          final url = call.arguments['url'] as String?;
          final uri = url != null ? Uri.parse(url) : null;
          if (_webView != null && _webView!.onLoadStop != null) {
            _webView!.onLoadStop!(this, uri);
          }
        }
        break;
      case 'onLoadError':
        if (_webView != null && _webView!.onLoadError != null) {
          final url = call.arguments['url'] as String?;
          final code = call.arguments['code'] as int;
          final message = call.arguments['message'] as String;
          final uri = url != null ? Uri.parse(url) : null;
          if (_webView != null && _webView!.onLoadError != null) {
            _webView!.onLoadError!(this, uri, code, message);
          }
        }
        break;
      case 'onLoadHttpError':
        if (_webView != null && _webView!.onLoadHttpError != null) {
          final url = call.arguments['url'] as String?;
          final statusCode = call.arguments['statusCode'] as int;
          final description = call.arguments['description'] as String;
          final uri = url != null ? Uri.parse(url) : null;
          if (_webView != null && _webView!.onLoadHttpError != null) {
            _webView!.onLoadHttpError!(this, uri, statusCode, description);
          }
        }
        break;
      default:
        print(call.method);
        print('Error:InAppWebViewController');
    }
  }

  static Map<String, dynamic> defaultArgs = <String, dynamic>{};

  ///Gets the URL for the current page.
  ///This is not always the same as the URL passed to [WebView.onLoadStart] because although the load for that URL has begun, the current page may not have changed.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.getUrl](https://developer.android.com/reference/android/webkit/WebView#getUrl()))
  ///- iOS ([Official API - WKWebView.url](https://developer.apple.com/documentation/webkit/wkwebview/1415005-url))
  Future<Uri?> getUrl() async {
    final url = await _channel.invokeMethod<String>('getUrl', defaultArgs);
    return url != null ? Uri.parse(url) : null;
  }

  ///Gets the title for the current page.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.getTitle](https://developer.android.com/reference/android/webkit/WebView#getTitle()))
  ///- iOS ([Official API - WKWebView.title](https://developer.apple.com/documentation/webkit/wkwebview/1415015-title))
  Future<String?> getTitle() async {
    return _channel.invokeMethod<String>('getTitle', defaultArgs);
  }

  ///Loads the given [urlRequest].
  ///
  ///- [allowingReadAccessTo], used in combination with [urlRequest] (using the `file://` scheme),
  ///it represents the URL from which to read the web content.
  ///This URL must be a file-based URL (using the `file://` scheme).
  ///Specify the same value as the URL parameter to prevent WebView from reading any other content.
  ///Specify a directory to give WebView permission to read additional files in the specified directory.
  ///**NOTE**: available only on iOS.
  ///
  ///**NOTE for Android**: when loading an URL Request using "POST" method, headers are ignored.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.loadUrl](https://developer.android.com/reference/android/webkit/WebView#loadUrl(java.lang.String))). If method is "POST", [Official API - WebView.postUrl](https://developer.android.com/reference/android/webkit/WebView#postUrl(java.lang.String,%20byte[]))
  ///- iOS ([Official API - WKWebView.load](https://developer.apple.com/documentation/webkit/wkwebview/1414954-load). If [allowingReadAccessTo] is used, [Official API - WKWebView.loadFileURL](https://developer.apple.com/documentation/webkit/wkwebview/1414973-loadfileurl))
  Future<bool> loadUrl({
    required URLRequest urlRequest,
    @Deprecated('Use `allowingReadAccessTo` instead')
        Uri? iosAllowingReadAccessTo,
    Uri? allowingReadAccessTo,
  }) async {
    assert(urlRequest.url != null && urlRequest.url.toString().isNotEmpty);
    assert(
      iosAllowingReadAccessTo == null ||
          iosAllowingReadAccessTo.isScheme('file'),
    );

    final args = defaultArgs;
    args['urlRequest'] = urlRequest.toMap();
    args['allowingReadAccessTo'] =
        allowingReadAccessTo?.toString() ?? iosAllowingReadAccessTo?.toString();

    try {
      return await _channel.invokeMethod<bool>('loadUrl', args) ?? false;
    } catch (e) {
      return false;
    }
  }

  ///Reloads the WebView.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.reload](https://developer.android.com/reference/android/webkit/WebView#reload()))
  ///- iOS ([Official API - WKWebView.reload](https://developer.apple.com/documentation/webkit/wkwebview/1414969-reload))
  Future<void> reload() async {
    await _channel.invokeMethod<void>('reload', defaultArgs);
  }

  ///Goes back in the history of the WebView.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.goBack](https://developer.android.com/reference/android/webkit/WebView#goBack()))
  ///- iOS ([Official API - WKWebView.goBack](https://developer.apple.com/documentation/webkit/wkwebview/1414952-goback))
  Future<void> goBack() async {
    await _channel.invokeMethod<void>('goBack', defaultArgs);
  }

  ///Returns a boolean value indicating whether the WebView can move backward.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.canGoBack](https://developer.android.com/reference/android/webkit/WebView#canGoBack()))
  ///- iOS ([Official API - WKWebView.canGoBack](https://developer.apple.com/documentation/webkit/wkwebview/1414966-cangoback))
  Future<bool> canGoBack() async {
    final canGoBack =
        await _channel.invokeMethod<bool>('canGoBack', defaultArgs);
    return (canGoBack is bool) && canGoBack;
  }

  ///Goes forward in the history of the WebView.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.goForward](https://developer.android.com/reference/android/webkit/WebView#goForward()))
  ///- iOS ([Official API - WKWebView.goForward](https://developer.apple.com/documentation/webkit/wkwebview/1414993-goforward))
  Future<void> goForward() async {
    await _channel.invokeMethod<void>('goForward', defaultArgs);
  }

  ///Returns a boolean value indicating whether the WebView can move forward.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.canGoForward](https://developer.android.com/reference/android/webkit/WebView#canGoForward()))
  ///- iOS ([Official API - WKWebView.canGoForward](https://developer.apple.com/documentation/webkit/wkwebview/1414962-cangoforward))
  Future<bool> canGoForward() async {
    final canGoForward =
        await _channel.invokeMethod<bool>('canGoForward', defaultArgs);
    return (canGoForward is bool) && canGoForward;
  }

  ///Check if the WebView instance is in a loading state.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  Future<bool> isLoading() async {
    final isLoading =
        await _channel.invokeMethod<bool>('isLoading', defaultArgs);
    return (isLoading is bool) && isLoading;
  }

  ///Stops the WebView from loading.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.stopLoading](https://developer.android.com/reference/android/webkit/WebView#stopLoading()))
  ///- iOS ([Official API - WKWebView.stopLoading](https://developer.apple.com/documentation/webkit/wkwebview/1414981-stoploading))
  Future<void> stopLoading() async {
    await _channel.invokeMethod<void>('stopLoading', defaultArgs);
  }

  ///Clears all the WebView's cache.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  Future<void> clearCache() async {
    await _channel.invokeMethod<void>('clearCache', defaultArgs);
  }

  ///Gets the URL that was originally requested for the current page.
  ///This is not always the same as the URL passed to [InAppWebView.onLoadStarted] because although the load for that URL has begun,
  ///the current page may not have changed. Also, there may have been redirects resulting in a different URL to that originally requested.
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebView.getOriginalUrl](https://developer.android.com/reference/android/webkit/WebView#getOriginalUrl()))
  ///- iOS
  Future<Uri?> getOriginalUrl() async {
    final url =
        await _channel.invokeMethod<String>('getOriginalUrl', defaultArgs);
    return url != null ? Uri.parse(url) : null;
  }
}
