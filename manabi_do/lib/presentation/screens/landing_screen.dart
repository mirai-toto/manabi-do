import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/l10n.dart';
import '../widgets/common/auth_button.dart';
import '../widgets/common/landing_hero_panel.dart';
import 'home/home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _continue(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
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
            const Expanded(child: LandingHeroPanel()),
            _AuthSection(onContinue: () => _continue(context)),
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
        AppDimens.spaceLg,
        AppDimens.spaceXl,
        AppDimens.spaceLg,
        AppDimens.spaceLg,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AuthButton(
              onPressed: onContinue,
              backgroundColor: t.cardBackground,
              foregroundColor: t.onSurface,
              side: BorderSide(color: t.outlineVariant, width: 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(l.signInWithGoogle),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AuthButton(
              onPressed: onContinue,
              backgroundColor: AppBrandColors.appleButton,
              foregroundColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/apple.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(l.signInWithApple),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            _OrDivider(),
            const SizedBox(height: AppDimens.spaceLg),
            AuthButton(
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
