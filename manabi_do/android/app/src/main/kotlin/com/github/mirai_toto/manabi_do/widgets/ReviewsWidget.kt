package com.github.mirai_toto.manabi_do.widgets

import android.content.Context
import android.content.SharedPreferences
import android.text.format.DateFormat
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.layout.Spacer
import androidx.glance.layout.height
import androidx.glance.text.FontWeight
import java.util.Date
import org.json.JSONArray

/**
 * How many reviews are due, recounted from the saved due times on every update so the number
 * keeps climbing while the app is closed.
 */
class ReviewsWidget : GlanceAppWidget() {
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            WidgetContent(context) { prefs -> Content(context, prefs) }
        }
    }

    @Composable
    private fun Content(context: Context, prefs: SharedPreferences) {
        val colors = LocalWidgetColors.current
        val now = System.currentTimeMillis()
        val upcoming = JSONArray(prefs.getString("reviews_upcoming", null) ?: "[]")
        var due = prefs.number("reviews_due_base")
        var next: Long? = null
        for (i in 0 until upcoming.length()) {
            val at = upcoming.getLong(i)
            if (at <= now) {
                due++
            } else {
                next = at
                break
            }
        }
        val unit =
            when (due) {
                0L -> prefs.text("reviews_unit_zero")
                1L -> prefs.text("reviews_unit_one")
                else -> prefs.text("reviews_unit_other")
            }
        val open = openApp(context, "manabido://review")

        WidgetCard(onClick = open) {
            Label("Manabi Do", weight = FontWeight.Medium)
            Spacer(GlanceModifier.defaultWeight())
            Label(due.toString(), color = colors.primary, size = 44.sp, weight = FontWeight.Bold)
            Label(
                unit,
                color = colors.onSurface,
                size = 14.sp,
                weight = FontWeight.Medium,
                maxLines = 2,
            )
            val hint =
                when {
                    next != null ->
                        prefs.text("reviews_next")
                            .replace("{time}", DateFormat.getTimeFormat(context).format(Date(next)))
                    due == 0L -> prefs.text("reviews_caught_up")
                    else -> ""
                }
            if (hint.isNotEmpty()) Label(hint)
            Spacer(GlanceModifier.defaultWeight())
            if (due > 0) {
                Spacer(GlanceModifier.height(4.dp))
                PillButton(
                    text = prefs.text("reviews_button"),
                    onClick = open,
                    background = colors.primary,
                    content = colors.onPrimary,
                )
            }
        }
    }
}

class ReviewsWidgetReceiver : AppWidgetReceiver() {
    override val glanceAppWidget = ReviewsWidget()
}
