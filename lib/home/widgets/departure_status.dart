import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/task_service.dart';

/// 出発時間から逆算した余裕度のステータス。
enum DepartureStatus {
  relaxed,
  hurry,
  critical,
  overdue;

  String get emoji => switch (this) {
    relaxed => AppStrings.statusEmojiRelaxed,
    hurry => AppStrings.statusEmojiHurry,
    critical => AppStrings.statusEmojiCritical,
    overdue => AppStrings.statusEmojiOverdue,
  };

  String get message => switch (this) {
    relaxed => AppStrings.statusRelaxed,
    hurry => AppStrings.statusHurry,
    critical => AppStrings.statusCritical,
    overdue => AppStrings.statusOverdue,
  };

  /// 出発までの残り時間とタスク一覧からステータスを判定する。
  ///
  /// [remainingTime] はカウントダウンタイマーの残り時間。
  /// [isAlerting] が true の場合は出発時間を超過している。
  /// [tasks] は全タスク一覧（未完了タスクの所要時間を合算する）。
  static DepartureStatus evaluate({
    required Duration remainingTime,
    required bool isAlerting,
    required List<Task> tasks,
  }) {
    if (isAlerting) return DepartureStatus.overdue;

    final totalMinutes = tasks
        .where((t) => !t.isCompleted)
        .fold<int>(0, (sum, t) => sum + t.duration);

    final buffer = remainingTime - Duration(minutes: totalMinutes);

    if (buffer.inMinutes < 15) return DepartureStatus.critical;
    if (buffer.inMinutes < 30) return DepartureStatus.hurry;
    return DepartureStatus.relaxed;
  }
}
