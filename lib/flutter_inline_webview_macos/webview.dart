import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/flutter_inline_webview_macos_controller.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/types.dart';

///Abstract class that represents a WebView. Used by [InAppWebView] and [HeadlessInAppWebView].
abstract class WebView {
  WebView({
    this.windowId,
    this.onWebViewCreated,
    this.initialUrlRequest,
    this.onLoadStart,
    this.onLoadStop,
    this.onLoadError,
    this.onLoadHttpError,
    this.onDispose,
  });

  ///The window id of a [CreateWindowAction.windowId].
  final int? windowId;

  ///Event fired when the [WebView] is created.
  final void Function(InlineWebViewMacOsController controller)?
      onWebViewCreated;

  ///Event fired when the [WebView] starts to load an [url].
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onPageStarted](https://developer.android.com/reference/android/webkit/WebViewClient#onPageStarted(android.webkit.WebView,%20java.lang.String,%20android.graphics.Bitmap)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455621-webview))
  final void Function(InlineWebViewMacOsController controller, Uri? url)?
      onLoadStart;

  ///Event fired when the [WebView] finishes loading an [url].
  ///
  ///**Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - WebViewClient.onPageFinished](https://developer.android.com/reference/android/webkit/WebViewClient#onPageFinished(android.webkit.WebView,%20java.lang.String)))
  ///- iOS ([Official API - WKNavigationDelegate.webView](https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455629-webview))
  final void Function(InlineWebViewMacOsController controller, Uri? url)?
      onLoadStop;

  final void Function()? onDispose;

  final void Function(
    InlineWebViewMacOsController controller,
    Uri? url,
    int code,
    String message,
  )? onLoadError;

  final void Function(
    InlineWebViewMacOsController controller,
    Uri? url,
    int statusCode,
    String description,
  )? onLoadHttpError;

  ///Initial url request that will be loaded.
  ///
  ///**NOTE for Android**: when loading an URL Request using "POST" method, headers are ignored.
  final URLRequest? initialUrlRequest;
}
