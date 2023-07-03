import 'package:flutter/material.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/flutter_inline_webview_macos_controller.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/types.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hide = false;

  InlineWebViewMacOsController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _hide = !_hide;
                    });
                  },
                  child: Text("toggle hide ${!_hide}")),
              _hide
                  ? Column(
                      children: [
                        TextButton(
                            onPressed: () async {
                              await _controller!.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse("https://youtube.com")));
                            },
                            child: const Text('load:"youtube.com"')),
                        TextButton(
                            onPressed: () async {
                              await _controller!.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse("https://zenn.dev")));
                            },
                            child: const Text('load:"zenn.dev"')),
                        TextButton(
                            onPressed: () async {
                              // final url = await _controller!.getUrl();
                              // print(url);
                            },
                            child: const Text("getUrl")),
                        InlineWebViewMacOs(
                          key: widget.key,
                          width: 500,
                          height: 300,
                          onWebViewCreated: (controller) {
                            _controller = controller;
                            // _controller!.loadUrl(
                            //     urlRequest: URLRequest(
                            //         url: Uri.parse("https://google.com")));
                          },
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
