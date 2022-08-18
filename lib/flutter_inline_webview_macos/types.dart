///A URL load request that is independent of protocol or URL scheme.
class URLRequest {
  URLRequest({
    required this.url,
  });

  ///The URL of the request. Setting this to `null` will load `about:blank`.
  Uri? url;

  static URLRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return URLRequest(
      url: map['url'] != null ? Uri.parse(map['url'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url?.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

///Initial [data] as a content for an [WebView] instance, using [baseUrl] as the base URL for it.
class InAppWebViewInitialData {
  InAppWebViewInitialData({
    required this.data,
    this.mimeType = 'text/html',
    this.encoding = 'utf8',
    Uri? baseUrl,
    Uri? androidHistoryUrl,
  }) {
    this.baseUrl = baseUrl ?? Uri.parse('about:blank');
    this.androidHistoryUrl = androidHistoryUrl ?? Uri.parse('about:blank');
  }

  ///A String of data in the given encoding.
  String data;

  ///The MIME type of the data, e.g. "text/html". The default value is `"text/html"`.
  String mimeType;

  ///The encoding of the data. The default value is `"utf8"`.
  String encoding;

  ///The URL to use as the page's base URL. The default value is `about:blank`.
  late Uri baseUrl;

  ///The URL to use as the history entry. The default value is `about:blank`. If non-null, this must be a valid URL.
  ///
  ///This parameter is used only on Android.
  late Uri androidHistoryUrl;

  Map<String, String> toMap() {
    return {
      'data': data,
      'mimeType': mimeType,
      'encoding': encoding,
      'baseUrl': baseUrl.toString(),
      'historyUrl': androidHistoryUrl.toString()
    };
  }

  Map<String, String> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
