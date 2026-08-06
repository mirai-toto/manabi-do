import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide? side;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.foregroundColor,
    this.side,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            side: side ?? BorderSide.none,
          ),
          textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
        child: child,
      ),
    );
  }
}
