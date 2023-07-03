import Cocoa
import FlutterMacOS

public class FlutterInlineWebViewMacosPlugin: NSObject, FlutterPlugin {
    static var instance: FlutterInlineWebViewMacosPlugin?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = FlutterInlineWebViewMacosPlugin(with: registrar)
        FlutterInlineWebViewMacosPlugin.instance = instance
    }

    public init(with registrar: FlutterPluginRegistrar) {
        super.init()

         registrar.register(
             FlutterWebViewMacosFactory(registrar: registrar) as FlutterPlatformViewFactory,
             withId: "dev.akaboshinit/flutter_inline_webview_macos")
    }
}
