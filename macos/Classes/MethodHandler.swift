//
//  MethodHandler.swift
//  flutter_inline_webview_macos
//
//  Created by redstar16 on 2022/08/18.
//

import FlutterMacOS
import Foundation
import WebKit

public class FlutterMethodCallDelegate: NSObject {
  public override init() {
    super.init()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

  }
}

public class InAppWebViewMacosMethodHandler: FlutterMethodCallDelegate {
  var controller: FlutterWebViewMacosController?

  init(
    controller: FlutterWebViewMacosController
  ) {
    super.init()
    self.controller = controller
  }

  public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any]
    print("method:\(call.method) arguments:\(arguments) :InAppWebViewMethodHandler")

    switch call.method {
    case "create":
      let height = arguments!["height"] as! Int
      let width = arguments!["width"] as! Int
      let frame = CGRect(x: 0, y: 0, width: width, height: height)
      controller!.create(frame: frame)
      result(true)
        
    case "changeSize":
      let height = arguments!["height"] as! Int
      let width = arguments!["width"] as! Int
      let frame = CGRect(x: 0, y: 0, width: width, height: height)
      controller!.changeSize(frame: frame)
      result("success")
        
    case "dispose":
      controller!.dispose()
      result("success")
        
    case "loadUrl":
      let urlRequest = arguments!["urlRequest"] as! [String: Any?]
      let allowingReadAccessTo = arguments!["allowingReadAccessTo"] as? String
      var allowingReadAccessToURL: URL? = nil
      if let allowingReadAccessTo = allowingReadAccessTo {
        allowingReadAccessToURL = URL(string: allowingReadAccessTo)
      }
    
    // FIXME: Don't really want to sleep, but it crashes when I load it continuously.
    Thread.sleep(forTimeInterval: 1)
    
    controller!.webView!.loadUrl(
        urlRequest: URLRequest.init(fromPluginMap: urlRequest),
        allowingReadAccessTo: allowingReadAccessToURL)

    result(true)

    case "getUrl":
      let url = controller!.webView!.getOriginalUrl()
      result(url?.baseURL)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func dispose() {
      controller = nil
  }

  deinit {
    print("InAppWebViewMethodHandler - dealloc")
    dispose()
  }
}
