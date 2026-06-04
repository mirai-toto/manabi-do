import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

const languages = [
  (code: 'en', flag: '🇬🇧', name: 'English'),
  (code: 'fr', flag: '🇫🇷', name: 'Français'),
  (code: 'de', flag: '🇩🇪', name: 'Deutsch'),
];

class LanguagePickerSheet extends StatelessWidget {
  final String currentCode;
  final void Function(String code) onSelect;
  final String title;

  const LanguagePickerSheet({
    super.key,
    required this.currentCode,
    required this.onSelect,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: t.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: AppTextStyles.title.copyWith(color: t.onSurface)),
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            for (final lang in languages)
              InkWell(
                onTap: () => onSelect(lang.code),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMd,
                    vertical: AppDimens.spaceMd,
                  ),
                  child: Row(
                    children: [
                      Text(
                        lang.flag,
                        style: const TextStyle(fontSize: 28, fontFamily: 'NotoColorEmoji'),
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      Expanded(
                        child: Text(
                          lang.name,
                          style: AppTextStyles.body.copyWith(
                            color: lang.code == currentCode ? t.primary : t.onSurface,
                            fontWeight: lang.code == currentCode ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (lang.code == currentCode)
                        Icon(Icons.check_rounded, size: 20, color: t.primary),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
