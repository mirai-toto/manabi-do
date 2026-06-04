import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hint;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.hint,
    this.enabled = true,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        borderSide: BorderSide(color: color, width: 1.5),
      );

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      style: AppTextStyles.body.copyWith(color: t.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
        labelStyle: AppTextStyles.labelLarge.copyWith(color: t.onSurfaceVariant),
        floatingLabelStyle: AppTextStyles.labelSmall.copyWith(
          color: t.primary,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: t.cardBackground,
        border:         _border(t.outlineVariant),
        enabledBorder:  _border(t.outlineVariant),
        focusedBorder:  _border(t.primary),
        disabledBorder: _border(t.outlineVariant.withValues(alpha: 0.5)),
      ),
    );
  }
}
