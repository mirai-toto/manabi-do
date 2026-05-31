import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(child: _Hero()),
            _AuthSection(onContinue: () => _continue(context)),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D0630), Color(0xFF3D1FCC), Color(0xFF9B7FFF)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '学び',
              style: GoogleFonts.notoSansJp(
                fontSize: 96,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.0,
                shadows: [
                  Shadow(
                    color: const Color(0xFF6B4EFF).withOpacity(0.6),
                    blurRadius: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'MANABI DO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Learn Japanese — offline, at your pace',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.45),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LandingButton(
              onPressed: onContinue,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F1F1F),
              side: const BorderSide(color: Color(0xFFDADCE0), width: 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
                  const SizedBox(width: 10),
                  const Text('Sign in with Google'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _LandingButton(
              onPressed: onContinue,
              backgroundColor: const Color(0xFF1C1C1E),
              foregroundColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/apple.svg', width: 20, height: 20),
                  const SizedBox(width: 10),
                  const Text('Sign in with Apple'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _OrDivider(),
            const SizedBox(height: 20),
            _LandingButton(
              onPressed: onContinue,
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.onSurface,
              child: const Text('Continue as guest →'),
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: side ?? BorderSide.none,
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        child: child,
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

