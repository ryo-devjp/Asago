# データモデル設計

## Hive Box 構成

| Box名      | 型               | typeId | 用途                   |
| ---------- | ---------------- | ------ | ---------------------- |
| `tasks`    | `Box<Task>`      | 0      | タスクデータの永続化   |
| `items`    | `Box<Item>`      | 1      | 持ち物データの永続化   |
| `settings` | `Box`（dynamic） | —      | 出発時刻等のアプリ設定 |

## Task モデル

**ファイル**: `lib/shared/task_service.dart`
**Hive typeId**: 0

| HiveField | フィールド    | 型       | 必須 | デフォルト | 説明                       |
| --------- | ------------- | -------- | ---- | ---------- | -------------------------- |
| 0         | `id`          | `String` | ○    | —          | UUID v4 で自動生成         |
| 1         | `task`        | `String` | ○    | —          | タスク名                   |
| 2         | `duration`    | `int`    | ○    | —          | 所要時間（分）範囲: 1〜120 |
| 3         | `isCompleted` | `bool`   | —    | `false`    | 完了フラグ                 |

**キー戦略**: `id`（UUID v4）を Box の key としても使用（`box.put(id, task)`）。

## Item モデル

**ファイル**: `lib/shared/item_service.dart`
**Hive typeId**: 1

| HiveField | フィールド    | 型       | 必須 | デフォルト | 説明               |
| --------- | ------------- | -------- | ---- | ---------- | ------------------ |
| 0         | `id`          | `String` | ○    | —          | UUID v4 で自動生成 |
| 1         | `item`        | `String` | ○    | —          | 持ち物名           |
| 2         | `isCompleted` | `bool`   | —    | `false`    | 確認済みフラグ     |

**キー戦略**: Task と同様、`id` を Box の key として使用。

## Settings（Key-Value）

| キー              | 型    | 説明                  |
| ----------------- | ----- | --------------------- |
| `departureHour`   | `int` | 出発時刻の時（0〜23） |
| `departureMinute` | `int` | 出発時刻の分（0〜59） |

**読み込みタイミング**: `main()` 内の `_loadSavedTime()` で起動時に自動読み込み → `sharedTimer.setTargetTime()` に反映。
**書き込みタイミング**: `Timepicker._pickTime()` で TimePicker 確定時に即座に保存。

## CRUD 操作

### Task 操作（`lib/shared/task_service.dart`）

| 関数           | シグネチャ                                        | 動作                           |
| -------------- | ------------------------------------------------- | ------------------------------ |
| `getTasks`     | `List<Task> getTasks()`                           | 全タスクを取得                 |
| `addTask`      | `Future<void> addTask(String task, int duration)` | UUID v4 で新規タスク作成・保存 |
| `completeTask` | `Future<void> completeTask(String id)`            | `isCompleted = true` に更新    |
| `restoreTask`  | `Future<void> restoreTask(String id)`             | `isCompleted = false` に戻す   |

### Item 操作（`lib/shared/item_service.dart`）

| 関数           | シグネチャ                             | 動作                           |
| -------------- | -------------------------------------- | ------------------------------ |
| `getItems`     | `List<Item> getItems()`                | 全持ち物を取得                 |
| `addItem`      | `Future<void> addItem(String item)`    | UUID v4 で新規持ち物作成・保存 |
| `completeItem` | `Future<void> completeItem(String id)` | `isCompleted = true` に更新    |
| `restoreItem`  | `Future<void> restoreItem(String id)`  | `isCompleted = false` に戻す   |

### 削除操作

設定画面の `SettingTaskList` / `SettingItemList` から直接 `box.delete(id)` を呼び出し。専用のサービス関数は未定義。

## データ関係図

```
settings Box (dynamic)
  ├── departureHour: int
  └── departureMinute: int

tasks Box<Task> (typeId: 0)
  └── [UUID] → Task { id, task, duration, isCompleted }

items Box<Item> (typeId: 1)
  └── [UUID] → Item { id, item, isCompleted }
```

Task と Item は独立したエンティティ。相互参照なし。
Settings は Task/Item とは別の汎用 Box に格納。

## 自動生成ファイル

| ファイル              | 生成元              | 生成コマンド                  |
| --------------------- | ------------------- | ----------------------------- |
| `task_service.g.dart` | `task_service.dart` | `dart run build_runner build` |
| `item_service.g.dart` | `item_service.dart` | `dart run build_runner build` |

`@HiveType` / `@HiveField` アノテーションから `TypeAdapter` を自動生成。手動編集禁止。
