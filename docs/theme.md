# テーマ設計

## 概要

**ファイル**: `lib/theme/app_theme.dart`
**方式**: `buildAppTheme(Brightness)` 関数で `ThemeData` を生成。ライト/ダーク両対応。
**適用**: `MaterialApp.router` で `theme` / `darkTheme` に設定、`ThemeMode.system` でシステム連動。

## カラーパレット

### ベースカラー

| 名前          | 定数           | Hex       | 用途                                             |
| ------------- | -------------- | --------- | ------------------------------------------------ |
| Primary Blue  | `primaryBlue`  | `#0055D4` | プライマリカラー（ボタン・アイコン・アクセント） |
| Accent Orange | `accentOrange` | `#FF6F00` | セカンダリカラー                                 |

### サーフェスカラー

| 用途                      | ライト    | ダーク    |
| ------------------------- | --------- | --------- |
| `surface`                 | `#FFFFFF` | `#1C1C1E` |
| `surfaceContainerHighest` | `#F2F3F7` | `#2C2C2E` |
| `scaffoldBackgroundColor` | `#F2F3F7` | `#121212` |

`ColorScheme.fromSeed(seedColor: primaryBlue)` をベースに、上記カラーを明示的にオーバーライド。

### 意味的カラー（ウィジェット内で直接使用）

| 色              | 用途           | 使用箇所                                         |
| --------------- | -------------- | ------------------------------------------------ |
| `Colors.green`  | 完了・確認済み | チェックアイコン、スワイプ背景                   |
| `Colors.orange` | 残りタスク     | TaskSummary の残り行アイコン                     |
| `cs.error`      | タイムアップ   | CountdownCard のカウントダウン表示（アラート時） |

## フォント

| 項目             | 値                                                             |
| ---------------- | -------------------------------------------------------------- |
| フォントファミリ | BIZ UDGothic (`google_fonts`)                                  |
| 適用方法         | `GoogleFonts.bizUDGothicTextTheme()` で `textTheme` 全体に適用 |
| 個別使用         | `GoogleFonts.bizUDGothic()` でカウントダウン表示等に直接指定   |

## コンポーネントテーマ

### AppBarTheme

| プロパティ                             | 値                     |
| -------------------------------------- | ---------------------- |
| `backgroundColor`                      | transparent            |
| `elevation` / `scrolledUnderElevation` | 0                      |
| `centerTitle`                          | false                  |
| `titleTextStyle`                       | BIZ UDGothic 22px bold |

### CardTheme

| プロパティ  | 値                            |
| ----------- | ----------------------------- |
| `elevation` | 0                             |
| `shape`     | RoundedRectangleBorder (16px) |
| `color`     | `colorScheme.surface`         |
| `margin`    | horizontal: 16, vertical: 6   |

### NavigationBarTheme

| プロパティ        | 値                          |
| ----------------- | --------------------------- |
| `backgroundColor` | `colorScheme.surface`       |
| `indicatorColor`  | `primaryBlue.withAlpha(30)` |
| `labelTextStyle`  | BIZ UDGothic 12px w500      |
| `height`          | 64                          |

### ElevatedButtonTheme

| プロパティ        | 値                            |
| ----------------- | ----------------------------- |
| `backgroundColor` | `primaryBlue`                 |
| `foregroundColor` | white                         |
| `shape`           | RoundedRectangleBorder (12px) |
| `padding`         | horizontal: 24, vertical: 14  |
| `textStyle`       | BIZ UDGothic 15px w600        |

### DividerTheme

| プロパティ  | 値  |
| ----------- | --- |
| `space`     | 0   |
| `thickness` | 0.5 |

## Material 3

`useMaterial3: true` を有効化。`ColorScheme.fromSeed()` による Material 3 カラースキーム生成を使用。
