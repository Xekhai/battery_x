import UIKit
import Flutter

// AppDelegate.swift

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Get the root view controller of the application
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

    // Create a MethodChannel instance with a name, and set a method call handler
    // that will be invoked when the method is called from Flutter
    let batteryChannel = FlutterMethodChannel(name: "batteryCheck.xekhai/batteryCheck", binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      guard call.method == "getBatteryLevel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      receiveBatteryLevel(result: result)
    })

    // Register any plugins with the Flutter engine
    GeneratedPluginRegistrant.register(with: self)

    // Call the superclass implementation of the application method
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// Private method to receive the battery level and return it back to Flutter
private func receiveBatteryLevel(result: FlutterResult) {
  let device = UIDevice.current

  // Enable battery monitoring
  device.isBatteryMonitoringEnabled = true

  // If the battery state is unknown, return a FlutterError
  if device.batteryState == UIDevice.BatteryState.unknown {
    result(FlutterError(code: "UNAVAILABLE",
                        message: "Battery level not available.",
                        details: nil))
  } else {
    // Else, return the battery level (0-100) as an Int
    result(Int(device.batteryLevel * 100))
  }
}
