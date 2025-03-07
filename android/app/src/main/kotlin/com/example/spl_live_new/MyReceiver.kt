package com.example.spllive

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.os.Handler
import android.os.Looper
import android.content.pm.PackageInstaller
import android.content.ComponentName

class MyReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent == null || context == null) {
            Log.e("INSTALL_APK", "❌ Received null intent or context in MyReceiver")
            return
        }

        val status = intent.getIntExtra(PackageInstaller.EXTRA_STATUS, -1)
        val message = intent.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE) ?: "Unknown error"
        val packageName = intent.getStringExtra(PackageInstaller.EXTRA_PACKAGE_NAME) ?: "com.example.spllive"

        Log.d("INSTALL_APK", "Received broadcast - Status: $status, Message: $message, Package: $packageName")

        when (status) {
            PackageInstaller.STATUS_SUCCESS -> {
                Log.i("INSTALL_APK", "✅ Installation successful!")

                // Try multiple launch methods with increasing delays
                tryLaunchApp(context, packageName, 1000)  // Try after 1 second
                tryLaunchApp(context, packageName, 3000)  // Try after 3 seconds
                tryLaunchApp(context, packageName, 5000)  // Try after 5 seconds
            }
            PackageInstaller.STATUS_PENDING_USER_ACTION -> {
                Log.i("INSTALL_APK", "👤 User action pending")
                val activityIntent = intent.getParcelableExtra<Intent>(Intent.EXTRA_INTENT)
                if (activityIntent != null) {
                    activityIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(activityIntent)
                } else {
                    Log.e("INSTALL_APK", "❌ No activity intent found for user action")
                }
            }
            else -> {
                Log.e("INSTALL_APK", "❌ Installation failed with status $status: $message")
            }
        }
    }

    private fun tryLaunchApp(context: Context, packageName: String, delayMillis: Long) {
        Handler(Looper.getMainLooper()).postDelayed({
            try {
                Log.i("INSTALL_APK", "🚀 Attempting to launch app after $delayMillis ms")

                // Method 1: Using getLaunchIntentForPackage
                val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
                if (launchIntent != null) {
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    context.startActivity(launchIntent)
                    Log.i("INSTALL_APK", "✅ Method 1: App launch attempted")
                } else {
                    Log.e("INSTALL_APK", "⚠️ Method 1: Could not get launch intent")

                    // Method 2: Using explicit component
                    try {
                        val componentName = ComponentName(packageName, "$packageName.MainActivity")
                        val explicitIntent = Intent(Intent.ACTION_MAIN).apply {
                            addCategory(Intent.CATEGORY_LAUNCHER)
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                            component = componentName
                        }
                        context.startActivity(explicitIntent)
                        Log.i("INSTALL_APK", "✅ Method 2: App launch attempted with explicit component")
                    } catch (e: Exception) {
                        Log.e("INSTALL_APK", "❌ Method 2: Error launching app: ${e.message}")
                    }
                }
            } catch (e: Exception) {
                Log.e("INSTALL_APK", "❌ Error launching app: ${e.message}")
            }
        }, delayMillis)
    }
}