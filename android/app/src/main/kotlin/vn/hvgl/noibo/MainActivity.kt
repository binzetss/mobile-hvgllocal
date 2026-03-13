package vn.hvgl.noibo

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "vn.hvgl.noibo/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                if (call.method == "updateWidget") {
                    val prefs = applicationContext.getSharedPreferences(
                        "HomeWidgetPreferences", MODE_PRIVATE
                    )
                    val editor = prefs.edit()
                    call.argument<String>("user_name")?.let {
                        editor.putString("widget_user_name", it)
                    }
                    call.argument<String>("checkin")?.let {
                        editor.putString("widget_checkin", it)
                    }
                    call.argument<String>("checkout")?.let {
                        editor.putString("widget_checkout", it)
                    }
                    editor.apply()

                    val manager = AppWidgetManager.getInstance(applicationContext)
                    val ids = manager.getAppWidgetIds(
                        ComponentName(applicationContext, HvglWidgetProvider::class.java)
                    )
                    for (id in ids) {
                        HvglWidgetProvider.updateWidget(applicationContext, manager, id)
                    }
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
