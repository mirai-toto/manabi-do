import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

/// The colour themes, as a sheet. Picking one applies it at once, and the
/// sheet stays open so the next one can be tried against the real app.
Future<void> showPalettePickerSheet(
  BuildContext context, {
  required AppPalette selected,
  required ValueChanged<AppPalette> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.tokens.surface,
    showDragHandle: true,
    builder: (_) => _PaletteSheet(selected: selected, onSelected: onSelected),
  );
}

/// Stateful because the sheet outlives the tap that changes the theme: the
/// new theme rebuilds the route's builder, which would reset a tick kept
/// there back to the theme the sheet was opened with.
class _PaletteSheet extends StatefulWidget {
  final AppPalette selected;
  final ValueChanged<AppPalette> onSelected;

  const _PaletteSheet({required this.selected, required this.onSelected});

  @override
  State<_PaletteSheet> createState() => _PaletteSheetState();
}

class _PaletteSheetState extends State<_PaletteSheet> {
  late AppPalette _current = widget.selected;

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spaceMd,
          0,
          AppDimens.spaceMd,
          AppDimens.spaceMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.settingsColourTheme,
              style: AppTextStyles.title.copyWith(color: t.onSurface),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            for (final AppPalette palette in AppPalette.values)
              _PaletteRow(
                palette: palette,
                selected: palette == _current,
                onTap: () {
                  setState(() => _current = palette);
                  widget.onSelected(palette);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _PaletteRow extends StatelessWidget {
  final AppPalette palette;
  final bool selected;
  final VoidCallback onTap;

  const _PaletteRow({
    required this.palette,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return Semantics(
      label: palette.label,
      button: true,
      selected: selected,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceSm,
            vertical: AppDimens.spaceSm,
          ),
          child: Row(
            children: [
              _Swatch(palette: palette),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Text(
                  palette.label,
                  style: AppTextStyles.body.copyWith(
                    color: t.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 20,
                color: selected ? t.primary : t.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The theme's light and dark sides next to each other: its primary on its
/// own surface, as the app would draw it.
class _Swatch extends StatelessWidget {
  final AppPalette palette;

  const _Swatch({required this.palette});

  static const double _height = 36;
  static const double _halfWidth = 28;
  static const double _dot = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.tokens.outlineVariant),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final AppTokens side in [palette.light, palette.dark])
            Container(
              width: _halfWidth,
              height: _height,
              color: side.surface,
              alignment: Alignment.center,
              child: Container(
                width: _dot,
                height: _dot,
                decoration: BoxDecoration(
                  color: side.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
