//
//  Controller.swift
//  flutter_inline_webview_macos
//
//  Created by redstar16 on 2022/08/18.
//

import Cocoa
import FlutterMacOS
import Foundation
import WebKit

public class FlutterWebViewMacosController: NSView {

  private weak var registrar: FlutterPluginRegistrar?

  var webView: InAppWebViewMacos?
  var viewId: Any = 0
  var channel: FlutterMethodChannel?
  var methodCallDelegate: InAppWebViewMacosMethodHandler?

  init(
    registrar: FlutterPluginRegistrar, viewIdentifier viewId: Any
  ) {
    super.init(frame: CGRect())

    self.registrar = registrar
    self.viewId = viewId

    channel = FlutterMethodChannel(
      name: "dev.akaboshinit/flutter_inline_webview_macos_controller_"
        + String(describing: viewId),
      binaryMessenger: registrar.messenger)

    methodCallDelegate = InAppWebViewMacosMethodHandler(controller: self)
    channel!.setMethodCallHandler(methodCallDelegate!.handle)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func create(frame: CGRect) {
      let semaphore = DispatchSemaphore(value: 0)
      func setWebView() {
          webView = InAppWebViewMacos(
            frame: frame,
            configuration: WKWebViewConfiguration(),
            channel: channel!
          )

          semaphore.signal()
      }

      setWebView()
      semaphore.wait()

      methodCallDelegate = InAppWebViewMacosMethodHandler(controller: self)
      channel!.setMethodCallHandler(methodCallDelegate!.handle)

      super.autoresizesSubviews = true
      super.autoresizingMask = [.height, .width]

      webView?.autoresizesSubviews = true
      webView?.autoresizingMask = [.height, .width]
      super.layer?.backgroundColor = NSColor.red.cgColor
      super.frame = frame
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
          if let webView = self?.webView {
              self?.subviews.insert(webView, at: 0)
          }
      }
      webView?.windowCreated = true
  }

  func changeSize(frame: CGRect) {
    webView?.frame = frame
    super.frame = frame
  }

  func evaluateJavaScript(javaScriptString: String, completer: @escaping FlutterResult) {
    webView?.evaluateJavaScript(javaScriptString) { result, error in
      if let error = error {
        completer(FlutterError(code: "1", message: error.localizedDescription, details: nil))
        return
      }
      completer(result)
    }
  }


  public func makeInitialLoad(  //params: NSDictionary
    )
  {
    // let windowId = params["windowId"] as? Int64
    // let initialUrlRequest = params["initialUrlRequest"] as? [String: Any?]
    // let initialFile = params["initialFile"] as? String
    // let initialData = params["initialData"] as? [String: String]

    // if windowId == nil {
    //     load(
    //         initialUrlRequest: initialUrlRequest, initialFile: initialFile,
    //         initialData: initialData)
    // }

    //        else if let wId = windowId, let webViewTransport = InAppWebViewMacos.windowWebViews[wId] {
    //            webView?.load(webViewTransport.request)
    //        }
  }

  func dispose() {
    if webView != nil {
      webView!.windowCreated = false
      channel?.setMethodCallHandler(nil)
      channel = nil
      methodCallDelegate?.dispose()
      methodCallDelegate = nil
      webView?.dispose()
      webView = nil
      super.removeFromSuperview()
    }
  }

  deinit {
    dispose()
  }
}

extension URLRequest {
  public init(fromPluginMap: [String: Any?]) {
    if let urlString = fromPluginMap["url"] as? String, let url = URL(string: urlString) {
      self.init(url: url)
    } else {
      self.init(url: URL(string: "about:blank")!)
    }

    if let method = fromPluginMap["method"] as? String {
      httpMethod = method
    }
    if let body = fromPluginMap["body"] as? FlutterStandardTypedData {
      httpBody = body.data
    }
    if let headers = fromPluginMap["headers"] as? [String: String] {
      for (key, value) in headers {
        setValue(value, forHTTPHeaderField: key)
      }
    }
    if let iosAllowsCellularAccess = fromPluginMap["iosAllowsCellularAccess"] as? Bool {
      allowsCellularAccess = iosAllowsCellularAccess
    }
    if let iosCachePolicy = fromPluginMap["iosCachePolicy"] as? Int {
      cachePolicy =
        CachePolicy.init(rawValue: UInt(iosCachePolicy)) ?? .useProtocolCachePolicy
    }
    if let iosHttpShouldHandleCookies = fromPluginMap["iosHttpShouldHandleCookies"] as? Bool {
      httpShouldHandleCookies = iosHttpShouldHandleCookies
    }
    if let iosHttpShouldUsePipelining = fromPluginMap["iosHttpShouldUsePipelining"] as? Bool {
      httpShouldUsePipelining = iosHttpShouldUsePipelining
    }
    if let iosNetworkServiceType = fromPluginMap["iosNetworkServiceType"] as? Int {
      networkServiceType =
        NetworkServiceType.init(rawValue: UInt(iosNetworkServiceType)) ?? .default
    }
    if let iosTimeoutInterval = fromPluginMap["iosTimeoutInterval"] as? Double {
      timeoutInterval = iosTimeoutInterval
    }
    if let iosMainDocumentURL = fromPluginMap["iosMainDocumentURL"] as? String {
      mainDocumentURL = URL(string: iosMainDocumentURL)!
    }
  }

  public func toMap() -> [String: Any?] {
    return [
      "url": url?.absoluteString,
      "method": httpMethod,
      "headers": allHTTPHeaderFields,
      "body": httpBody.map(FlutterStandardTypedData.init(bytes:)),
      "iosAllowsCellularAccess": allowsCellularAccess,
      "iosCachePolicy": cachePolicy.rawValue,
      "iosHttpShouldHandleCookies": httpShouldHandleCookies,
      "iosHttpShouldUsePipelining": httpShouldUsePipelining,
      "iosNetworkServiceType": networkServiceType.rawValue,
      "iosTimeoutInterval": timeoutInterval,
      "iosMainDocumentURL": mainDocumentURL?.absoluteString,
    ]
  }
}
