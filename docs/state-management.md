# 状態管理設計

## 概要

外部状態管理パッケージ（Provider, Riverpod, BLoC等）は未使用。以下の3パターンで構成。

| パターン                 | 用途                               | 対象                |
| ------------------------ | ---------------------------------- | ------------------- |
| `ChangeNotifier`         | タイマーの残時間・アラート状態管理 | `CountDownTimer`    |
| `ValueListenableBuilder` | Hive Box変更のリアクティブUI更新   | タスク/持ち物リスト |
| コールバック関数         | 画面間データ伝達                   | 設定画面→タイマー   |

---

## パターン1: ChangeNotifier（CountDownTimer）

**ファイル**: `lib/home/widgets/count_down.dart`

### 公開プロパティ

| プロパティ      | 型         | 説明                              |
| --------------- | ---------- | --------------------------------- |
| `remainingTime` | `Duration` | 残り時間                          |
| `formattedTime` | `String`   | `"00時間15分00秒"` 形式           |
| `compactTime`   | `String`   | `"15:00"` または `"1:23:45"` 形式 |
| `isTimeSet`     | `bool`     | タイマーがセット済みか            |
| `isAlerting`    | `bool`     | タイムアップ後バイブ中か          |

### 公開メソッド

| メソッド        | 引数             | 動作                                              |
| --------------- | ---------------- | ------------------------------------------------- |
| `startTimer`    | `int minutes`    | 指定分数後を終了時刻に設定                        |
| `setTargetTime` | `TimeOfDay time` | 指定時刻を終了時刻に設定（過去なら翌日扱い）      |
| `stopAlert`     | —                | アラート停止（バイブ解除 + `isAlerting = false`） |

### 状態遷移

```
[未設定] ──setTargetTime()──→ [カウント中]
   │                              │
   │                        1秒ごとに_updateTime()
   │                              │
   │                         残り時間 ≤ 0
   │                              ↓
   │                        [タイムアップ]
   │                              │
   │                     _startAlerting()
   │                     HapticFeedback.vibrate() 1秒ごと
   │                              ↓
   │                        [アラート中]
   │                              │
   │                        stopAlert()
   │                              ↓
   │                          [停止]
   │
   └──startTimer(0)──→ [カウント中] (残り0分 = 即タイムアップ)
```

### UI監視方法

```dart
AnimatedBuilder(
  animation: timerController,  // CountDownTimer extends ChangeNotifier
  builder: (context, _) {
    // timerController.compactTime 等を参照
  },
)
```

`AnimatedBuilder` は `ListenableBuilder` のエイリアス。`notifyListeners()` 呼び出し時にUIが再描画される。

---

## パターン2: ValueListenableBuilder（Hive）

### 使用箇所

| ウィジェット      | 監視Box | 用途                                 |
| ----------------- | ------- | ------------------------------------ |
| `CountdownCard`   | `tasks` | タスクサマリ（全/完了/残）の自動更新 |
| `TaskSectionList` | `tasks` | ホーム画面タスクリストの自動更新     |
| `ItemSectionList` | `items` | ホーム画面持ち物リストの自動更新     |
| `SettingTaskList` | `tasks` | 設定画面タスク一覧の自動更新         |
| `SettingItemList` | `items` | 設定画面持ち物一覧の自動更新         |

### 監視パターン

```dart
ValueListenableBuilder(
  valueListenable: Hive.box<Task>('tasks').listenable(),
  builder: (context, Box<Task> box, _) {
    final tasks = box.values.toList();
    // タスクの追加・削除・更新で自動再描画
  },
)
```

Hive の `listenable()` は Box の put/delete/更新を検知し `ValueListenable` として通知。Widget側のコードは `ValueListenableBuilder` で囲むだけで自動反映される。

---

## パターン3: コールバック関数

### 設定画面 → タイマー連携

```
Settingscreen(onTimeSelected: (time) => sharedTimer.setTargetTime(time))
    │
    └── Timepicker(onTimeSelected: onTimeSelected)
            │
            └── showTimePicker → picked
                    │
                    ├── Hive保存 (departureHour, departureMinute)
                    └── onTimeSelected?.call(picked)
                            │
                            └── sharedTimer.setTargetTime(time)
                                    │
                                    └── notifyListeners()
                                            │
                                            └── CountdownCard 再描画
```

---

## グローバルインスタンス

**ファイル**: `lib/router.dart`

```dart
final sharedTimer = CountDownTimer(minutes: 0);
```

| 参照元                         | 用途                                                              |
| ------------------------------ | ----------------------------------------------------------------- |
| `router.dart` (GoRouter定義内) | `Homescreen` に `timerController` として渡す                      |
| `router.dart` (GoRouter定義内) | `Settingscreen` の `onTimeSelected` から `setTargetTime` 呼び出し |
| `main.dart` (`_loadSavedTime`) | 起動時の保存済み時刻からタイマー初期化                            |

**注意**: トップレベル変数のため、アプリ起動中は単一インスタンスが共有される。DI コンテナは未使用。

---

## データフロー全体図

```
[Hive settings Box]
    │ 読み込み (起動時)
    ↓
[sharedTimer.setTargetTime()]
    │
    ↓
[CountDownTimer] ──notifyListeners()──→ [CountdownCard UI更新]
    ↑
    │ setTargetTime()
    │
[Settingscreen] → [Timepicker] → showTimePicker
                                    │
                                    └→ [Hive settings Box] 書き込み

[Hive tasks/items Box]
    │ listenable()
    ↓
[ValueListenableBuilder] ──→ [TaskSectionList / ItemSectionList UI更新]
    ↑                        [SettingTaskList / SettingItemList UI更新]
    │ put/delete/save
    │
[addTask / completeTask / restoreTask / box.delete]
[addItem / completeItem / restoreItem / box.delete]
```
