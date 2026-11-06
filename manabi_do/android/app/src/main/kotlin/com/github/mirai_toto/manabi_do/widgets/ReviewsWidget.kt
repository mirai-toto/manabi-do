package com.github.mirai_toto.manabi_do.widgets

import android.content.Context
import android.text.format.DateFormat
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.currentState
import androidx.glance.layout.Spacer
import androidx.glance.layout.height
import androidx.glance.text.FontWeight
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import java.util.Date
import org.json.JSONArray

/**
 * How many reviews are due, recounted from the saved due times on every update so the number
 * keeps climbing while the app is closed.
 */
class ReviewsWidget : GlanceAppWidget() {
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            // The state, not its preferences: the preferences are the same object on every
            // update, so Compose would skip the redraw while the session is still open.
            Content(context, currentState<HomeWidgetGlanceState>())
        }
    }

    @Composable
    private fun Content(context: Context, state: HomeWidgetGlanceState) {
        val prefs = state.preferences
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
            Label(due.toString(), color = WidgetColors.primary, size = 44.sp, weight = FontWeight.Bold)
            Label(unit, color = WidgetColors.onSurface, size = 14.sp, weight = FontWeight.Medium)
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
                    background = WidgetColors.primary,
                    content = WidgetColors.onPrimary,
                )
            }
        }
    }
}

class ReviewsWidgetReceiver : HomeWidgetGlanceWidgetReceiver<ReviewsWidget>() {
    override val glanceAppWidget = ReviewsWidget()
}
