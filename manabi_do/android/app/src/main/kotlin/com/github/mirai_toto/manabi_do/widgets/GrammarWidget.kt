package com.github.mirai_toto.manabi_do.widgets

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.LinearProgressIndicator
import androidx.glance.appwidget.provideContent
import androidx.glance.currentState
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.text.FontWeight
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

/** The grammar lesson the home screen would resume. */
class GrammarWidget : GlanceAppWidget() {
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
        val open = openApp(context, "manabido://grammar")
        val title = prefs.text("grammar_title")
        val level = prefs.text("grammar_level")

        WidgetCard(onClick = open) {
            Label(
                if (level.isEmpty()) prefs.text("grammar_heading")
                else "${prefs.text("grammar_heading")} · $level",
                size = 11.sp,
                weight = FontWeight.Medium,
            )
            Spacer(GlanceModifier.height(6.dp))
            if (title.isEmpty()) {
                Label(prefs.text("grammar_done"), color = WidgetColors.onSurface, size = 16.sp)
                return@WidgetCard
            }
            Label(
                title,
                color = WidgetColors.primary,
                size = 18.sp,
                weight = FontWeight.Bold,
                maxLines = 3,
            )
            Spacer(GlanceModifier.defaultWeight())
            val total = prefs.number("grammar_total").coerceAtLeast(1)
            LinearProgressIndicator(
                progress = (prefs.number("grammar_index") + 1).toFloat() / total,
                modifier = GlanceModifier.fillMaxWidth().height(6.dp),
                color = WidgetColors.primary,
                backgroundColor = WidgetColors.track,
            )
            Spacer(GlanceModifier.height(4.dp))
            Label(prefs.text("grammar_progress"))
            Spacer(GlanceModifier.height(8.dp))
            PillButton(
                text = prefs.text("grammar_button"),
                onClick = open,
                background = WidgetColors.primaryContainer,
                content = WidgetColors.onPrimaryContainer,
            )
        }
    }
}

class GrammarWidgetReceiver : HomeWidgetGlanceWidgetReceiver<GrammarWidget>() {
    override val glanceAppWidget = GrammarWidget()
}
