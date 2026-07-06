import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import 'text_block.dart';

enum ListStyle { bullet, numbered }

class ListBlock extends StatelessWidget {
  final ListStyle style;
  final List<String> items;
  final Color? accentColor;

  const ListBlock({
    super.key,
    required this.style,
    required this.items,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final base = AppTextStyles.body.copyWith(color: t.onSurface);
    final prefixStyle = AppTextStyles.body.copyWith(
      color: accentColor ?? t.onSurfaceVariant,
      fontWeight: FontWeight.w700,
    );
    final prefixWidth = style == ListStyle.numbered ? 28.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        final prefix = style == ListStyle.bullet ? '•' : '${i + 1}.';

        return Padding(
          padding: EdgeInsets.only(
            bottom: i < items.length - 1 ? AppDimens.spaceXs : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: prefixWidth,
                child: Text(prefix, style: prefixStyle),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(children: TextBlock.buildSpans(item, base)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
