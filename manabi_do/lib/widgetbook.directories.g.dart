// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:manabi_do/widgetbook/common_use_cases.dart'
    as _manabi_do_widgetbook_common_use_cases;
import 'package:manabi_do/widgetbook/exercise_use_cases.dart'
    as _manabi_do_widgetbook_exercise_use_cases;
import 'package:manabi_do/widgetbook/study_use_cases.dart'
    as _manabi_do_widgetbook_study_use_cases;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
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
        name: 'KnownToggle',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Known',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildKnownToggleKnown,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Unknown',
            builder:
                _manabi_do_widgetbook_common_use_cases.buildKnownToggleUnknown,
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
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'Exercise',
    children: [
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
        name: 'SessionSummary',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Empty session',
            builder: _manabi_do_widgetbook_exercise_use_cases
                .buildSessionSummaryEmpty,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'With results',
            builder: _manabi_do_widgetbook_exercise_use_cases
                .buildSessionSummaryResults,
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
