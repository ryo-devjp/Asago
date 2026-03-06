/// アプリ内のすべての UI 文字列を一元管理するクラス。
///
/// 将来 flutter_localizations (ARB) に移行する際は、
/// このクラスの定数を .arb ファイルへ移すだけでよい。
abstract final class AppStrings {
  // ── アプリ全般 ──────────────────────────────────────────────
  static const appTitle = 'Asago';

  // ── ナビゲーション ───────────────────────────────────────────
  static const navHome = 'ホーム';
  static const navSettings = '設定';

  // ── ホーム画面 ───────────────────────────────────────────────
  static const homeHeader = 'Today';

  // ── カウントダウンカード ─────────────────────────────────────
  static const countdownCardTitle = '出発まで';
  static const departedButton = '出発した！';

  /// カウントダウン表示フォーマット: "00時間15分00秒"
  static String formattedDuration(
    String hours,
    String minutes,
    String seconds,
  ) => '$hours時間$minutes分$seconds秒';

  // ── タスクサマリ ─────────────────────────────────────────────
  static const taskSummaryTotal = '全タスク';
  static const taskSummaryDone = '完了';
  static const taskSummaryRemaining = '残り';

  // ── タスクセクション ─────────────────────────────────────────
  static const taskSectionTitle = 'タスク';
  static const taskAllCompleted = 'すべてのタスクが完了しました！';
  static const restoreButton = '戻す';
  // ── 持ち物セクション ─────────────────────────────────────
  static const itemSectionTitle = '持ち物';
  static const itemAllCompleted = 'すべての持ち物を確認しました！';

  /// 確認済み持ち物折りたたみのタイトル: "確認済みの持ち物 (3)"
  static String completedItemSection(int count) => '確認済みの持ち物 ($count)';

  /// 完了タスク折りたたみのタイトル: "完了したタスク (3)"
  static String completedTaskSection(int count) => '完了したタスク ($count)';

  // ── 設定画面 ─────────────────────────────────────────────────
  static const settingsHeader = '設定';
  static const settingsRegisteredTasks = '登録済みのタスク';
  static const noTasksRegistered = 'タスクがまだ登録されていません';
  static const settingsRegisteredItems = '登録済みの持ち物';
  static const noItemsRegistered = '持ち物がまだ登録されていません';

  // 登録共通
  static const cancelButton = 'キャンセル';
  static const saveButton = '保存';

  // ── タスク登録モーダル ───────────────────────────────────────
  static const registerTaskButton = 'タスクを追加する';
  static const newTaskModalTitle = '新しいタスク';
  static const taskNameHint = 'タスク名を入力';
  static const taskDurationHint = 'このタスクの所要時間を入力してください';

  // ── 持ち物管理モーダル ───────────────────────────────────────
  static const addItemButton = '持ち物を追加する';
  static const manageItemsButton = '持ち物を管理する';
  static const itemsModalTitle = '持ち物リスト';
  static const itemNameHint = '持ち物名を入力';

  // ── 出発時刻設定 ─────────────────────────────────────────────
  static const departureTimeTitle = '出発時刻';
  static const setTimeButton = '時刻を設定';
}
