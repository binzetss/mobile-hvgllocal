import Flutter
import UIKit
import FirebaseMessaging
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let widgetChannel = FlutterMethodChannel(
      name: "vn.hvgl.noibo/widget",
      binaryMessenger: controller.binaryMessenger
    )
    widgetChannel.setMethodCallHandler { call, result in
      if call.method == "updateWidget" {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
          return
        }
        let defaults = UserDefaults(suiteName: "group.vn.hvgl.noibo")
        if let userName = args["user_name"] as? String {
          defaults?.set(userName, forKey: "widget_user_name")
        }
        if let checkin = args["checkin"] as? String {
          defaults?.set(checkin, forKey: "widget_checkin")
        }
        if let checkout = args["checkout"] as? String {
          defaults?.set(checkout, forKey: "widget_checkout")
        }
        if let punches = args["punches"] as? String {
          defaults?.set(punches, forKey: "widget_punches")
        }
        defaults?.synchronize()
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
