//
//  Factory.swift
//  flutter_inline_webview_macos
//
//  Created by redstar16 on 2022/08/18.
//

import AppKit
import FlutterMacOS
import Foundation

public class FlutterWebViewMacosFactory: NSObject, FlutterPlatformViewFactory {
  private var registrar: FlutterPluginRegistrar?

  init(registrar: FlutterPluginRegistrar?) {
    super.init()
    self.registrar = registrar
  }
  var webviewController:FlutterWebViewMacosController?

  public func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  )
    -> NSView
  {
      webviewController?.dispose()
      webviewController = FlutterWebViewMacosController(
      registrar: registrar!,
      viewIdentifier: viewId
    )
      return webviewController!
  }
    
    public func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
      return FlutterStandardMessageCodec.sharedInstance()
    }

  deinit {
    webviewController?.dispose()
    webviewController = nil
    print("FlutterWebViewMacosFactory - dealloc")
  }
}
