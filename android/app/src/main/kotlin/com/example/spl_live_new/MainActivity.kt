package com.example.spllive

import android.os.Build
import android.app.PendingIntent
import android.content.pm.PackageInstaller
import android.content.Context
import android.content.Intent
import android.util.Log
import java.io.File
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.spllive/install_apk"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "installApk") {
                val apkPath = call.argument<String>("apkPath")
                if (apkPath != null) {
                    installApk(this, File(apkPath))
                    result.success("Installation started")
                } else {
                    result.error("ERROR", "Invalid APK path", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun installApk(context: Context, apkFile: File) {
        try {
            val packageInstaller = context.packageManager.packageInstaller
            val sessionParams = PackageInstaller.SessionParams(
                PackageInstaller.SessionParams.MODE_FULL_INSTALL
            )

            val packageName = context.packageName
            Log.i("INSTALL_APK", "Installing APK for package: $packageName")

            val sessionId = packageInstaller.createSession(sessionParams)
            val session = packageInstaller.openSession(sessionId)

            apkFile.inputStream().use { inputStream ->
                session.openWrite("base.apk", 0, apkFile.length()).use { outputStream ->
                    inputStream.copyTo(outputStream)
                    session.fsync(outputStream)
                }
            }

            // Create the intent with the package name
            val intent = Intent("com.example.SILENT_INSTALL_RESULT").apply {
                setPackage(context.packageName)
                putExtra(PackageInstaller.EXTRA_PACKAGE_NAME, packageName)
            }

            val pendingIntent = PendingIntent.getBroadcast(
                context, sessionId, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )

            Log.i("INSTALL_APK", "Committing installation session")
            session.commit(pendingIntent.intentSender)
            session.close()
        } catch (e: Exception) {
            Log.e("INSTALL_APK", "Installation failed: ${e.message}")
            e.printStackTrace()
        }
    }
}