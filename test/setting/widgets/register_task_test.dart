import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asago/setting/widgets/register_task.dart';
import 'package:asago/shared/app_strings.dart';

void main() {
  group('RegisterTask', () {
    const testElement = MaterialApp(home: Scaffold(body: RegisterTask()));
    testWidgets('${AppStrings.registerTaskButton}ボタンが表示されること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(testElement);

      expect(find.text(AppStrings.registerTaskButton), findsOneWidget);
    });

    testWidgets('ボタンをタップするとモーダルが開くこと', (WidgetTester tester) async {
      await tester.pumpWidget(testElement);

      expect(find.text(AppStrings.newTaskModalTitle), findsNothing);

      await tester.tap(find.text(AppStrings.registerTaskButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.newTaskModalTitle), findsOneWidget);
    });

    testWidgets('空文字では保存されずモーダルが閉じないこと', (WidgetTester tester) async {
      // ウィジェットを記述する
      await tester.pumpWidget(testElement);

      // モーダルを開く
      await tester.tap(find.text(AppStrings.registerTaskButton));
      await tester.pumpAndSettle();

      // タスク名なしで保存ボタン押下
      await tester.tap(find.text(AppStrings.saveButton));
      await tester.pumpAndSettle();

      // テスト観点：モーダルタイトルが表示され続けること = モーダルが閉じていない
      // テスト観点：エラーテキストが出ていること
      expect(find.text(AppStrings.newTaskModalTitle), findsOneWidget);
      expect(find.text(AppStrings.taskNameRequiredError), findsOneWidget);
    });
  });
}
