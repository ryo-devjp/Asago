# UI・画面設計

## 画面一覧

| 画面           | クラス          | ファイル                               | ルート      |
| -------------- | --------------- | -------------------------------------- | ----------- |
| ホーム         | `Homescreen`    | `lib/home/page/home_screen.dart`       | `/`         |
| 設定           | `Settingscreen` | `lib/setting/page/setting_screen.dart` | `/settings` |
| ナビゲーション | `BottomNav`     | `lib/bottom_nav.dart`                  | — (Shell)   |

## BottomNav

**ファイル**: `lib/bottom_nav.dart`
**方式**: Material 3 `NavigationBar` + `StatefulNavigationShell`

| タブ   | アイコン（非選択）  | アイコン（選択）   | ラベル |
| ------ | ------------------- | ------------------ | ------ |
| ホーム | `home_outlined`     | `home_rounded`     | ホーム |
| 設定   | `settings_outlined` | `settings_rounded` | 設定   |

`navigationShell.goBranch(index)` でタブ切替。同一タブ再選択時は `initialLocation: true` でルートに戻る。

---

## ホーム画面

**ファイル**: `lib/home/page/home_screen.dart`
**構成**: `Scaffold` > `SafeArea` > `CustomScrollView`

### ウィジェットツリー

```
Homescreen
└── CustomScrollView
    ├── SliverToBoxAdapter: "Today" ヘッダー
    ├── SliverToBoxAdapter: CountdownCard
    ├── TaskSectionHeader (Sliver)
    ├── TaskSectionList (Sliver)
    ├── ItemSectionHeader (Sliver)
    └── ItemSectionList (Sliver)
```

### CountdownCard

**ファイル**: `lib/home/widgets/countdown_card.dart`

`AnimatedBuilder` で `CountDownTimer` を監視し、以下を表示:

| 要素           | 説明                                                                             |
| -------------- | -------------------------------------------------------------------------------- |
| ヘッダ行       | 時計アイコン + "出発まで"                                                        |
| カウントダウン | `compactTime` を48pxフォントで表示。未設定時は `--:--`                           |
| タスクサマリ   | `TaskSummary` ウィジェット（Hive tasks Box を `ValueListenableBuilder` で監視）  |
| 出発ボタン     | タイムアップで `isAlerting` 時のみ表示。`FilledButton` で `stopAlert()` 呼び出し |

タイムアップ時、カウントダウン表示色が `cs.primary` → `cs.error` に変化。

### TaskSummary

**ファイル**: `lib/home/widgets/task_summary.dart`

| 行  | アイコン                          | ラベル   | 値          |
| --- | --------------------------------- | -------- | ----------- |
| 1   | `flag_outlined` (primary)         | 全タスク | `total`     |
| 2   | `check_circle_outline` (green)    | 完了     | `done`      |
| 3   | `radio_button_unchecked` (orange) | 残り     | `remaining` |

各行は `InfoRow` ウィジェット（`lib/home/widgets/info_row.dart`）で構成。

### TaskSection

**ファイル**: `lib/home/widgets/task_section.dart`

| コンポーネント | クラス              | 説明                                                |
| -------------- | ------------------- | --------------------------------------------------- |
| ヘッダー       | `TaskSectionHeader` | "タスク" セクション見出し（Sliver）                 |
| リスト         | `TaskSectionList`   | Hive `tasks` Box を `ValueListenableBuilder` で監視 |

**リスト表示ロジック**:

- 未完了タスク → `TaskTile`（スワイプで完了）
- 全完了時 → `_EmptyTaskPlaceholder`（電球アイコン + 完了メッセージ）
- 完了タスクあり → `_CompletedTaskSection`（`ExpansionTile` 折りたたみ）

### TaskTile

**ファイル**: `lib/home/widgets/task.dart`

`Dismissible` ラッパーによるスワイプ完了UI。

| 方向       | 背景                                | 動作                           |
| ---------- | ----------------------------------- | ------------------------------ |
| 左スワイプ | 緑グラデーション + チェックアイコン | `onDismissed` コールバック実行 |
| 右スワイプ | 緑グラデーション + チェックアイコン | 同上                           |

本体は `Card` > `ListTile`（旗アイコン + タスク名 + 左矢印）。

### CompleteTaskList

**ファイル**: `lib/home/widgets/complete_task_list.dart`

完了済みタスク/持ち物の1行表示。取り消し線テキスト + 緑チェックアイコン + "戻す" `OutlinedButton`（`onRestore` コールバック）。

### ItemSection

**ファイル**: `lib/home/widgets/item_section.dart`

TaskSection と同一構造。`Item` モデルを使用し、`completeItem` / `restoreItem` を呼び出す。

| コンポーネント | クラス              |
| -------------- | ------------------- |
| ヘッダー       | `ItemSectionHeader` |
| リスト         | `ItemSectionList`   |

---

## 設定画面

**ファイル**: `lib/setting/page/setting_screen.dart`
**構成**: `Scaffold` > `SafeArea` > `CustomScrollView`

### ウィジェットツリー

```
Settingscreen
└── CustomScrollView
    ├── SliverToBoxAdapter: "設定" ヘッダー
    ├── SliverToBoxAdapter: Card > Timepicker
    ├── SliverToBoxAdapter: Card > [タスク管理]
    │   ├── SettingTaskList
    │   └── RegisterTask
    ├── SliverToBoxAdapter: Card > [持ち物管理]
    │   ├── SettingItemList
    │   └── RegisterItems
    └── SliverToBoxAdapter: 下部余白 (32px)
```

### Timepicker

**ファイル**: `lib/setting/widgets/time_picker.dart`
**状態**: `StatefulWidget`（選択時刻を `_selectedTime` で保持）

| 要素       | 説明                                              |
| ---------- | ------------------------------------------------- |
| ヘッダ行   | 時計アイコン + "出発時刻"                         |
| 時刻表示   | `HH:mm` を48pxフォントで中央表示                  |
| 設定ボタン | `ElevatedButton` → `showTimePicker`（24時間形式） |

**保存フロー**: TimePicker確定 → `setState` → Hive `settings` Box に `departureHour`/`departureMinute` 保存 → `onTimeSelected` コールバック呼び出し。

**初期値**: Hive に保存済みならその値、なければ `TimeOfDay.now()`。

### SettingTaskList

**ファイル**: `lib/setting/widgets/task_list.dart`

Hive `tasks` Box を `ValueListenableBuilder` で監視。

| 状態       | 表示                                                           |
| ---------- | -------------------------------------------------------------- |
| タスクなし | "タスクがまだ登録されていません"                               |
| タスクあり | `ListTile` 一覧（完了アイコン + タスク名 + 削除 `IconButton`） |

削除は `box.delete(task.id)` で直接実行。

### RegisterTask

**ファイル**: `lib/setting/widgets/register_task.dart`
**状態**: `StatefulWidget`（`TextEditingController` + `_duration` 管理）

**モーダル仕様**:

| 要素           | 詳細                                                                                     |
| -------------- | ---------------------------------------------------------------------------------------- |
| トリガー       | "タスクを追加する" `OutlinedButton`                                                      |
| 表示方法       | `showModalBottomSheet` + `StatefulBuilder`（角丸20px、キーボード追従）                   |
| 入力1          | `TextField`（autofocus、ヒント: "タスク名を入力"）                                       |
| 入力2          | `ListWheelScrollView`（1〜120分、1分刻み、デフォルト10分）ドラムロール形式、高さ200px    |
| アクション     | キャンセル (`OutlinedButton`) / 保存 (`ElevatedButton`)                                  |
| 保存処理       | `addTask(text, _duration)` → モーダル閉じる                                              |
| バリデーション | 空文字はスキップ（`trim().isNotEmpty` チェック）                                         |
| リセット       | モーダル開くたびに `_controller.clear()` + `_duration = 10` + `wheelController` を再生成 |

### SettingItemList

**ファイル**: `lib/setting/widgets/item_list.dart`

`SettingTaskList` と同一構造。`Item` モデルを使用。

### RegisterItems

**ファイル**: `lib/setting/widgets/register_items.dart`

`RegisterTask` と同一構造。`addItem(text)` を呼び出し（`duration` パラメータなし）。

---

## ウィジェット一覧

| ウィジェット        | ファイル                               | Stateful | Hive監視 | 責務                      |
| ------------------- | -------------------------------------- | -------- | -------- | ------------------------- |
| `BottomNav`         | `bottom_nav.dart`                      | —        | —        | タブナビゲーション        |
| `Homescreen`        | `home/page/home_screen.dart`           | —        | —        | ホーム画面レイアウト      |
| `CountdownCard`     | `home/widgets/countdown_card.dart`     | —        | `tasks`  | カウントダウン+サマリ表示 |
| `TaskSummary`       | `home/widgets/task_summary.dart`       | —        | —        | タスク件数集計表示        |
| `InfoRow`           | `home/widgets/info_row.dart`           | —        | —        | アイコン+ラベル+値の1行   |
| `TaskTile`          | `home/widgets/task.dart`               | —        | —        | スワイプ完了タイル        |
| `TaskSectionHeader` | `home/widgets/task_section.dart`       | —        | —        | タスクセクション見出し    |
| `TaskSectionList`   | `home/widgets/task_section.dart`       | —        | `tasks`  | タスクリスト（Sliver）    |
| `ItemSectionHeader` | `home/widgets/item_section.dart`       | —        | —        | 持ち物セクション見出し    |
| `ItemSectionList`   | `home/widgets/item_section.dart`       | —        | `items`  | 持ち物リスト（Sliver）    |
| `CompleteTaskList`  | `home/widgets/complete_task_list.dart` | —        | —        | 完了済み行+復元ボタン     |
| `Settingscreen`     | `setting/page/setting_screen.dart`     | —        | —        | 設定画面レイアウト        |
| `Timepicker`        | `setting/widgets/time_picker.dart`     | ○        | —        | 出発時刻設定              |
| `RegisterTask`      | `setting/widgets/register_task.dart`   | ○        | —        | タスク登録モーダル        |
| `RegisterItems`     | `setting/widgets/register_items.dart`  | ○        | —        | 持ち物登録モーダル        |
| `SettingTaskList`   | `setting/widgets/task_list.dart`       | —        | `tasks`  | 登録済みタスク一覧        |
| `SettingItemList`   | `setting/widgets/item_list.dart`       | —        | `items`  | 登録済み持ち物一覧        |

---
