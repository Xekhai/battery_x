package com.xekhai.battery_x

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    // The channel used for communication between the Dart code and the native Android platform.
    private val CHANNEL = "batteryCheck.xekhai/batteryCheck"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel is used to set a method call handler
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {

            // This method is invoked on the main thread.
                call, result ->
            // If the method being called is "getBatteryLevel"
            if (call.method == "getBatteryLevel") {
                // Get the battery level
                val batteryLevel = getBatteryLevel()

                // If the battery level is not -1, return the battery level to the Dart code
                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    // If the battery level is -1 return an error
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                // If the method is not "getBatteryLevel" return that the method is not implemented
                result.notImplemented()
            }
        }
    }

    // A function to get the battery level of the device
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        // If the Android version is Lollipop (API 21) or above
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            // Get the battery manager
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            // Get the battery level
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            // If the Android version is below Lollipop, create an intent filter for battery changed
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            // Get the battery level from the intent
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        // Return the battery level
        return batteryLevel
    }

}