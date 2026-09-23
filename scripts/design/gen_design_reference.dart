// Generates a static HTML reference for the design system by reading the theme
// source directly, so the page cannot drift from the code.
//
//   bash scripts/design/build_design_reference.sh
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
const _useCasesPath = 'lib/widgetbook.directories.g.dart';
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

/// One widgetbook use case, and the URL that renders it on its own.
class UseCase {
  final List<String> folders;
  final String component;
  final String name;
  const UseCase(this.folders, this.component, this.name);

  /// Widgetbook builds a node path by joining the names from the root, turning
  /// spaces into dashes and lowercasing. See `WidgetbookNode.path`.
  String get path => [
    ...folders,
    component,
    name,
  ].join('/').replaceAll(' ', '-').toLowerCase();
}

/// Walks the generated directories file. The node type is decided by the
/// constructor name and the nesting by indentation, which the generator always
/// formats on a 4-space ladder.
List<UseCase> parseUseCases(String src) {
  final out = <UseCase>[];
  final stack = <({int indent, String kind, String name})>[];
  final node = RegExp(
    r'^(\s*)_widgetbook\.Widgetbook(Folder|Component|LeafComponent|UseCase)\(',
  );
  final nameLine = RegExp(r"^\s*name: '([^']*)'");

  int? pendingIndent;
  String? pendingKind;

  for (final line in src.split('\n')) {
    final m = node.firstMatch(line);
    if (m != null) {
      pendingIndent = m.group(1)!.length;
      pendingKind = m.group(2)!;
      continue;
    }
    final n = nameLine.firstMatch(line);
    if (n == null || pendingKind == null) continue;

    stack.removeWhere((e) => e.indent >= pendingIndent!);
    stack.add((indent: pendingIndent!, kind: pendingKind, name: n.group(1)!));

    if (pendingKind == 'UseCase') {
      final folders = stack
          .where((e) => e.kind == 'Folder')
          .map((e) => e.name)
          .toList();
      final component = stack
          .lastWhere(
            (e) => e.kind == 'Component' || e.kind == 'LeafComponent',
            orElse: () => (indent: 0, kind: '', name: ''),
          )
          .name;
      out.add(UseCase(folders, component, n.group(1)!));
    }
    pendingKind = null;
  }
  if (out.isEmpty) throw StateError('Parsed no widgetbook use cases');
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
  final useCases = parseUseCases(_read(_useCasesPath));
  final lib = readLibSources();

  final html = buildPage(
    light: light,
    dark: dark,
    dimens: dimens,
    styles: styles,
    ramp: ramp,
    srs: srs,
    useCases: useCases,
    lib: lib,
  );

  final out = File(_outPath);
  out.parent.createSync(recursive: true);
  out.writeAsStringSync(html);

  stdout.writeln('Wrote ${out.path}');
  stdout.writeln(
    '  ${light.length} colours x 2 themes, ${dimens.length} dimensions, '
    '${styles.length} text styles, ${ramp.length} ramp colours, '
    '${useCases.length} widget use cases',
  );
  if (!Directory('${out.parent.path}/widgetbook').existsSync()) {
    stdout.writeln(
      '  ! No widgetbook build beside it — the widget previews will be blank.\n'
      '    Run scripts/design/build_design_reference.sh to build both.',
    );
  }
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
  required List<UseCase> useCases,
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
.comp { margin-bottom: 20px; }
.comp-name { font-size: 13px; font-weight: 650; margin-bottom: 8px;
             display: flex; align-items: center; gap: 8px; }
.comp-count { font-size: 10px; font-weight: 700; color: var(--muted);
              background: var(--line); padding: 0 6px; border-radius: 100px; }
.tiles { display: grid; gap: 12px;
         grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); }
.tile { margin: 0; background: var(--panel); border: 1px solid var(--line);
        border-radius: 10px; overflow: hidden; }
.frame { height: 200px; background: var(--ground); position: relative; }
.frame::after { content: "…"; position: absolute; inset: 0; display: grid;
                place-items: center; color: var(--muted); font-size: 20px; }
.frame.loaded::after { content: none; }
.frame.capped::after { content: "preview capped"; font-size: 11px; letter-spacing: .05em; }
.frame iframe { width: 100%; height: 100%; border: 0; display: block;
                position: relative; z-index: 1; }
.tile figcaption { padding: 7px 10px; border-top: 1px solid var(--line);
                   font-size: 12px; }
.tile figcaption a { color: var(--ink); text-decoration: none; }
.tile figcaption a:hover { color: var(--accent); text-decoration: underline; }
.note a { color: var(--accent); }
.ctx-pair { display: grid; gap: 16px; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); }
.ctx { border: 1px solid var(--line); border-radius: 12px; overflow: hidden; background: var(--panel); }
.ctx-label { font-size: 11px; font-weight: 650; letter-spacing: .08em; text-transform: uppercase;
             color: var(--muted); padding: 9px 14px; border-bottom: 1px solid var(--line); }
.ctx-body { padding: 16px; display: flex; flex-direction: column; gap: 12px; }
.ctx-card { border: 1px solid; border-radius: 12px; padding: 14px;
            display: flex; flex-direction: column; gap: 10px; }
.ctx-title { font-size: 16px; font-weight: 600; }
.ctx-sub { font-size: 13px; margin-top: -6px; }
.ctx-track { height: 6px; border-radius: 4px; overflow: hidden; }
.ctx-track i { display: block; height: 100%; border-radius: 4px; }
.ctx-row { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }
.ctx-btn { padding: 7px 16px; border-radius: 100px; font-size: 13px; font-weight: 600; }
.ctx-pill { padding: 3px 11px; border-radius: 100px; font-size: 11px; font-weight: 700; }
.ctx-rule { height: 1px; }
.ctx-jp { font-family: var(--jp); font-size: 14px; font-weight: 600; }
.ctx-sunk { border: 1px solid; border-radius: 10px; padding: 9px 12px;
            font-size: 11px; font-family: ui-monospace, monospace; }
.filewarn { background: color-mix(in srgb, var(--fail) 12%, transparent);
            border: 1px solid var(--fail); color: var(--ink);
            border-radius: 10px; padding: 14px 18px; margin-bottom: 20px;
            font-size: 14.5px; line-height: 1.6; }
.filewarn code { background: var(--line); padding: 1px 5px; border-radius: 4px; }
</style>
</head>
<body>
<div class="wrap">
<header>
  <h1>Manabi Do — design reference</h1>
  <p class="sub">
    Generated from source on $generated by <code>scripts/design/gen_design_reference.dart</code>.
    Do not edit by hand — rerun the tool.
    Sources: <code>app_tokens.dart</code>, <code>app_dimens.dart</code>,
    <code>app_text_styles.dart</code>, <code>jlpt_level.dart</code>,
    <code>srs_level.dart</code>.
  </p>
</header>''');

  _writeInContext(b, light, dark);
  _writeContrast(b, light, dark);
  _writeColors(b, light, dark, lib);
  _writeRamp(b, ramp, srs, light, dark);
  _writeDimens(b, dimens, lib);
  _writeType(b, styles, lib);
  _writeWidgets(b, useCases);

  b.writeln('</div>$_lazyScript</body></html>');
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

// ── Widgets ──────────────────────────────────────────────────────────────────

/// Each tile is an iframe into the real widgetbook in `preview` mode, so the
/// widget on the page is the widget the app ships — not a copy of it.
///
/// Booting 112 Flutter engines at once would sink the page, so a tile only gets
/// its `src` when it is about to come into view.
const _lazyScript = '''
<script>
(function () {
  // Opened from disk, every preview iframe would render as a directory
  // listing: file:// does not serve a folder's index.html, and Flutter cannot
  // boot from it either. Say so once, loudly, instead of 112 times quietly.
  if (location.protocol === 'file:') {
    var warn = document.createElement('div');
    warn.className = 'filewarn';
    warn.innerHTML = '<strong>Serve this over HTTP.</strong> Opened from disk ' +
      'the widget previews cannot load. From the repo root run ' +
      '<code>python3 -m http.server 8800</code> and open ' +
      '<code>http://localhost:8800/design-reference/</code>.';
    document.querySelector('.wrap').prepend(warn);
    return;
  }

  var params = new URLSearchParams(location.search);
  var theme = params.get('wb') === 'dark' ? 'Dark' : 'Light';

  // No cap by default: every preview scrolled into view eventually boots.
  // `?tiles=N` caps it, which is the way to open the page quickly when you
  // only came for the tokens — one engine costs roughly 44 MB and 3 seconds.
  var cap = params.has('tiles') ? parseInt(params.get('tiles'), 10) : Infinity;
  var booted = 0;
  document.documentElement.dataset.wb = theme.toLowerCase();
  document.querySelectorAll('[data-theme-link]').forEach(function (a) {
    a.href = location.pathname + (theme === 'Dark' ? '' : '?wb=dark');
    a.textContent = theme === 'Dark' ? 'Viewing dark' : 'Viewing light';
  });

  // Boot strictly one at a time. Each preview is a whole Flutter app, and
  // letting several start together means each one downloads its own copy of
  // canvaskit.wasm, main.dart.js and the fonts — measured at 320 MB for nine
  // tiles, because nothing is in cache yet while they all race. Serialised,
  // the first tile pays that cost once and the rest revalidate to 304.
  var queue = [];
  var busy = false;

  function pump() {
    if (busy || !queue.length) return;
    if (booted >= cap) {
      queue.splice(0).forEach(function (b) { b.classList.add('capped'); });
      return;
    }
    busy = true;
    booted++;
    var box = queue.shift();
    var frame = document.createElement('iframe');
    frame.title = box.dataset.label;
    var done = false;
    var next = function () {
      if (done) return;
      done = true;
      box.classList.add('loaded');
      busy = false;
      pump();
    };
    // `load` fires when the bundle is in; give a slow or failed boot a ceiling
    // so one bad tile cannot stall every tile behind it.
    frame.addEventListener('load', function () { setTimeout(next, 150); });
    setTimeout(next, 20000);
    frame.src = 'widgetbook/index.html#/?path=' + box.dataset.path +
                '&preview&theme=%7Bname:' + theme + '%7D';
    box.appendChild(frame);
  }

  var io = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (!e.isIntersecting) return;
      io.unobserve(e.target);
      queue.push(e.target);
      pump();
    });
  }, { rootMargin: '200px' });

  document.querySelectorAll('.frame').forEach(function (f) { io.observe(f); });
})();
</script>''';

void _writeWidgets(StringBuffer b, List<UseCase> useCases) {
  b.writeln('<h2>Widgets</h2>');
  b.writeln(
    '<p class="note">${useCases.length} use cases, rendered live from the '
    'widgetbook build sitting next to this page. These are the real widgets, '
    'not drawings of them — click a tile to open it full size with the '
    'knobs and addons panel. Previews boot one at a time as you scroll to '
    'them, because each is a whole Flutter engine — roughly 44&nbsp;MB and '
    '3&nbsp;seconds each, so give a long scroll a moment to catch up. Add '
    '<code>?tiles=3</code> to the URL to cap it when you only came for the '
    'tokens. <a data-theme-link href="#">Viewing light</a>.</p>',
  );

  // Group by folder path, then by component, preserving declaration order.
  final byFolder = <String, Map<String, List<UseCase>>>{};
  for (final u in useCases) {
    byFolder
        .putIfAbsent(u.folders.join(' › '), () => {})
        .putIfAbsent(u.component, () => [])
        .add(u);
  }

  for (final folder in byFolder.entries) {
    b.writeln('<h3>${folder.key}</h3>');
    for (final comp in folder.value.entries) {
      b.writeln(
        '<div class="comp"><div class="comp-name mono">'
        '${comp.key} <span class="comp-count">${comp.value.length}</span>'
        '</div><div class="tiles">',
      );
      for (final u in comp.value) {
        final url = 'widgetbook/index.html#/?path=${u.path}&preview';
        b.writeln('''<figure class="tile">
  <div class="frame" data-path="${u.path}" data-label="${comp.key} — ${u.name}"></div>
  <figcaption><a href="$url" target="_blank" rel="noopener">${u.name}</a></figcaption>
</figure>''');
      }
      b.writeln('</div></div>');
    }
  }
}

// ── In context ───────────────────────────────────────────────────────────────

/// Tokens composed the way the app composes them, rather than as isolated
/// swatches.
///
/// The swatch tables answer "what colour is this". They cannot answer "does
/// this work next to the thing it sits on", which is the question that actually
/// bites — a foreground reads fine alone and then disappears on its own
/// container. Both themes are drawn side by side so the comparison is direct,
/// independent of whichever theme the page itself is in.
void _writeInContext(
  StringBuffer b,
  Map<String, Rgb> light,
  Map<String, Rgb> dark,
) {
  b.writeln('<h2>In context</h2>');
  b.writeln(
    '<p class="note">The same composition in both themes, built from the '
    'tokens below. Swatches tell you what a colour is; this tells you whether '
    'it survives contact with the colours around it.</p>',
  );
  b.writeln('<div class="ctx-pair">');
  for (final e in [('Light', light), ('Dark', dark)]) {
    b.writeln(_contextPanel(e.$1, e.$2));
  }
  b.writeln('</div>');
}

String _contextPanel(String label, Map<String, Rgb> t) {
  String c(String k) => t[k]!.css;

  String pill(String fg, String bg, String text) =>
      '<span class="ctx-pill" style="color:${c(fg)};background:${c(bg)}">'
      '$text</span>';

  return '''
<div class="ctx">
  <div class="ctx-label">$label</div>
  <div class="ctx-body" style="background:${c('surface')}">
    <div class="ctx-card" style="background:${c('cardBackground')};
         border-color:${c('outlineVariant')}">
      <div class="ctx-title" style="color:${c('onSurface')}">Vocabulary</div>
      <div class="ctx-sub" style="color:${c('onSurfaceVariant')}">
        42 of 100 learned
      </div>
      <div class="ctx-track" style="background:${c('outlineVariant')}">
        <i style="background:${c('primary')};width:42%"></i>
      </div>
      <div class="ctx-row">
        <span class="ctx-btn" style="background:${c('primary')};
              color:${c('onPrimary')}">Practice</span>
        <span class="ctx-btn" style="background:${c('primaryContainer')};
              color:${c('onPrimaryContainer')}">Browse</span>
      </div>
      <div class="ctx-rule" style="background:${c('outlineVariant')}"></div>
      <div class="ctx-row">
        ${pill('error', 'errorContainer', 'Again')}
        ${pill('warning', 'warningContainer', 'Hard')}
        ${pill('success', 'successContainer', 'Good')}
        ${pill('info', 'infoContainer', 'Easy')}
      </div>
      <div class="ctx-row">
        <span class="ctx-jp" style="color:${c('onyomi')}">オン</span>
        <span class="ctx-jp" style="color:${c('kunyomi')}">くん</span>
        <span class="ctx-jp" style="color:${c('hintStroke')}">hint</span>
      </div>
    </div>
    <div class="ctx-sunk" style="background:${c('surfaceContainer')};
         border-color:${c('outlineVariant')}">
      <span style="color:${c('onSurfaceVariant')}">surfaceContainer</span>
    </div>
  </div>
</div>''';
}
