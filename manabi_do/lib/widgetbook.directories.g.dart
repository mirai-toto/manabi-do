// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:manabi_do/widgetbook/characters_use_cases.dart'
    as _manabi_do_widgetbook_characters_use_cases;
import 'package:manabi_do/widgetbook/common_use_cases.dart'
    as _manabi_do_widgetbook_common_use_cases;
import 'package:manabi_do/widgetbook/exercise_use_cases.dart'
    as _manabi_do_widgetbook_exercise_use_cases;
import 'package:manabi_do/widgetbook/grammar_use_cases.dart'
    as _manabi_do_widgetbook_grammar_use_cases;
import 'package:manabi_do/widgetbook/navigation_use_cases.dart'
    as _manabi_do_widgetbook_navigation_use_cases;
import 'package:manabi_do/widgetbook/settings_use_cases.dart'
    as _manabi_do_widgetbook_settings_use_cases;
import 'package:manabi_do/widgetbook/study_use_cases.dart'
    as _manabi_do_widgetbook_study_use_cases;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'Characters',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'CharacterCell',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Accent color',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildCharacterCellAccent,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Known',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildCharacterCellKnown,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Unknown',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildCharacterCellUnknown,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'KanjiDrawingCanvas',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildKanjiDrawingCanvas,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'With reference ghost',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildKanjiDrawingCanvasWithGhost,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'With stroke results',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildKanjiDrawingCanvasWithResults,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'StrokeOrderAnimator',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildStrokeOrderAnimator,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Large',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildStrokeOrderAnimatorLarge,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'StrokeStepRow',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _manabi_do_widgetbook_characters_use_cases.buildStrokeStepRow,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'UserStrokeAnimator',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_characters_use_cases
                .buildUserStrokeAnimator,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'Common',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'AppButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Danger',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildAppButtonDanger,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Disabled',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildAppButtonDisabled,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Filled',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildAppButtonFilled,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Outlined',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildAppButtonOutlined,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Small',
            builder: _manabi_do_widgetbook_common_use_cases.buildAppButtonSmall,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Text',
            builder: _manabi_do_widgetbook_common_use_cases.buildAppButtonText,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Tonal',
            builder: _manabi_do_widgetbook_common_use_cases.buildAppButtonTonal,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AppEmoji',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_common_use_cases.buildAppEmoji,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AppFilterChip',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Active',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildAppFilterChipActive,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Disabled',
            builder: _manabi_do_widgetbook_common_use_cases
                .buildAppFilterChipDisabled,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Inactive',
            builder: _manabi_do_widgetbook_common_use_cases
                .buildAppFilterChipInactive,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AppProgressBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: '0%',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildProgressBarEmpty,
          ),
          _widgetbook.WidgetbookUseCase(
            name: '100%',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildProgressBarFull,
          ),
          _widgetbook.WidgetbookUseCase(
            name: '60%',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildProgressBarHalf,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AppTextField',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Empty',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildAppTextFieldEmpty,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'With icons',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildAppTextFieldIcons,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'CardContainer',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_common_use_cases
                .buildCardContainerDefault,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'ChapterListView',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildChapterListView,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'DifficultyDots',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Empty',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildDifficultyDotsEmpty,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Full',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildDifficultyDotsFull,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Half',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildDifficultyDotsHalf,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'JapaneseText',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'All kanji',
            builder: _manabi_do_widgetbook_common_use_cases
                .buildJapaneseTextAllKanji,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Kana only',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildJapaneseTextKana,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Mixed kanji/kana',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildJapaneseTextMixed,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'JlptLevelCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'N1',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildJlptLevelCardN1,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'N5',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildJlptLevelCardN5,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'LevelBadge',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_common_use_cases.buildLevelBadge,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'PillBadge',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Error',
            builder: _manabi_do_widgetbook_common_use_cases.buildPillBadgeError,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Primary',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildPillBadgePrimary,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Success',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildPillBadgeSuccess,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'PracticeButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_common_use_cases.buildPracticeButton,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'ProgressRow',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Complete',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildProgressRowComplete,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Partial',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildProgressRowPartial,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'ReviewProgressInfo',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Has SRS data',
            builder: _manabi_do_widgetbook_common_use_cases
                .buildReviewProgressInfoWithCard,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'New card',
            builder: _manabi_do_widgetbook_common_use_cases
                .buildReviewProgressInfoNew,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SectionHeader',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_common_use_cases.buildSectionHeader,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SectionLabel',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_common_use_cases.buildSectionLabel,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SegmentedTabBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildSegmentedTabBar,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SpeakButton',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_common_use_cases.buildSpeakButton,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'TappableSurface',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildTappableSurface,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'Exercise',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'DrawingExercise',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _manabi_do_widgetbook_exercise_use_cases.buildDrawingExercise,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'FlashCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Hidden',
            builder:
                _manabi_do_widgetbook_exercise_use_cases.buildFlashCardHidden,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Revealed',
            builder:
                _manabi_do_widgetbook_exercise_use_cases.buildFlashCardRevealed,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Reversed (EN→JP)',
            builder:
                _manabi_do_widgetbook_exercise_use_cases.buildFlashCardReversed,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'FlashCardActions',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _manabi_do_widgetbook_exercise_use_cases.buildFlashCardActions,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'LessonReaderCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _manabi_do_widgetbook_exercise_use_cases.buildLessonReaderCard,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'McqCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Correct',
            builder:
                _manabi_do_widgetbook_exercise_use_cases.buildMcqCardCorrect,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Idle',
            builder: _manabi_do_widgetbook_exercise_use_cases.buildMcqCardIdle,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Selected',
            builder:
                _manabi_do_widgetbook_exercise_use_cases.buildMcqCardSelected,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Wrong',
            builder: _manabi_do_widgetbook_exercise_use_cases.buildMcqCardWrong,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SummaryCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_exercise_use_cases.buildSummaryCard,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Perfect score',
            builder: _manabi_do_widgetbook_exercise_use_cases
                .buildSummaryCardPerfect,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'Grammar',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'Blocks',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'PatternBlock',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Multiple lines',
                builder: _manabi_do_widgetbook_grammar_use_cases
                    .buildPatternBlockMulti,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'N4 accent colour',
                builder:
                    _manabi_do_widgetbook_grammar_use_cases.buildPatternBlockN4,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Single line',
                builder: _manabi_do_widgetbook_grammar_use_cases
                    .buildPatternBlockSingle,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'Navigation',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'AppNavBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_navigation_use_cases.buildAppNavBar,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AppNavRail',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_navigation_use_cases.buildAppNavRail,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'NavItem',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Active',
            builder:
                _manabi_do_widgetbook_navigation_use_cases.buildNavItemActive,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Inactive',
            builder:
                _manabi_do_widgetbook_navigation_use_cases.buildNavItemInactive,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'Settings',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'SettingsCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_settings_use_cases.buildSettingsCard,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SettingsInfo',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_settings_use_cases.buildSettingsInfo,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SettingsStepper',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'At minimum',
            builder: _manabi_do_widgetbook_settings_use_cases
                .buildSettingsStepperMin,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _manabi_do_widgetbook_settings_use_cases.buildSettingsStepper,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SettingsTile',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Danger',
            builder: _manabi_do_widgetbook_settings_use_cases
                .buildSettingsTileDanger,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder: _manabi_do_widgetbook_settings_use_cases.buildSettingsTile,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'SettingsToggle',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Off',
            builder:
                _manabi_do_widgetbook_settings_use_cases.buildSettingsToggleOff,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'On',
            builder:
                _manabi_do_widgetbook_settings_use_cases.buildSettingsToggleOn,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'Study',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'ChapterCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Complete',
            builder:
                _manabi_do_widgetbook_study_use_cases.buildChapterCardComplete,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'In progress',
            builder: _manabi_do_widgetbook_study_use_cases
                .buildChapterCardInProgress,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Not started',
            builder: _manabi_do_widgetbook_study_use_cases
                .buildChapterCardNotStarted,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'DomainCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'No reviews due',
            builder:
                _manabi_do_widgetbook_study_use_cases.buildDomainCardDefault,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Reviews due',
            builder:
                _manabi_do_widgetbook_study_use_cases.buildDomainCardReviewsDue,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'LessonRow',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Done',
            builder: _manabi_do_widgetbook_study_use_cases.buildLessonRowDone,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'High difficulty',
            builder: _manabi_do_widgetbook_study_use_cases
                .buildLessonRowHardDifficulty,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Not started',
            builder:
                _manabi_do_widgetbook_study_use_cases.buildLessonRowNotStarted,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'StreakCard',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Active streak',
            builder:
                _manabi_do_widgetbook_study_use_cases.buildStreakCardActive,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'New streak',
            builder: _manabi_do_widgetbook_study_use_cases.buildStreakCardNew,
          ),
        ],
      ),
    ],
  ),
];
