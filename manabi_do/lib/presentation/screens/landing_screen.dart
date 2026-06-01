import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';
import 'home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _continue(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: t.cardBackground,
        body: Column(
          children: [
            Expanded(child: const _Hero()),
            _AuthSection(onContinue: () => _continue(context)),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppBrandColors.heroDeep, AppBrandColors.heroMid, t.primaryLight],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '学び',
              style: AppTextStyles.jpHero.copyWith(
                color: Colors.white,
                shadows: [
                  Shadow(color: t.primary.withValues(alpha: 0.6), blurRadius: 32),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'MANABI DO',
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                letterSpacing: 3,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.tagline,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthSection extends StatelessWidget {
  final VoidCallback onContinue;

  const _AuthSection({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return Container(
      color: t.cardBackground,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceLg, AppDimens.spaceXl,
        AppDimens.spaceLg, AppDimens.spaceLg,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LandingButton(
              onPressed: onContinue,
              backgroundColor: t.cardBackground,
              foregroundColor: t.onSurface,
              side: BorderSide(color: t.outlineVariant, width: 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
                  const SizedBox(width: 10),
                  Text(l.signInWithGoogle),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _LandingButton(
              onPressed: onContinue,
              backgroundColor: AppBrandColors.appleButton,
              foregroundColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/apple.svg', width: 20, height: 20),
                  const SizedBox(width: 10),
                  Text(l.signInWithApple),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            _OrDivider(),
            const SizedBox(height: AppDimens.spaceLg),
            _LandingButton(
              onPressed: onContinue,
              backgroundColor: t.surfaceContainer,
              foregroundColor: t.onSurface,
              child: Text(l.continueAsGuest),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide? side;
  final Widget child;

  const _LandingButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.side,
    required this.child,
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

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            context.l10n.or,
            style: AppTextStyles.label.copyWith(color: t.onSurfaceVariant),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
