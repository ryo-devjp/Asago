# アーキテクチャ設計

## レイヤー構成

```
┌─────────────────────────────────────────────┐
│  UI 層 (Widgets / Pages)                  　 │
│  home/, setting/, bottom_nav.dart           │
├─────────────────────────────────────────────┤
│  ビジネスロジック層                            │
│  CountDownTimer (ChangeNotifier)            │
│  shared/app_strings.dart                    │
├─────────────────────────────────────────────┤
│  データ層                                  　 │
│  task_service.dart, item_service.dart       │
│  Hive (tasks, items, settings Boxes)        │
└─────────────────────────────────────────────┘
```

**設計方針**: Provider/Riverpod/BLoC等の外部状態管理パッケージは未使用。Flutter標準の `ChangeNotifier` + Hive の `ValueListenableBuilder` で軽量に構成。

## ファイル一覧

| ファイル                                   | 層           | 責務                                            | 行数 |
| ------------------------------------------ | ------------ | ----------------------------------------------- | ---: |
| `lib/main.dart`                            | エントリ     | Hive初期化・アプリ起動・保存時刻復元            |   52 |
| `lib/router.dart`                          | ルーティング | GoRouter定義・sharedTimerインスタンス生成       |   60 |
| `lib/bottom_nav.dart`                      | UI           | 2タブ NavigationBar                             |   38 |
| `lib/home/page/home_screen.dart`           | UI           | ホーム画面レイアウト（Sliver構成）              |   58 |
| `lib/home/widgets/count_down.dart`         | ロジック     | カウントダウンタイマー（ChangeNotifier）        |  101 |
| `lib/home/widgets/countdown_card.dart`     | UI           | カウントダウン表示+タスクサマリカード           |   92 |
| `lib/home/widgets/task_summary.dart`       | UI           | タスク件数サマリ（全/完了/残）                  |   43 |
| `lib/home/widgets/info_row.dart`           | UI           | アイコン+ラベル+値の1行表示                     |   46 |
| `lib/home/widgets/task.dart`               | UI           | Dismissibleスワイプ完了タイル                   |   65 |
| `lib/home/widgets/task_section.dart`       | UI           | タスクセクション（Sliver + 完了折りたたみ）     |  143 |
| `lib/home/widgets/item_section.dart`       | UI           | 持ち物セクション（Sliver + 確認済み折りたたみ） |  145 |
| `lib/home/widgets/complete_task_list.dart` | UI           | 完了済み行（復元ボタン付き）                    |   46 |
| `lib/setting/page/setting_screen.dart`     | UI           | 設定画面レイアウト（Sliver構成）                |  122 |
| `lib/setting/widgets/time_picker.dart`     | UI           | 出発時刻TimePicker + Hive保存                   |   96 |
| `lib/setting/widgets/register_task.dart`   | UI           | タスク登録BottomSheetモーダル                   |  116 |
| `lib/setting/widgets/register_items.dart`  | UI           | 持ち物登録BottomSheetモーダル                   |  113 |
| `lib/setting/widgets/task_list.dart`       | UI           | 登録済みタスク一覧（削除可）                    |   62 |
| `lib/setting/widgets/item_list.dart`       | UI           | 登録済み持ち物一覧（削除可）                    |   62 |
| `lib/shared/app_strings.dart`              | 共通         | 全UI文字列定数                                  |   67 |
| `lib/shared/task_service.dart`             | データ       | Taskモデル + CRUD関数                           |   49 |
| `lib/shared/task_service.g.dart`           | データ       | Hive TypeAdapter (自動生成)                     |   48 |
| `lib/shared/item_service.dart`             | データ       | Itemモデル + CRUD関数                           |   43 |
| `lib/shared/item_service.g.dart`           | データ       | Hive TypeAdapter (自動生成)                     |   46 |
| `lib/theme/app_theme.dart`                 | テーマ       | ライト/ダーク テーマ構築                        |   81 |

**合計**: 24 Dartファイル / 1,838行

## 依存パッケージ

### プロダクション

| パッケージ     | バージョン | 用途                                                 |
| -------------- | ---------- | ---------------------------------------------------- |
| `go_router`    | ^17.0.1    | 宣言的ルーティング（StatefulShellRoute で2タブ管理） |
| `google_fonts` | ^6.2.1     | BIZ UDGothic フォント適用                            |
| `hive`         | ^2.2.3     | ローカル NoSQL DB（タスク・持ち物・設定の永続化）    |
| `hive_flutter` | ^1.1.0     | Hive の Flutter 統合（ValueListenableBuilder 対応）  |
| `uuid`         | ^4.5.2     | Task/Item の一意ID生成（UUID v4）                    |

### 開発

| パッケージ               | バージョン | 用途                        |
| ------------------------ | ---------- | --------------------------- |
| `flutter_lints`          | ^6.0.0     | Lint ルール                 |
| `flutter_launcher_icons` | ^0.14.4    | アプリアイコン生成          |
| `hive_generator`         | ^2.0.1     | Hive TypeAdapter コード生成 |
| `build_runner`           | ^2.4.13    | コード生成実行              |

## ルーティング設計

**方式**: `GoRouter` + `StatefulShellRoute.indexedStack`

```
GoRouter
└── StatefulShellRoute.indexedStack
    ├── Branch 0: / (home)      → Homescreen
    └── Branch 1: /settings     → Settingscreen
```

| パス        | 名前       | 画面            | 備考                                    |
| ----------- | ---------- | --------------- | --------------------------------------- |
| `/`         | `home`     | `Homescreen`    | `timerController` を受け取る            |
| `/settings` | `settings` | `Settingscreen` | `onTimeSelected` コールバックを受け取る |

**タブ間状態保持**: `IndexedStack` により各タブの `Navigator` 状態を維持。タブ切替時にページが再構築されない。

**画面間連携**: `Settingscreen` で時刻設定 → `onTimeSelected` コールバック → `sharedTimer.setTargetTime()` → ホーム画面のカウントダウン更新。

## 初期化フロー

```
main()
  ├── WidgetsFlutterBinding.ensureInitialized()
  ├── Hive.initFlutter()
  ├── Hive.registerAdapter(TaskAdapter())
  ├── Hive.registerAdapter(ItemAdapter())
  ├── Hive.openBox('settings')
  ├── Hive.openBox<Task>('tasks')
  ├── Hive.openBox<Item>('items')
  ├── _loadSavedTime()  ← Hive settings → sharedTimer.setTargetTime()
  └── runApp(MainApp())
```

## コード規約

| 規約             | 詳細                                                                   |
| ---------------- | ---------------------------------------------------------------------- |
| UI文字列         | `AppStrings`（`abstract final class`）で一元管理。将来ARB移行可能      |
| 自動生成コード   | `*.g.dart` は `build_runner` で生成。手動編集禁止                      |
| ウィジェット分割 | 1ファイル1ウィジェット原則。プライベートヘルパーは同一ファイル内に配置 |
| 画面構成         | `CustomScrollView` + `Sliver` ベース                                   |
| Lint             | `package:flutter_lints/flutter.yaml` 準拠                              |

## プラットフォーム設定

| 項目     | Android             | iOS           |
| -------- | ------------------- | ------------- |
| アプリID | `com.example.asago` | Runner bundle |
| 表示名   | —                   | Asago         |
| 最小SDK  | Flutter default     | —             |
| 画面回転 | デフォルト          | 全方向対応    |
| 署名     | 未設定（debug key） | —             |
