import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/home/widgets/count_down.dart';
import 'package:asago/home/widgets/countdown_card.dart';
import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/task_service.dart';

void main() {
  // テスト中にフォントのネットワーク取得を無効化
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('CountdownCard — 出発ボタン表示制御', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test');
      Hive.init(tempDir.path);
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TaskAdapter());
      }
      await Hive.openBox<Task>('tasks');
    });

    tearDown(() async {
      await Hive.close();
      await tempDir.delete(recursive: true);
    });

    testWidgets('アプリ起動直後（isAlerting == false）は出発ボタンが表示されないこと', (tester) async {
      final timer = CountDownTimer();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CountdownCard(timerController: timer)),
        ),
      );

      expect(find.text(AppStrings.departedButton), findsNothing);

      timer.dispose();
    });

    testWidgets('出発時間前（setTargetTime後・isAlerting == false）は出発ボタンが表示されないこと', (
      tester,
    ) async {
      final timer = CountDownTimer();
      final now = DateTime.now();
      // 1時間後の時刻にセット
      timer.setTargetTime(
        TimeOfDay(hour: (now.hour + 1) % 24, minute: now.minute),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CountdownCard(timerController: timer)),
        ),
      );

      expect(find.text(AppStrings.departedButton), findsNothing);

      timer.dispose();
    });

    testWidgets('タイムアップ後（isAlerting == true）は出発ボタンが表示されること', (tester) async {
      final timer = CountDownTimer();

      // アラート状態を手動で開始するため、过去の時刻を直接内部に再現する。
      // stopAlert はフラグをリセットするだけなので、逆に isAlerting を
      // true に設定するには startTimer 後に時間経過を待つ必要がある。
      // ここでは isAlerting のフラグが UI 表示に直結することを検証するため、
      // 0秒タイマーをセットして pump で1ティック進める。
      timer.startTimer(0); // 0秒後 = 即タイムアップ

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CountdownCard(timerController: timer)),
        ),
      );
      // _startAlerting は非同期 Timer.periodic に依存するため
      // 少し時間を進めてアラート状態を反映させる
      await tester.pump(const Duration(seconds: 2));

      expect(find.text(AppStrings.departedButton), findsOneWidget);

      timer.stopAlert();
      timer.dispose();
    });
  });
}
