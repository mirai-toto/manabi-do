import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'progress_bar.dart';

enum AppSection { grammar, characters, vocabulary }

class SectionCard extends StatelessWidget {
  final AppSection section;
  final String subtitle;
  final String statLabel;
  final double progress;
  final VoidCallback? onTap;

  const SectionCard({
    super.key,
    required this.section,
    required this.subtitle,
    required this.statLabel,
    required this.progress,
    this.onTap,
  });

  String get _title => switch (section) {
    AppSection.grammar    => 'Grammar',
    AppSection.characters => 'Characters',
    AppSection.vocabulary => 'Vocabulary',
  };

  String get _kanji => switch (section) {
    AppSection.grammar    => '文',
    AppSection.characters => '字',
    AppSection.vocabulary => '語',
  };

  List<Color> get _gradientColors => switch (section) {
    AppSection.grammar    => const [Color(0xFF6B4EFF), Color(0xFF9B7FFF)],
    AppSection.characters => const [Color(0xFF0D47A1), Color(0xFF1976D2)],
    AppSection.vocabulary => const [Color(0xFF1B5E20), Color(0xFF388E3C)],
  };

  Color get _progressColor => switch (section) {
    AppSection.grammar    => AppColors.primary,
    AppSection.characters => const Color(0xFF1976D2),
    AppSection.vocabulary => const Color(0xFF388E3C),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: _gradientColors,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _title,
                          style: AppTextStyles.title.copyWith(fontSize: 22, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _kanji,
                    style: GoogleFonts.notoSansJp(fontSize: 48, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      statLabel,
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppProgressBar(progress: progress, color: _progressColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
