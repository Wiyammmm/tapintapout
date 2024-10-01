package com.example.tapintapout

import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import android.os.Bundle
import android.Manifest
import android.content.pm.PackageManager
import android.telephony.TelephonyManager
import android.content.Context
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.lang.reflect.Method
class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // val systemPropertiesClass = Class.forName("android.os.SystemProperties")
        // val getMethod: Method = systemPropertiesClass.getDeclaredMethod("get", String::class.java)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.flutter.epic/epic").setMethodCallHandler {
          call, result ->
          when (call.method) {
            "Printy" -> {
                val systemPropertiesClass = Class.forName("android.os.SystemProperties")
                val getMethod: Method = systemPropertiesClass.getDeclaredMethod("get", String::class.java)
                val serial: String? = getSerialNumber(getMethod)
                result.success(serial)
            }
          
            else -> {
                result.notImplemented()
            }
        }
        
        }   
      }

  

      private fun getSerialNumber(getMethod: Method): String? {
        val apiLevel = Build.VERSION.SDK_INT

        return when {
            apiLevel >= Build.VERSION_CODES.R -> {
                try {
                    getMethod.invoke(null, "ro.sunmi.serial") as String
                } catch (e: Exception) {
                    e.printStackTrace()
                    null
                }
            }
            apiLevel >= Build.VERSION_CODES.O -> Build.getSerial()
            else -> {
                try {
                    getMethod.invoke(null, "ro.serialno") as String
                } catch (e: Exception) {
                    e.printStackTrace()
                    null
                }
            }
        }
    }
}
