import Cocoa
import FlutterMacOS

public class FlutterInlineWebViewMacosPlugin: NSObject, FlutterPlugin {
    static var instance: FlutterInlineWebViewMacosPlugin?
    var registrar: FlutterPluginRegistrar?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_inline_webview_macos", binaryMessenger: registrar.messenger)
        let instance = FlutterInlineWebViewMacosPlugin(with: registrar)

        registrar.addMethodCallDelegate(instance, channel: channel)
        FlutterInlineWebViewMacosPlugin.instance = instance
    }

    public init(with registrar: FlutterPluginRegistrar) {
        super.init()

         self.registrar = registrar
         registrar.register(
             FlutterWebViewMacosFactory(registrar: registrar) as FlutterPlatformViewFactory,
             withId: "dev.akaboshinit/flutter_inline_webview_macos")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
        result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        default:
        result(FlutterMethodNotImplemented)
        }
    }
}
