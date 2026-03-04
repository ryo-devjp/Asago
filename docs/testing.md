# テスト設計

## 現在のテスト構成

| ファイル                                 | 対象             | テスト種別 | ケース数 |
| ---------------------------------------- | ---------------- | ---------- | -------: |
| `test/home/widgets/count_down_test.dart` | `CountDownTimer` | 単体テスト |        3 |

## テストケース一覧

### CountDownTimer（`test/home/widgets/count_down_test.dart`）

| #   | テスト名                                                                  | 検証内容                                        | 検証条件                                           |
| --- | ------------------------------------------------------------------------- | ----------------------------------------------- | -------------------------------------------------- |
| 1   | 初期化時に指定した分数のタイマーが開始されること                          | `CountDownTimer(minutes: 5)` で生成後の残り時間 | `remainingTime.inSeconds >= 299`                   |
| 2   | setTargetTimeで過去の時刻を指定した場合、翌日の時刻としてセットされること | 現在時刻の1時間前を `setTargetTime()` に渡す    | `isTimeSet == true`, `remainingTime.inHours >= 22` |
| 3   | stopAlertでアラート状態が解除されること                                   | `stopAlert()` 呼び出し後の状態                  | `isAlerting == false`                              |

## テスト実行

```bash
flutter test
```

特定ファイル指定:

```bash
flutter test test/home/widgets/count_down_test.dart
```

## 未カバー領域

| 領域         | 対象                                         | 種別                        |
| ------------ | -------------------------------------------- | --------------------------- |
| サービス層   | `task_service.dart` CRUD操作                 | 単体テスト（Hive mock必要） |
| サービス層   | `item_service.dart` CRUD操作                 | 単体テスト（Hive mock必要） |
| Widget       | `CountdownCard`, `TaskTile`, `Timepicker` 等 | Widget テスト               |
| 画面遷移     | GoRouter によるタブ遷移                      | Widget テスト               |
| 統合         | タスク登録→ホーム画面反映の一連フロー        | Integration テスト          |
| タイマー連携 | 設定画面での時刻変更→カウントダウン更新      | Integration テスト          |

## テスト方針

- `CountDownTimer` は `ChangeNotifier` のため、`Timer.periodic` に依存する部分は `fake_async` パッケージで制御可能
- Hive 依存のテストは `Hive.init()` を呼ぶか、サービス関数をインターフェース化してモック差替えを推奨
- Widget テストは `pumpWidget` + `WidgetTester` で各コンポーネントの表示・操作を検証
