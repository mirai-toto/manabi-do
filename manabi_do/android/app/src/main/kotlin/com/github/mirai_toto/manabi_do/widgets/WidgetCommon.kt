package com.github.mirai_toto.manabi_do.widgets

import android.content.Context
import android.content.SharedPreferences
import android.content.res.Configuration
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceModifier
import androidx.glance.action.Action
import androidx.glance.action.clickable
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
import es.antonborri.home_widget.actionStartActivity
import java.util.Calendar
import java.util.Locale

/** The app's light and dark tokens, as the widgets use them. */
object WidgetColors {
    val surface = ColorProvider(day = Color(0xFFFEF7FF), night = Color(0xFF211F26))
    val onSurface = ColorProvider(day = Color(0xFF1C1B1F), night = Color(0xFFE6E0E9))
    val muted = ColorProvider(day = Color(0xFF5A5560), night = Color(0xFFB5AFBC))
    val primary = ColorProvider(day = Color(0xFF6B4EFF), night = Color(0xFFCFBCFF))
    val onPrimary = ColorProvider(day = Color(0xFFFFFFFF), night = Color(0xFF2A1A5E))
    val primaryContainer = ColorProvider(day = Color(0xFFE8E0FF), night = Color(0xFF4F378B))
    val onPrimaryContainer = ColorProvider(day = Color(0xFF2A1A5E), night = Color(0xFFF2ECFF))
    val track = ColorProvider(day = Color(0xFFE7E0EC), night = Color(0xFF49454F))
    val onyomi = ColorProvider(day = Color(0xFF1565C0), night = Color(0xFF90CAF9))
    val kunyomi = ColorProvider(day = Color(0xFF7A5200), night = Color(0xFFFFBA60))
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
                .background(WidgetColors.surface)
                .cornerRadius(24.dp)
                .padding(padding)
                .clickable(onClick),
        content = content,
    )
}

@Composable
fun Label(
    text: String,
    color: ColorProvider = WidgetColors.muted,
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
