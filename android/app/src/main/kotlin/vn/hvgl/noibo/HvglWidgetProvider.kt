package vn.hvgl.noibo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
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
            val userName = prefs.getString("widget_user_name", "Người dùng") ?: "Người dùng"
            val checkin = prefs.getString("widget_checkin", "--") ?: "--"
            val checkout = prefs.getString("widget_checkout", "--") ?: "--"

            val sdf = SimpleDateFormat("EEE, dd/MM", Locale("vi", "VN"))
            val today = sdf.format(Date())

            val views = RemoteViews(context.packageName, R.layout.hvgl_widget_layout)
            views.setTextViewText(R.id.widget_user_name, userName)
            views.setTextViewText(R.id.widget_checkin, checkin)
            views.setTextViewText(R.id.widget_checkout, checkout)
            views.setTextViewText(R.id.widget_date, today)

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
