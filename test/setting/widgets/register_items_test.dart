import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asago/setting/widgets/register_items.dart';
import 'package:asago/shared/app_strings.dart';

void main() {
  group('RegisterItems', () {
    const testElement = MaterialApp(home: Scaffold(body: RegisterItems()));
    testWidgets('${AppStrings.addItemButton}ボタンが表示されること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(testElement);

      expect(find.text(AppStrings.addItemButton), findsOneWidget);
    });

    testWidgets('ボタンをタップするとモーダルが開くこと', (WidgetTester tester) async {
      await tester.pumpWidget(testElement);

      expect(find.text(AppStrings.itemsModalTitle), findsNothing);

      await tester.tap(find.text(AppStrings.addItemButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.itemsModalTitle), findsOneWidget);
    });

    testWidgets('空文字では保存されずモーダルが閉じないこと', (WidgetTester tester) async {
      // ウィジェットを記述する
      await tester.pumpWidget(testElement);

      // モーダルを開く
      await tester.tap(find.text(AppStrings.addItemButton));
      await tester.pumpAndSettle();

      // 持ち物名なしで保存ボタン押下
      await tester.tap(find.text(AppStrings.saveButton));
      await tester.pumpAndSettle();

      // テスト観点：モーダルタイトルが表示され続けること = モーダルが閉じていない
      // テスト観点：エラーテキストが出ていること
      expect(find.text(AppStrings.itemsModalTitle), findsOneWidget);
      expect(find.text(AppStrings.itemNameRequiredError), findsOneWidget);
    });
  });
}
