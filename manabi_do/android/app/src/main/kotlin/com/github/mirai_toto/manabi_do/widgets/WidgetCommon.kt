package com.github.mirai_toto.manabi_do.widgets

import android.content.Context
import android.content.SharedPreferences
import android.content.res.Configuration
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.runtime.mutableLongStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceModifier
import androidx.glance.action.Action
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.color.ColorProvider
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.ColumnScope
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.github.mirai_toto.manabi_do.MainActivity
import es.antonborri.home_widget.HomeWidgetScheduler
import es.antonborri.home_widget.actionStartActivity
import java.util.Calendar
import java.util.Locale
import org.json.JSONObject

/**
 * The colour theme picked in the app, light and dark, as the widgets use it.
 *
 * The app saves it under `theme_colours` on every sync (`_saveColours` in
 * home_widget_service.dart); until it has, the widgets draw in Fuji, the default theme.
 */
class WidgetColors private constructor(private val day: JSONObject, private val night: JSONObject) {
    private fun pair(key: String) = ColorProvider(day = color(day, key), night = color(night, key))

    val surface = pair("surface")
    val onSurface = pair("onSurface")
    val muted = pair("muted")
    val primary = pair("primary")
    val onPrimary = pair("onPrimary")
    val primaryContainer = pair("primaryContainer")
    val onPrimaryContainer = pair("onPrimaryContainer")
    val track = pair("track")

    /** The streak heatmap's four steps, empty to busiest, as raw ARGB for the bitmap. */
    fun heat(night: Boolean): IntArray {
        val steps = (if (night) this.night else day).getJSONArray("heat")
        return IntArray(steps.length()) { steps.getLong(it).toInt() }
    }

    companion object {
        // Readings mean the same thing in every theme, so they are not sent.
        val onyomi = ColorProvider(day = Color(0xFF1565C0), night = Color(0xFF90CAF9))
        val kunyomi = ColorProvider(day = Color(0xFF7A5200), night = Color(0xFFFFBA60))

        /** Dart sends unsigned ARGB, which can be past Int's range: read it as a Long. */
        private fun color(side: JSONObject, key: String) = Color(side.getLong(key).toInt())

        /** What the app sends for Fuji, so a widget placed before the first sync matches it. */
        private const val FUJI =
            """{"day":{"surface":4294899711,"onSurface":4280032031,"muted":4282991951,"primary":4285222655,"onPrimary":4294967295,"primaryContainer":4293452031,"onPrimaryContainer":4280156293,"track":4293386476,"heat":[4293715696,4290356479,4288380927,4283117521]},""" +
                """"night":{"surface":4280360742,"onSurface":4293321189,"muted":4291478736,"primary":4291804415,"onPrimary":4281867890,"primaryContainer":4283381643,"onPrimaryContainer":4293582335,"track":4282991951,"heat":[4281018672,4283515539,4287724011,4291804415]}}"""

        fun from(prefs: SharedPreferences): WidgetColors {
            val json = JSONObject(prefs.getString("theme_colours", null) ?: FUJI)
            return WidgetColors(json.getJSONObject("day"), json.getJSONObject("night"))
        }
    }
}

/** The colours of the widget being drawn, provided by [WidgetContent]. */
val LocalWidgetColors = staticCompositionLocalOf<WidgetColors> {
    error("Draw widgets inside WidgetContent")
}

/** Written last by every sync on the Dart side, so one sync is one redraw. */
private const val SYNCED_AT = "synced_at"

/**
 * Draws [content] from the app's saved snapshot, in the colour theme it saved, and draws it
 * again whenever the app finishes a sync.
 *
 * home_widget's Glance state hands a session the preferences once, when it starts, and never
 * again: an update sent while the session is still open (it stays open about 45 seconds) was
 * lost, and the widget kept its old data and colours. Listening to the preferences directly
 * does not depend on that.
 */
@Composable
fun WidgetContent(context: Context, content: @Composable (SharedPreferences) -> Unit) {
    val prefs = remember { context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE) }
    var syncedAt by remember { mutableLongStateOf(prefs.number(SYNCED_AT)) }
    DisposableEffect(prefs) {
        val listener =
            SharedPreferences.OnSharedPreferenceChangeListener { changed, key ->
                if (key == SYNCED_AT) syncedAt = changed.number(SYNCED_AT)
            }
        prefs.registerOnSharedPreferenceChangeListener(listener)
        onDispose { prefs.unregisterOnSharedPreferenceChangeListener(listener) }
    }
    key(syncedAt) {
        CompositionLocalProvider(LocalWidgetColors provides WidgetColors.from(prefs)) { content(prefs) }
    }
}

/**
 * Receiver base for the widgets: Glance's own, which updates off the main thread.
 *
 * home_widget's `HomeWidgetGlanceWidgetReceiver` wraps every update in `runBlocking` on the
 * main thread to refresh its Glance state first. The widgets read their preferences directly
 * ([WidgetContent]), so that refresh buys nothing, and the blocking froze the app long enough
 * for an "isn't responding" dialog when updates piled up. Kept from it: re-arming the scheduled
 * updates when the first widget of a kind is placed.
 */
abstract class AppWidgetReceiver : GlanceAppWidgetReceiver() {
    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        HomeWidgetScheduler.pruneAndArmNext(context, javaClass.name, catchUp = false)
    }
}

fun SharedPreferences.text(key: String): String = getString(key, null) ?: ""

/** Dart ints arrive as Int or Long depending on their size. */
fun SharedPreferences.number(key: String): Long = (all[key] as? Number)?.toLong() ?: 0L

fun isNight(context: Context): Boolean =
    context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK ==
        Configuration.UI_MODE_NIGHT_YES

/** Local date as `yyyy-mm-dd`, matching the Dart side's `reviewDayKey`. */
fun dayKey(day: Calendar): String =
    String.format(
        Locale.ROOT,
        "%04d-%02d-%02d",
        day.get(Calendar.YEAR),
        day.get(Calendar.MONTH) + 1,
        day.get(Calendar.DAY_OF_MONTH),
    )

/** Opens the app on [link], which the Dart side routes (see `ShellScreen`). */
fun openApp(context: Context, link: String): Action =
    actionStartActivity<MainActivity>(context, Uri.parse(link))

@Composable
fun WidgetCard(
    onClick: Action,
    padding: Dp = 16.dp,
    content: @Composable ColumnScope.() -> Unit,
) {
    Column(
        modifier =
            GlanceModifier.fillMaxSize()
                .background(LocalWidgetColors.current.surface)
                .cornerRadius(24.dp)
                .padding(padding)
                .clickable(onClick),
        content = content,
    )
}

@Composable
fun Label(
    text: String,
    color: ColorProvider = LocalWidgetColors.current.muted,
    size: TextUnit = 12.sp,
    weight: FontWeight = FontWeight.Normal,
    maxLines: Int = 1,
) {
    Text(
        text = text,
        maxLines = maxLines,
        style = TextStyle(color = color, fontSize = size, fontWeight = weight),
    )
}

@Composable
fun PillButton(
    text: String,
    onClick: Action,
    background: ColorProvider,
    content: ColorProvider,
) {
    Box(
        modifier =
            GlanceModifier.fillMaxWidth()
                .height(44.dp)
                .background(background)
                .cornerRadius(22.dp)
                .clickable(onClick),
        contentAlignment = Alignment.Center,
    ) {
        Label(text, color = content, size = 14.sp, weight = FontWeight.Medium)
    }
}
