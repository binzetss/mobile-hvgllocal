package vn.hvgl.noibo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.view.View
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

            // Định dạng ngày hiện tại
            val sdf = SimpleDateFormat("EEE dd/MM", Locale("vi", "VN"))
            val today = sdf.format(Date())

            // Parse danh sách lần chấm công → lấy lần đầu (VÀO) và lần cuối (RA)
            val checkinTime: String
            val checkoutTime: String
            val hasData: Boolean

            try {
                val arr = JSONArray(punchesJson)
                if (arr.length() == 0) {
                    checkinTime  = "--:--"
                    checkoutTime = "--:--"
                    hasData = false
                } else {
                    val firstObj = arr.getJSONObject(0)
                    checkinTime = firstObj.optString("time", "--:--")

                    checkoutTime = if (arr.length() > 1) {
                        val lastObj = arr.getJSONObject(arr.length() - 1)
                        lastObj.optString("time", "--:--")
                    } else {
                        "--:--"
                    }
                    hasData = true
                }
            } catch (e: Exception) {
                checkinTime  = "--:--"
                checkoutTime = "--:--"
                hasData = false
            }

            val views = RemoteViews(context.packageName, R.layout.hvgl_widget_layout)
            views.setTextViewText(R.id.widget_user_name, userName)
            views.setTextViewText(R.id.widget_date, today)
            views.setTextViewText(R.id.widget_checkin, checkinTime)
            views.setTextViewText(R.id.widget_checkout, checkoutTime)
            views.setViewVisibility(
                R.id.widget_status,
                if (hasData) View.GONE else View.VISIBLE
            )

            // Tap để mở app
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
