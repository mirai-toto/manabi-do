package com.github.mirai_toto.manabi_do.widgets

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import java.util.Calendar
import org.json.JSONArray
import org.json.JSONObject

/** One kanji a day out of the week the app picked ahead. */
class KanjiWidget : GlanceAppWidget() {
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            // The state, not its preferences: the preferences are the same object on every
            // update, so Compose would skip the redraw while the session is still open.
            Content(context, currentState<HomeWidgetGlanceState>())
        }
    }

    /** Today's entry, or the latest one when the app has not run for a week. */
    private fun today(prefs: SharedPreferences): JSONObject? {
        val days = JSONArray(prefs.getString("kanji_days", null) ?: "[]")
        val key = dayKey(Calendar.getInstance())
        var latest: JSONObject? = null
        for (i in 0 until days.length()) {
            val day = days.getJSONObject(i)
            if (day.getString("day") == key) return day
            if (day.getString("day") < key) latest = day
        }
        return latest ?: if (days.length() > 0) days.getJSONObject(0) else null
    }

    @Composable
    private fun Content(context: Context, state: HomeWidgetGlanceState) {
        val prefs = state.preferences
        val kanji = today(prefs)
        val link = if (kanji == null) "manabido://review" else "manabido://kanji/${kanji.getInt("id")}"

        WidgetCard(onClick = openApp(context, link)) {
            if (kanji == null) {
                Label(prefs.text("kanji_title"), weight = FontWeight.Medium)
                return@WidgetCard
            }
            Row(modifier = GlanceModifier.fillMaxSize()) {
                Box(
                    modifier =
                        GlanceModifier.width(120.dp)
                            .fillMaxHeight()
                            .background(WidgetColors.primaryContainer)
                            .cornerRadius(16.dp),
                    contentAlignment = Alignment.Center,
                ) {
                    Label(
                        kanji.getString("character"),
                        color = WidgetColors.onPrimaryContainer,
                        size = 72.sp,
                    )
                }
                Spacer(GlanceModifier.width(16.dp))
                Column(modifier = GlanceModifier.defaultWeight().padding(vertical = 2.dp)) {
                    Label(
                        "${prefs.text("kanji_title")} · ${kanji.getString("level")}",
                        size = 11.sp,
                        weight = FontWeight.Medium,
                    )
                    Spacer(GlanceModifier.height(6.dp))
                    Label(
                        kanji.getString("meaning"),
                        color = WidgetColors.onSurface,
                        size = 17.sp,
                        weight = FontWeight.Medium,
                        maxLines = 2,
                    )
                    Spacer(GlanceModifier.height(8.dp))
                    Reading(prefs.text("kanji_on"), kanji.getString("on"), WidgetColors.onyomi)
                    Spacer(GlanceModifier.height(4.dp))
                    Reading(prefs.text("kanji_kun"), kanji.getString("kun"), WidgetColors.kunyomi)
                }
            }
        }
    }

    @Composable
    private fun Reading(label: String, value: String, color: androidx.glance.unit.ColorProvider) {
        if (value.isBlank()) return
        Row(verticalAlignment = Alignment.CenterVertically) {
            Label(label, color = color, size = 12.sp, weight = FontWeight.Medium)
            Spacer(GlanceModifier.width(8.dp))
            Label(value, color = WidgetColors.onSurface, size = 13.sp)
        }
    }
}

class KanjiWidgetReceiver : HomeWidgetGlanceWidgetReceiver<KanjiWidget>() {
    override val glanceAppWidget = KanjiWidget()
}
