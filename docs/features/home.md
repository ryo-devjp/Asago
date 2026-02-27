# Feature: ホーム画面

## 遷移元画面
- 起動画面
- 設定画面

## 遷移先画面
- 設定画面

## 初期処理

1. 残り時刻を計算し表示する
   - Hiveの `settings` ボックスから `departureHour` と `departureMinute` を取得する。
   - 取得した時刻を `CountDownTimer` (共有インスタンス `sharedTimer`) にセットする。
   - `CountDownTimer` 内部で現在時刻との差分を定期的に計算し、UIを更新して残り時間を表示する。

2. タスクを読み込み表示する
 - Hiveの`tasks`ボックスから`task`と`duration`、`isCompleted`を取得する。
 - ListViewにセットして表示する

## 各種処理

- タスクをスワイプして完了させる

## データ構造