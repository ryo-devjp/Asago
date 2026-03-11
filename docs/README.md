# Asago 設計書

## プロジェクト概要

| 項目         | 内容                                                                 |
| ------------ | -------------------------------------------------------------------- |
| アプリ名     | Asago                                                                |
| 種別         | Flutter モバイルアプリ（iOS / Android）                              |
| 目的         | 朝のルーティンを管理し遅刻を防ぐタイマーアプリ                       |
| ターゲット   | ADHD・グレーゾーンの方を含む、朝の準備に課題を持つユーザー           |
| 主要機能     | 出発時刻カウントダウン、タスク管理、持ち物チェック                   |
| SDK          | Flutter (Dart ^3.10.4)                                               |
| 状態管理     | ChangeNotifier + Hive ValueListenableBuilder（外部パッケージ不使用） |
| ローカルDB   | Hive                                                                 |
| ルーティング | GoRouter（StatefulShellRoute による2タブ構成）                       |

## 設計書一覧

| ドキュメント                               | 内容                                                         |
| ------------------------------------------ | ------------------------------------------------------------ |
| [architecture.md](architecture.md)         | アーキテクチャ・ディレクトリ構成・依存関係・ルーティング     |
| [data-model.md](data-model.md)             | データモデル定義・Hive Box構成・CRUD操作                     |
| [ui-screens.md](ui-screens.md)             | 画面設計・ウィジェットツリー・ユーザー操作フロー             |
| [state-management.md](state-management.md) | 状態管理パターン・データフロー・タイマー状態遷移             |
| [theme.md](theme.md)                       | テーマ設計・カラーパレット・フォント・コンポーネントスタイル |
| [testing.md](testing.md)                   | テスト方針・現在のカバレッジ・テストケース一覧               |

## AI向け設計書自動更新指示

[.github/copilot-instructions.md](../.github/copilot-instructions.md) にコード変更時の設計書同期更新ルールを定義。

## ディレクトリ構成

```
lib/
├── main.dart                    # エントリポイント
├── router.dart                  # GoRouter定義
├── bottom_nav.dart              # BottomNavigationBar
├── home/
│   ├── page/
│   │   └── home_screen.dart     # ホーム画面
│   └── widgets/
│       ├── count_down.dart      # CountDownTimer (ChangeNotifier)
│       ├── countdown_card.dart  # カウントダウン+サマリカード
│       ├── status_emoji_card.dart # ステータス顔文字カード
│       ├── bounce_emoji.dart    # 上下バウンスアニメーション
│       ├── departure_status.dart # ステータス判定ロジック
│       ├── task_summary.dart    # タスク件数サマリ
│       ├── info_row.dart        # アイコン+ラベル+値の1行
│       ├── task.dart            # TaskTile (Dismissible)
│       ├── task_section.dart    # タスクセクション (Sliver)
│       ├── item_section.dart    # 持ち物セクション (Sliver)
│       └── complete_task_list.dart # 完了済みリスト行
├── setting/
│   ├── page/
│   │   └── setting_screen.dart  # 設定画面
│   └── widgets/
│       ├── time_picker.dart     # 出発時刻設定
│       ├── register_task.dart   # タスク登録モーダル
│       ├── register_items.dart  # 持ち物登録モーダル
│       ├── task_list.dart       # 登録済みタスク一覧
│       └── item_list.dart       # 登録済み持ち物一覧
├── shared/
│   ├── app_strings.dart         # UI文字列一元管理
│   ├── task_service.dart        # Task モデル + CRUD
│   ├── task_service.g.dart      # Hive TypeAdapter (自動生成)
│   ├── item_service.dart        # Item モデル + CRUD
│   └── item_service.g.dart      # Hive TypeAdapter (自動生成)
└── theme/
    └── app_theme.dart           # テーマ定義
```
