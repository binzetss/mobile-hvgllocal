package vn.hvgl.noibo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import org.json.JSONArray
import java.text.SimpleDateFormat
import java.util.*

class HvglWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
        ) {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val userName    = prefs.getString("widget_user_name", "Người dùng") ?: "Người dùng"
            val punchesJson = prefs.getString("widget_punches", "[]") ?: "[]"

            val sdf = SimpleDateFormat("EEE dd/MM", Locale("vi", "VN"))
            val today = sdf.format(Date())

            // Build punches display text
            val punchesText = try {
                val arr = JSONArray(punchesJson)
                if (arr.length() == 0) {
                    "Chưa chấm công hôm nay"
                } else {
                    (0 until arr.length()).joinToString("\n") { i ->
                        val obj  = arr.getJSONObject(i)
                        val time = obj.optString("time", "--")
                        val type = obj.optString("type", "")
                        // Even index (0,2,4…) = vào, odd (1,3,5…) = ra
                        val arrow = if (i % 2 == 0) "↑" else "↓"
                        "$arrow $time  $type"
                    }
                }
            } catch (e: Exception) {
                "Chưa chấm công"
            }

            val views = RemoteViews(context.packageName, R.layout.hvgl_widget_layout)
            views.setTextViewText(R.id.widget_user_name, userName)
            views.setTextViewText(R.id.widget_date, today)
            views.setTextViewText(R.id.widget_punches, punchesText)

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
