package com.github.mirai_toto.manabi_do.widgets

import android.content.Context
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.layout.Alignment
import androidx.glance.layout.ContentScale
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import java.util.Calendar
import org.json.JSONObject

private const val WEEKS = 20

/**
 * Day streak and a 20-week activity grid.
 *
 * The grid is drawn into a bitmap: a widget layout allows only a handful of children per row,
 * far fewer than 140 days.
 */
class StreakWidget : GlanceAppWidget() {
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            WidgetContent(context) { prefs -> Content(context, prefs) }
        }
    }

    @Composable
    private fun Content(context: Context, prefs: SharedPreferences) {
        val colors = LocalWidgetColors.current
        val activity = JSONObject(prefs.getString("activity", null) ?: "{}")

        WidgetCard(onClick = openApp(context, "manabido://review"), padding = 18.dp) {
            Row(verticalAlignment = Alignment.CenterVertically, modifier = GlanceModifier.fillMaxWidth()) {
                Label(
                    streak(activity).toString(),
                    color = colors.primary,
                    size = 26.sp,
                    weight = FontWeight.Bold,
                )
                Spacer(GlanceModifier.width(6.dp))
                Label(prefs.text("streak_label"), color = colors.onSurface, size = 14.sp, weight = FontWeight.Medium)
                Spacer(GlanceModifier.defaultWeight())
                Label(prefs.text("streak_range"))
            }
            Spacer(GlanceModifier.height(10.dp))
            Image(
                provider = ImageProvider(heatmap(context, activity, colors)),
                contentDescription = prefs.text("streak_range"),
                contentScale = ContentScale.Fit,
                modifier = GlanceModifier.fillMaxWidth().defaultWeight(),
            )
        }
    }

    /** Consecutive days ending today with a review, as the app's `countStreak` counts. */
    private fun streak(activity: JSONObject): Int {
        val day = Calendar.getInstance()
        var count = 0
        while (activity.optInt(dayKey(day), 0) > 0) {
            count++
            day.add(Calendar.DAY_OF_MONTH, -1)
        }
        return count
    }

    /** Weeks as columns, Monday at the top, today's week last. */
    private fun heatmap(context: Context, activity: JSONObject, colors: WidgetColors): Bitmap {
        val palette = colors.heat(isNight(context))
        val density = context.resources.displayMetrics.density
        val cell = 12 * density
        val gap = 4 * density
        val bitmap =
            Bitmap.createBitmap(
                (WEEKS * cell + (WEEKS - 1) * gap).toInt(),
                (7 * cell + 6 * gap).toInt(),
                Bitmap.Config.ARGB_8888,
            )
        val canvas = Canvas(bitmap)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)

        val today = Calendar.getInstance()
        // Monday-based weekday of today, 0..6.
        val todayRow = (today.get(Calendar.DAY_OF_WEEK) + 5) % 7
        val day = today.clone() as Calendar
        day.add(Calendar.DAY_OF_MONTH, -((WEEKS - 1) * 7 + todayRow))

        for (week in 0 until WEEKS) {
            for (row in 0 until 7) {
                if (week == WEEKS - 1 && row > todayRow) break
                val reviews = activity.optInt(dayKey(day), 0)
                paint.color = palette[level(reviews)]
                val left = week * (cell + gap)
                val top = row * (cell + gap)
                canvas.drawRoundRect(RectF(left, top, left + cell, top + cell), 3 * density, 3 * density, paint)
                day.add(Calendar.DAY_OF_MONTH, 1)
            }
        }
        return bitmap
    }

    private fun level(reviews: Int): Int =
        when {
            reviews <= 0 -> 0
            reviews < 20 -> 1
            reviews < 60 -> 2
            else -> 3
        }
}

class StreakWidgetReceiver : AppWidgetReceiver() {
    override val glanceAppWidget = StreakWidget()
}
