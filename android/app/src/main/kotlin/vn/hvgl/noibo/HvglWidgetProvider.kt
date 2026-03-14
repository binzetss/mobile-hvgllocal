package vn.hvgl.noibo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
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
        private const val TAG = "HvglWidget"

        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
        ) {
            try {
                val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
                val userName    = prefs.getString("widget_user_name", "Người dùng") ?: "Người dùng"
                val punchesJson = prefs.getString("widget_punches", "[]") ?: "[]"

                // Định dạng ngày hiện tại
                val sdf = SimpleDateFormat("EEE dd/MM", Locale("vi", "VN"))
                val today = sdf.format(Date())

                // Parse danh sách lần chấm công → lấy lần đầu (VÀO) và lần cuối (RA)
                var checkinTime  = "--:--"
                var checkoutTime = "--:--"
                var hasData      = false

                try {
                    val arr = JSONArray(punchesJson)
                    if (arr.length() > 0) {
                        val firstObj = arr.getJSONObject(0)
                        checkinTime = firstObj.optString("time", "--:--")
                        if (arr.length() > 1) {
                            val lastObj = arr.getJSONObject(arr.length() - 1)
                            checkoutTime = lastObj.optString("time", "--:--")
                        }
                        hasData = true
                    }
                } catch (e: Exception) {
                    Log.w(TAG, "JSON parse error: ${e.message}")
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
                Log.d(TAG, "Widget updated: user=$userName checkin=$checkinTime checkout=$checkoutTime")
            } catch (e: Exception) {
                Log.e(TAG, "updateWidget error: ${e.message}", e)
                // Fallback: hiển thị widget tối giản để tránh blank hoàn toàn
                try {
                    val views = RemoteViews(context.packageName, R.layout.hvgl_widget_layout)
                    views.setTextViewText(R.id.widget_user_name, "HVGL Nội Bộ")
                    views.setTextViewText(R.id.widget_checkin, "--:--")
                    views.setTextViewText(R.id.widget_checkout, "--:--")
                    appWidgetManager.updateAppWidget(appWidgetId, views)
                } catch (e2: Exception) {
                    Log.e(TAG, "Fallback widget also failed: ${e2.message}", e2)
                }
            }
        }
    }
}
