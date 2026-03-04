# Asago

タスクを消化して遅刻を防ぐ、朝のルーティンタイマーアプリ。

時間管理が苦手な方（ADHD・グレーゾーンなど）が、出発時刻までにやるべきことを可視化し、遅刻せずに家を出られるようサポートします。

## Features

- **カウントダウンタイマー** — 出発時刻までの残り時間をリアルタイム表示
- **タスク管理** — 朝のルーティンを登録・スワイプで完了
- **持ち物チェックリスト** — 忘れ物を防止
- **出発時刻設定** — TimePicker で設定、永続保存
- **ライト / ダークモード** — システム設定に連動

## Tech Stack

| カテゴリ             | 技術                          |
| -------------------- | ----------------------------- |
| フレームワーク       | Flutter / Dart 3.10+          |
| ローカル DB          | Hive                          |
| ルーティング         | GoRouter (StatefulShellRoute) |
| デザイン             | Material 3, BIZ UDGothic      |
| 対応プラットフォーム | Android, iOS                  |

## Getting Started

### 前提条件

- Flutter SDK (stable)

### セットアップ

```bash
# リポジトリをクローン
git clone https://github.com/<your-username>/asago.git
cd asago

# 依存関係のインストール
flutter pub get

# Hive アダプターのコード生成
dart run build_runner build --delete-conflicting-outputs

# アプリを実行
flutter run
```

## Project Structure

```
lib/
├── main.dart           # エントリポイント（Hive 初期化）
├── router.dart         # GoRouter 定義
├── bottom_nav.dart     # BottomNavigationBar
├── home/               # ホーム画面（タイマー・タスク・持ち物）
├── setting/            # 設定画面（タスク・持ち物・時刻登録）
├── shared/             # サービス層（Task, Item, AppStrings）
└── theme/              # テーマ定義（ライト / ダーク）
```

詳細なアーキテクチャやロードマップは [`docs/`](docs/) を参照してください。
