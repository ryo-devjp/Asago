# Asago - GitHub Copilot 設計書自動更新指示

## 基本ルール

コードを変更した際は、必ず `docs/` 配下の設計書を同期更新すること。

## 更新トリガーと対象ドキュメント

| 変更内容                                               | 更新対象                                                                     |
| ------------------------------------------------------ | ---------------------------------------------------------------------------- |
| Dartファイルの追加・削除・リネーム                     | `docs/README.md`（ディレクトリ構成）, `docs/architecture.md`（ファイル一覧） |
| `pubspec.yaml` の依存追加・変更・削除                  | `docs/architecture.md`（依存パッケージ）                                     |
| `router.dart` のルート追加・変更                       | `docs/architecture.md`（ルーティング設計）                                   |
| データモデル（`*_service.dart`）のフィールド追加・変更 | `docs/data-model.md`                                                         |
| CRUD関数の追加・変更                                   | `docs/data-model.md`（CRUD操作）                                             |
| Hive Box の追加・Settings キーの追加                   | `docs/data-model.md`（Hive Box構成, Settings）                               |
| ウィジェットの追加・削除・責務変更                     | `docs/ui-screens.md`（ウィジェット一覧, ウィジェットツリー）                 |
| 画面レイアウトの変更                                   | `docs/ui-screens.md`（該当画面セクション）                                   |
| `app_strings.dart` への文字列追加・変更                | `docs/ui-screens.md`（UI文字列定義）                                         |
| 状態管理パターンの追加・変更                           | `docs/state-management.md`                                                   |
| テーマ・カラー・フォントの変更                         | `docs/theme.md`                                                              |
| テストの追加・変更                                     | `docs/testing.md`                                                            |
| 新機能の追加（複数ファイルにまたがる変更）             | 関連する全ドキュメント                                                       |

## 設計書の記述ルール

- 1ファイル500行以内。超える場合は分割する
- 冗長な説明は不要。テーブル形式を優先する
- コードブロックは設計理解に必要な最小限に留める（実装詳細はソースコードを参照）
- ファイルパスは `lib/` からの相対パスで記載する
- 日本語で記述する

## 設計書一覧

| ファイル                   | 内容                                                             |
| -------------------------- | ---------------------------------------------------------------- |
| `docs/README.md`           | プロジェクト概要・設計書目次・ディレクトリ構成                   |
| `docs/architecture.md`     | アーキテクチャ・ファイル一覧・依存関係・ルーティング・コード規約 |
| `docs/data-model.md`       | データモデル定義・Hive Box構成・CRUD操作                         |
| `docs/ui-screens.md`       | 画面設計・ウィジェットツリー・ウィジェット一覧・UI文字列         |
| `docs/state-management.md` | 状態管理パターン・データフロー・タイマー状態遷移                 |
| `docs/theme.md`            | テーマ設計・カラーパレット・フォント・コンポーネントスタイル     |
| `docs/testing.md`          | テスト方針・テストケース一覧・カバレッジ                         |

## 既存コード規約

以下のプロジェクト規約を理解し、新規コードでも遵守すること。

- **UI文字列**: `lib/shared/app_strings.dart` の `AppStrings` クラスに一元管理。ウィジェット内にハードコード禁止
- **自動生成ファイル**: `*.g.dart` は `dart run build_runner build` で生成。手動編集禁止
- **ウィジェット分割**: 1ファイル1パブリックウィジェット。プライベートヘルパーは同一ファイル内
- **画面構成**: `CustomScrollView` + `Sliver` ベース
- **状態管理**: 外部パッケージ不使用。`ChangeNotifier` + `ValueListenableBuilder` + コールバック
- **Lint**: `package:flutter_lints/flutter.yaml` 準拠
- **テーマ**: `lib/theme/app_theme.dart` の `buildAppTheme()` でライト/ダーク両対応。Material 3 使用
- **フォント**: BIZ UDGothic（`google_fonts`）
