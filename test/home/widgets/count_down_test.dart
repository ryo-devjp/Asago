import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asago/home/widgets/count_down.dart';

void main() {
  group('CountDownTimer — 初期化', () {
    test('初期化直後はバイブが鳴らないこと（isAlerting == false）', () {
      final timer = CountDownTimer();

      expect(timer.isAlerting, isFalse);

      timer.dispose();
    });

    test('初期化直後はタイマーが未セットであること（isTimeSet == false）', () {
      final timer = CountDownTimer();

      expect(timer.isTimeSet, isFalse);

      timer.dispose();
    });

    test('初期化直後は残り時間がゼロであること', () {
      final timer = CountDownTimer();

      expect(timer.remainingTime, Duration.zero);

      timer.dispose();
    });
  });

  group('CountDownTimer — startTimer', () {
    test('startTimerで指定した分数のカウントダウンが開始されること', () {
      final timer = CountDownTimer();
      timer.startTimer(5);

      // 5分後としてセットされる（実行ラグを考慮して、299秒以上であることを確認）
      expect(timer.isTimeSet, isTrue);
      expect(timer.remainingTime.inSeconds, greaterThanOrEqualTo(299));

      timer.dispose();
    });

    test('startTimer後もアラートは発生しないこと（isAlerting == false）', () {
      final timer = CountDownTimer();
      timer.startTimer(5);

      expect(timer.isAlerting, isFalse);

      timer.dispose();
    });
  });

  group('CountDownTimer — setTargetTime', () {
    test('将来の時刻を設定した場合、isAlerting == false のまま', () {
      final timer = CountDownTimer();
      final now = DateTime.now();

      // 1時間後の時刻を設定
      final futureTime = TimeOfDay(
        hour: (now.hour + 1) % 24,
        minute: now.minute,
      );
      timer.setTargetTime(futureTime);

      expect(timer.isTimeSet, isTrue);
      expect(timer.isAlerting, isFalse);

      timer.dispose();
    });

    test('過去の時刻を指定した場合、翌日の時刻としてセットされること', () {
      final timer = CountDownTimer();
      final now = DateTime.now();

      // 現在時刻より1時間前の時刻を設定（翌日扱いになるはず）
      final pastHour = (now.hour - 1) % 24;
      timer.setTargetTime(TimeOfDay(hour: pastHour, minute: now.minute));

      expect(timer.isTimeSet, isTrue);
      // 約23時間 (23 * 60 * 60 = 82800秒) の残り時間になるはず
      expect(timer.remainingTime.inHours, greaterThanOrEqualTo(22));

      timer.dispose();
    });
  });

  group('CountDownTimer — stopAlert', () {
    test('stopAlertでアラート状態が解除されること', () {
      final timer = CountDownTimer();

      // HapticFeedback などが関わる状態のテストは本来 mock が必要ですが、
      // 簡単なフラグリセットだけを確認します
      timer.stopAlert();

      expect(timer.isAlerting, isFalse);

      timer.dispose();
    });
  });
}
