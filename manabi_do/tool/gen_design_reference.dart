// Generates a static HTML reference for the design system by reading the theme
// source directly, so the page cannot drift from the code.
//
//   dart run tool/gen_design_reference.dart
//
// Writes ../design-reference/index.html, which is gitignored: it is derived
// output, and a folder with an index is what a Pages deploy wants later.
// Run it after touching anything under lib/core/theme/ or lib/core/srs/.
//
// The page is deliberately more than documentation: it computes contrast ratios
// against WCAG AA, groups dimensions by the number they hold so duplicate names
// cannot hide, and cross-references every token against lib/ so dead entries
// show up. Those are the things reading the Dart file will not tell you.

import 'dart:io';
import 'dart:math' as math;

// ── Paths ────────────────────────────────────────────────────────────────────

const _tokensPath = 'lib/core/theme/app_tokens.dart';
const _dimensPath = 'lib/core/theme/app_dimens.dart';
const _stylesPath = 'lib/core/theme/app_text_styles.dart';
const _jlptPath = 'lib/core/theme/jlpt_level.dart';
const _srsPath = 'lib/core/srs/srs_level.dart';
const _outPath = '../design-reference/index.html';

/// Where the page reaches for the real typefaces, relative to [_outPath].
const _fontDir = '../manabi_do/assets/fonts';

// ── Model ────────────────────────────────────────────────────────────────────

class Rgb {
  final int r, g, b;
  final double a;
  const Rgb(this.r, this.g, this.b, [this.a = 1]);

  static Rgb parse(String hex) {
    final v = int.parse(hex, radix: 16);
    if (hex.length == 8) {
      return Rgb(
        (v >> 16) & 0xFF,
        (v >> 8) & 0xFF,
        v & 0xFF,
        ((v >> 24) & 0xFF) / 255,
      );
    }
    return Rgb((v >> 16) & 0xFF, (v >> 8) & 0xFF, v & 0xFF);
  }

  String get css => 'rgb($r $g $b)';
  String get hex =>
      '#${r.toRadixString(16).padLeft(2, '0')}'
              '${g.toRadixString(16).padLeft(2, '0')}'
              '${b.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();

  /// This colour at [alpha] laid over [bg], which is what the app does for
  /// state pills (`color.withValues(alpha: 0.12)`).
  Rgb over(Rgb bg, double alpha) => Rgb(
    (r * alpha + bg.r * (1 - alpha)).round(),
    (g * alpha + bg.g * (1 - alpha)).round(),
    (b * alpha + bg.b * (1 - alpha)).round(),
  );

  double get luminance {
    double ch(int v) {
      final s = v / 255;
      return s <= 0.03928
          ? s / 12.92
          : math.pow((s + 0.055) / 1.055, 2.4).toDouble();
    }

    return 0.2126 * ch(r) + 0.7152 * ch(g) + 0.0722 * ch(b);
  }
}

double contrast(Rgb a, Rgb b) {
  final la = a.luminance, lb = b.luminance;
  final hi = math.max(la, lb), lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

class TextStyleSpec {
  final String name, family;
  final double size;
  final int weight;
  final double? height, letterSpacing;
  const TextStyleSpec(
    this.name,
    this.family,
    this.size,
    this.weight,
    this.height,
    this.letterSpacing,
  );
}

// ── Parsing ──────────────────────────────────────────────────────────────────

String _read(String path) {
  final f = File(path);
  if (!f.existsSync()) {
    stderr.writeln(
      'Cannot find $path. Run this from the manabi_do/ directory.',
    );
    exit(1);
  }
  return f.readAsStringSync();
}

/// Pulls one `static const <name> = AppTokens( ... );` block out of the tokens
/// file and returns the colour for each field in it.
Map<String, Rgb> parseTheme(String src, String name) {
  final start = src.indexOf('static const $name = AppTokens(');
  if (start < 0) throw StateError('No AppTokens block named "$name"');
  final end = src.indexOf(');', start);
  final block = src.substring(start, end);
  final out = <String, Rgb>{};
  for (final m in RegExp(
    r'(\w+):\s*Color\(0x([0-9A-Fa-f]{8})\)',
  ).allMatches(block)) {
    out[m.group(1)!] = Rgb.parse(m.group(2)!);
  }
  if (out.isEmpty) throw StateError('Parsed no colours from "$name"');
  return out;
}

Map<String, double> parseDimens(String src) {
  final out = <String, double>{};
  for (final m in RegExp(
    r'static const double (\w+) = ([\d.]+);',
  ).allMatches(src)) {
    out[m.group(1)!] = double.parse(m.group(2)!);
  }
  if (out.isEmpty) throw StateError('Parsed no dimensions');
  return out;
}

List<TextStyleSpec> parseTextStyles(String src) {
  final out = <TextStyleSpec>[];
  final re = RegExp(
    r'static TextStyle get (\w+) =>\s*const TextStyle\(([^;]*?)\);',
    dotAll: true,
  );
  for (final m in re.allMatches(src)) {
    final body = m.group(2)!;
    double? num_(String key) {
      final v = RegExp('$key:\\s*([\\d.]+)').firstMatch(body);
      return v == null ? null : double.parse(v.group(1)!);
    }

    out.add(
      TextStyleSpec(
        m.group(1)!,
        RegExp(r"fontFamily: '([^']+)'").firstMatch(body)?.group(1) ??
            'inherit',
        num_('fontSize') ?? 14,
        int.tryParse(
              RegExp(r'FontWeight\.w(\d+)').firstMatch(body)?.group(1) ?? '400',
            ) ??
            400,
        num_('height'),
        num_('letterSpacing'),
      ),
    );
  }
  if (out.isEmpty) throw StateError('Parsed no text styles');
  return out;
}

Map<String, Rgb> parseRamp(String src) {
  final out = <String, Rgb>{};
  for (final m in RegExp(
    r"'(\w+)' => const Color\(0x([0-9A-Fa-f]{8})\)",
  ).allMatches(src)) {
    out[m.group(1)!] = Rgb.parse(m.group(2)!);
  }
  if (out.isEmpty) throw StateError('Parsed no ramp colours');
  return out;
}

/// Maps each `SrsLevel` to the ramp entry it borrows, per `srs_level.dart`.
Map<String, String> parseSrsLevels(String src) {
  final out = <String, String>{};
  for (final m in RegExp(
    r"SrsLevel\.(\w+) => levelColor\('(\w+)'\)",
  ).allMatches(src)) {
    out[m.group(1)!] = m.group(2)!;
  }
  return out;
}

// ── Usage counting ───────────────────────────────────────────────────────────

/// Every `.dart` file under lib/, excluding generated output and the tool
/// itself, concatenated so tokens can be counted against real code.
String readLibSources() {
  final sb = StringBuffer();
  for (final e in Directory('lib').listSync(recursive: true)) {
    if (e is! File || !e.path.endsWith('.dart')) continue;
    if (e.path.endsWith('.g.dart')) continue;
    sb.writeln(e.readAsStringSync());
  }
  return sb.toString();
}

int countAll(String haystack, List<RegExp> patterns) =>
    patterns.fold(0, (n, re) => n + re.allMatches(haystack).length);

int countDimen(String lib, String name) =>
    countAll(lib, [RegExp('AppDimens\\.$name\\b')]);

int countColor(String lib, String name) => countAll(lib, [
  RegExp('\\bt\\.$name\\b'),
  RegExp('\\btokens\\.$name\\b'),
  RegExp('\\bcolors\\.$name\\b'),
]);

int countStyle(String lib, String name) =>
    countAll(lib, [RegExp('AppTextStyles\\.$name\\b')]);

// ── Main ─────────────────────────────────────────────────────────────────────

void main() {
  final tokensSrc = _read(_tokensPath);
  final light = parseTheme(tokensSrc, 'light');
  final dark = parseTheme(tokensSrc, 'dark');
  final dimens = parseDimens(_read(_dimensPath));
  final styles = parseTextStyles(_read(_stylesPath));
  final ramp = parseRamp(_read(_jlptPath));
  final srs = parseSrsLevels(_read(_srsPath));
  final lib = readLibSources();

  final html = buildPage(
    light: light,
    dark: dark,
    dimens: dimens,
    styles: styles,
    ramp: ramp,
    srs: srs,
    lib: lib,
  );

  final out = File(_outPath);
  out.parent.createSync(recursive: true);
  out.writeAsStringSync(html);

  stdout.writeln('Wrote ${out.path}');
  stdout.writeln(
    '  ${light.length} colours x 2 themes, ${dimens.length} dimensions, '
    '${styles.length} text styles, ${ramp.length} ramp colours',
  );
}

// ── Page ─────────────────────────────────────────────────────────────────────

/// The foreground/background pairs the app actually puts together. Contrast is
/// only meaningful for combinations that really occur.
const _pairs = <List<String>>[
  ['onSurface', 'surface'],
  ['onSurfaceVariant', 'surface'],
  ['onSurface', 'cardBackground'],
  ['onSurfaceVariant', 'cardBackground'],
  ['onPrimary', 'primary'],
  ['onPrimaryContainer', 'primaryContainer'],
  ['onSecondary', 'secondary'],
  ['onSecondaryContainer', 'secondaryContainer'],
  ['error', 'errorContainer'],
  ['success', 'successContainer'],
  ['warning', 'warningContainer'],
  ['info', 'infoContainer'],
];

String _grade(double ratio) {
  if (ratio >= 7) return 'AAA';
  if (ratio >= 4.5) return 'AA';
  if (ratio >= 3) return 'AA large';
  return 'fail';
}

String _gradeClass(double ratio) {
  if (ratio >= 4.5) return 'pass';
  if (ratio >= 3) return 'warn';
  return 'fail';
}

String buildPage({
  required Map<String, Rgb> light,
  required Map<String, Rgb> dark,
  required Map<String, double> dimens,
  required List<TextStyleSpec> styles,
  required Map<String, Rgb> ramp,
  required Map<String, String> srs,
  required String lib,
}) {
  final b = StringBuffer();
  final generated = DateTime.now().toIso8601String().split('.').first;

  b.writeln('''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Manabi Do — design reference</title>
<style>
@font-face {
  font-family: "InterLocal";
  src: url("$_fontDir/Inter%5Bopsz,wght%5D.ttf") format("truetype-variations");
  font-weight: 100 900;
}
@font-face {
  font-family: "NotoSansJPLocal";
  src: url("$_fontDir/NotoSansJP%5Bwght%5D.ttf") format("truetype-variations");
  font-weight: 100 900;
}
:root {
  --ground: #faf9fc; --panel: #fff; --ink: #17151c; --muted: #5d5768;
  --line: #e4e0ea; --accent: #6b4eff;
  --pass: #146b3a; --warn: #7a5200; --fail: #b3261e;
}
@media (prefers-color-scheme: dark) {
  :root {
    --ground: #0f0e13; --panel: #18161d; --ink: #e9e6ef; --muted: #a29bb0;
    --line: #29252f; --accent: #cfbcff;
    --pass: #6cdfab; --warn: #ffba60; --fail: #f2b8b5;
  }
}
* { box-sizing: border-box; }
body {
  margin: 0; background: var(--ground); color: var(--ink);
  font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  font-size: 15px; line-height: 1.55;
}
.wrap { max-width: 1160px; margin: 0 auto; padding: 48px 20px 96px; }
header { border-bottom: 1px solid var(--line); padding-bottom: 20px; margin-bottom: 8px; }
h1 { margin: 0 0 6px; font-size: 30px; letter-spacing: -.02em; }
.sub { color: var(--muted); font-size: 14px; margin: 0; }
.sub code { background: var(--line); padding: 1px 5px; border-radius: 4px; font-size: .9em; }
h2 {
  margin: 44px 0 4px; font-size: 20px; letter-spacing: -.015em;
  padding-top: 20px; border-top: 1px solid var(--line);
}
h2:first-of-type { border-top: 0; }
h3 { margin: 26px 0 8px; font-size: 13px; text-transform: uppercase;
     letter-spacing: .08em; color: var(--muted); font-weight: 650; }
.note { color: var(--muted); font-size: 14px; margin: 0 0 14px; max-width: 74ch; }
.scroll { overflow-x: auto; }
table { border-collapse: collapse; width: 100%; font-size: 14px; background: var(--panel);
        border: 1px solid var(--line); border-radius: 10px; overflow: hidden; }
th, td { text-align: left; padding: 8px 12px; border-bottom: 1px solid var(--line); white-space: nowrap; }
tr:last-child td { border-bottom: 0; }
th { font-size: 11px; text-transform: uppercase; letter-spacing: .07em;
     color: var(--muted); font-weight: 650; }
td.num, th.num { text-align: right; font-variant-numeric: tabular-nums; }
code, .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
.sw { width: 30px; height: 30px; border-radius: 7px; border: 1px solid var(--line);
      display: inline-block; vertical-align: middle; }
.badge { display: inline-block; padding: 1px 8px; border-radius: 100px;
         font-size: 11px; font-weight: 700; letter-spacing: .03em; }
.pass { color: var(--pass); background: color-mix(in srgb, var(--pass) 14%, transparent); }
.warn { color: var(--warn); background: color-mix(in srgb, var(--warn) 14%, transparent); }
.fail { color: var(--fail); background: color-mix(in srgb, var(--fail) 16%, transparent); }
.zero { color: var(--fail); font-weight: 650; }
.dup  { color: var(--warn); font-weight: 650; }
.bar { height: 14px; border-radius: 3px; background: var(--accent); display: inline-block; vertical-align: middle; }
.rbox { width: 68px; height: 46px; background: color-mix(in srgb, var(--accent) 18%, transparent);
        border: 1.5px solid var(--accent); display: inline-block; }
.spec { background: var(--panel); border: 1px solid var(--line); border-radius: 10px;
        padding: 12px 16px; margin-bottom: 8px; }
.spec .meta { color: var(--muted); font-size: 11.5px; letter-spacing: .04em;
              text-transform: uppercase; margin-bottom: 4px; }
.pair { display: flex; gap: 0; border-radius: 7px; overflow: hidden; width: 116px;
        border: 1px solid var(--line); }
.pair span { flex: 1; height: 30px; }
.chip-demo { display: inline-block; padding: 3px 10px; border-radius: 100px;
             font-size: 11px; font-weight: 700; }
</style>
</head>
<body>
<div class="wrap">
<header>
  <h1>Manabi Do — design reference</h1>
  <p class="sub">
    Generated from source on $generated by <code>tool/gen_design_reference.dart</code>.
    Do not edit by hand — rerun the tool.
    Sources: <code>app_tokens.dart</code>, <code>app_dimens.dart</code>,
    <code>app_text_styles.dart</code>, <code>jlpt_level.dart</code>,
    <code>srs_level.dart</code>.
  </p>
</header>''');

  _writeContrast(b, light, dark);
  _writeColors(b, light, dark, lib);
  _writeRamp(b, ramp, srs, light, dark);
  _writeDimens(b, dimens, lib);
  _writeType(b, styles, lib);

  b.writeln('</div></body></html>');
  return b.toString();
}

// ── Contrast ─────────────────────────────────────────────────────────────────

void _writeContrast(
  StringBuffer b,
  Map<String, Rgb> light,
  Map<String, Rgb> dark,
) {
  b.writeln('<h2>Contrast</h2>');
  b.writeln(
    '<p class="note">WCAG AA needs 4.5:1 for body text and 3:1 for large text. '
    'Only pairs the app actually puts together are listed.</p>',
  );
  b.writeln(
    '<div class="scroll"><table><tr>'
    '<th>Foreground on background</th>'
    '<th>Light</th><th class="num">Ratio</th><th>Grade</th>'
    '<th>Dark</th><th class="num">Ratio</th><th>Grade</th></tr>',
  );

  for (final p in _pairs) {
    final fg = p[0], bg = p[1];
    if (!light.containsKey(fg) || !light.containsKey(bg)) continue;
    final lr = contrast(light[fg]!, light[bg]!);
    final dr = contrast(dark[fg]!, dark[bg]!);
    b.writeln(
      '<tr><td class="mono">$fg / $bg</td>'
      '<td>${_pairSwatch(light[fg]!, light[bg]!)}</td>'
      '<td class="num">${lr.toStringAsFixed(2)}</td>'
      '<td><span class="badge ${_gradeClass(lr)}">${_grade(lr)}</span></td>'
      '<td>${_pairSwatch(dark[fg]!, dark[bg]!)}</td>'
      '<td class="num">${dr.toStringAsFixed(2)}</td>'
      '<td><span class="badge ${_gradeClass(dr)}">${_grade(dr)}</span></td></tr>',
    );
  }
  b.writeln('</table></div>');
}

String _pairSwatch(Rgb fg, Rgb bg) =>
    '<span class="pair"><span style="background:${bg.css}"></span>'
    '<span style="background:${fg.css}"></span></span>';

// ── Colours ──────────────────────────────────────────────────────────────────

void _writeColors(
  StringBuffer b,
  Map<String, Rgb> light,
  Map<String, Rgb> dark,
  String lib,
) {
  b.writeln('<h2>Colour tokens</h2>');
  b.writeln(
    '<p class="note">Read through <code>context.tokens</code>. A count of zero '
    'means nothing in <code>lib/</code> references it.</p>',
  );
  b.writeln(
    '<div class="scroll"><table><tr>'
    '<th>Token</th><th>Light</th><th>Hex</th><th>Dark</th><th>Hex</th>'
    '<th class="num">Uses</th></tr>',
  );

  for (final name in light.keys) {
    final uses = countColor(lib, name);
    b.writeln(
      '<tr><td class="mono">$name</td>'
      '<td><span class="sw" style="background:${light[name]!.css}"></span></td>'
      '<td class="mono">${light[name]!.hex}</td>'
      '<td><span class="sw" style="background:${dark[name]!.css}"></span></td>'
      '<td class="mono">${dark[name]!.hex}</td>'
      '<td class="num${uses == 0 ? ' zero' : ''}">$uses</td></tr>',
    );
  }
  b.writeln('</table></div>');
}

// ── Ramp and mastery pills ───────────────────────────────────────────────────

void _writeRamp(
  StringBuffer b,
  Map<String, Rgb> ramp,
  Map<String, String> srs,
  Map<String, Rgb> light,
  Map<String, Rgb> dark,
) {
  b.writeln('<h2>Difficulty ramp and mastery pills</h2>');
  b.writeln(
    '<p class="note">The ramp is theme-invariant: the same hue in light and '
    'dark. Mastery reuses it backwards, so a pill\'s colour is a ramp entry '
    'drawn at 12% over the card. That composite is what the contrast column '
    'measures, which is why these are the worst offenders in the app.</p>',
  );
  b.writeln(
    '<div class="scroll"><table><tr>'
    '<th>Ramp</th><th>Colour</th><th>Hex</th><th>Mastery level</th>'
    '<th>Pill on light</th><th class="num">Ratio</th><th>Grade</th>'
    '<th>Pill on dark</th><th class="num">Ratio</th><th>Grade</th></tr>',
  );

  final reverse = <String, String>{};
  srs.forEach((level, key) => reverse[key] = level);

  for (final e in ramp.entries) {
    final c = e.value;
    final level = reverse[e.key] ?? '—';
    final lBg = c.over(light['cardBackground']!, 0.12);
    final dBg = c.over(dark['cardBackground']!, 0.12);
    final lr = contrast(c, lBg);
    final dr = contrast(c, dBg);
    final hasPill = reverse.containsKey(e.key);
    b.writeln(
      '<tr><td class="mono">${e.key}</td>'
      '<td><span class="sw" style="background:${c.css}"></span></td>'
      '<td class="mono">${c.hex}</td>'
      '<td class="mono">$level</td>'
      '${hasPill ? '<td><span class="chip-demo" style="color:${c.css};background:${lBg.css}">$level</span></td>'
                '<td class="num">${lr.toStringAsFixed(2)}</td>'
                '<td><span class="badge ${_gradeClass(lr)}">${_grade(lr)}</span></td>'
                '<td><span class="chip-demo" style="color:${c.css};background:${dBg.css}">$level</span></td>'
                '<td class="num">${dr.toStringAsFixed(2)}</td>'
                '<td><span class="badge ${_gradeClass(dr)}">${_grade(dr)}</span></td>' : '<td colspan="6" style="color:var(--muted)">not used as a pill</td>'}'
      '</tr>',
    );
  }
  b.writeln('</table></div>');
}

// ── Dimensions ───────────────────────────────────────────────────────────────

void _writeDimens(StringBuffer b, Map<String, double> dimens, String lib) {
  final spacing = <String, double>{};
  final radius = <String, double>{};
  final other = <String, double>{};
  dimens.forEach((k, v) {
    if (k.startsWith('radius')) {
      radius[k] = v;
    } else if (k.startsWith('space')) {
      spacing[k] = v;
    } else {
      other[k] = v;
    }
  });

  // Group by value so two names for one number cannot hide.
  final byValue = <double, List<String>>{};
  for (final e in {...spacing, ...other}.entries) {
    byValue.putIfAbsent(e.value, () => []).add(e.key);
  }
  final dups = byValue.entries.where((e) => e.value.length > 1).toList();

  b.writeln('<h2>Dimensions</h2>');
  b.writeln(
    '<p class="note">${dimens.length} constants. A name holding the same number '
    'as another is flagged: sharing a value is not the same as sharing a '
    'meaning, and the duplicate is usually a collision rather than an '
    'agreement.</p>',
  );

  if (dups.isEmpty) {
    b.writeln(
      '<p class="note"><span class="badge pass">no duplicate values</span></p>',
    );
  } else {
    b.writeln(
      '<h3>Names sharing a value</h3><div class="scroll"><table>'
      '<tr><th class="num">Value</th><th>Names</th></tr>',
    );
    dups.sort((a, c) => a.key.compareTo(c.key));
    for (final d in dups) {
      b.writeln(
        '<tr><td class="num dup">${_fmt(d.key)}</td>'
        '<td class="mono">${d.value.join(', ')}</td></tr>',
      );
    }
    b.writeln('</table></div>');
  }

  for (final group in [
    ('Spacing', spacing),
    ('Radius', radius),
    ('Other', other),
  ]) {
    if (group.$2.isEmpty) continue;
    b.writeln(
      '<h3>${group.$1}</h3><div class="scroll"><table>'
      '<tr><th>Name</th><th class="num">Value</th><th>Scale</th>'
      '<th class="num">Uses</th></tr>',
    );
    final sorted = group.$2.entries.toList()
      ..sort((a, c) => a.value.compareTo(c.value));
    for (final e in sorted) {
      final uses = countDimen(lib, e.key);
      final visual = group.$1 == 'Radius'
          ? '<span class="rbox" style="border-radius:${e.value}px"></span>'
          : '<span class="bar" style="width:${math.min(e.value, 320)}px"></span>';
      b.writeln(
        '<tr><td class="mono">${e.key}</td>'
        '<td class="num">${_fmt(e.value)}</td>'
        '<td>$visual</td>'
        '<td class="num${uses == 0 ? ' zero' : ''}">$uses</td></tr>',
      );
    }
    b.writeln('</table></div>');
  }
}

String _fmt(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

// ── Type ─────────────────────────────────────────────────────────────────────

void _writeType(StringBuffer b, List<TextStyleSpec> styles, String lib) {
  b.writeln('<h2>Type</h2>');
  b.writeln(
    '<p class="note">Rendered with the bundled typefaces loaded straight from '
    '<code>assets/fonts/</code>, so the specimens are the real thing. Japanese '
    'styles are set in Japanese.</p>',
  );

  for (final s in styles) {
    final jp = s.family == 'NotoSansJP';
    final fam = switch (s.family) {
      'NotoSansJP' => 'NotoSansJPLocal, sans-serif',
      'Inter' => 'InterLocal, system-ui, sans-serif',
      _ => 'ui-monospace, monospace',
    };
    final sample = jp ? '日本語を学ぶ' : 'The quick brown fox';
    final uses = countStyle(lib, s.name);
    final meta = [
      s.family,
      '${_fmt(s.size)}px',
      'w${s.weight}',
      if (s.height != null) 'height ${s.height}',
      if (s.letterSpacing != null) 'tracking ${s.letterSpacing}',
      '$uses ${uses == 1 ? 'use' : 'uses'}',
    ].join('  ·  ');
    final cap = math.min(s.size, 56.0);
    b.writeln('''<div class="spec">
  <div class="meta mono">${s.name}  —  $meta</div>
  <div style="font-family:$fam;font-size:${cap}px;font-weight:${s.weight};
              line-height:${s.height ?? 1.3};
              letter-spacing:${s.letterSpacing ?? 0}px">$sample</div>
</div>''');
  }
}
