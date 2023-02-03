# Battery Status Flutter Challenge
This is a simple Flutter app that displays the battery level of the device it is running on. The app has a single button labeled "Check Battery Level". When the button is pressed, it displays the current battery level as a percentage.

The app works on both Android and iOS devices and is implemented using platform-specific code, without the use of any external packages. The app also handles the case where the device's battery level cannot be determined and displays an appropriate message.

#### [Kotlin (Android Code)](https://github.com/Xekhai/battery_x/blob/main/android/app/src/main/kotlin/com/xekhai/battery_x/MainActivity.kt)
#### [Swift (iOS Code)](https://github.com/Xekhai/battery_x/blob/main/ios/Runner/AppDelegate.swift)

#
In addition to the main requirements, the app also includes the following bonus features:

>+ Implemented Android watch UI for displaying battery status

>+ Added a feature to monitor the battery level and display an alert if the battery level falls below a certain threshold using a timer that constantly checks until the battery finally falls below the threshold.
```dart
...
  void initState() {
    super.initState();
    // start the timer to monitor the battery level and display an alert if the battery level falls below a certain threshold
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getBatteryLevel();
    });
  }
...
```
# Demo
### Here's a demo of the app running on an iOS/MacOS device:

https://youtu.be/gEtfc4s-yV4
### Here's a demo of the app running on an Android device:
Battery Status Flutter Challenge on Android

### Here's a demo of the app running on an Android Watch (Wear OS) device:
Battery Status Flutter Challenge on Android

##

# How to use
Clone the repository

```
git clone https://github.com/Xekhai/battery_x.git
```

Navigate to the project directory
```
cd battery_x
```
Run the app on an emulator or connected device
```
flutter run
```
## Note
 The battery app doesn't work on the iPhone emulator because it doesn't support the Battery API and must be tested on a real device or you can target the MacOS desktop (As shown in the demo).

## Contributing
If you have any improvements in mind, feel free to submit a pull request.