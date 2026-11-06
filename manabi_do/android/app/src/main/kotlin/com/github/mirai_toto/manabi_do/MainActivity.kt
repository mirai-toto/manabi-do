package com.github.mirai_toto.manabi_do

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Opens this app's page in the system notification settings, for a user who
        // blocked notifications and wants reminders back (see reminder_service.dart).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "manabido/notification_settings")
            .setMethodCallHandler { call, result ->
                if (call.method != "open") return@setMethodCallHandler result.notImplemented()
                startActivity(
                    Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                        .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                )
                result.success(null)
            }
    }
}
