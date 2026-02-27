import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:asago/shared/app_strings.dart';

class CountDownTimer extends ChangeNotifier {
  Timer? _timer;
  Timer? _alertTimer;
  late DateTime _endTime;
  Duration _remainingTime = Duration.zero;
  bool _isAlerting = false;

  /// タイムアップ後にバイブが鳴り続けている状態かどうか
  bool get isAlerting => _isAlerting;

  /// タイマーがセットされたかどうか
  bool _isTimeSet = false;
  bool get isTimeSet => _isTimeSet;

  Duration get remainingTime => _remainingTime;

  /// ビューで使用するためのフォーマット済み時間文字列
  /// 例: 00時間15分00秒
  String get formattedTime {
    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    return AppStrings.formattedDuration(hours, minutes, seconds);
  }

  /// 短縮表示: "1:23:45"
  String get compactTime {
    final h = _remainingTime.inHours;
    final m = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  // コンストラクタでタイマーを開始
  CountDownTimer({int minutes = 1}) {
    startTimer(minutes);
  }

  void startTimer(int minutes) {
    _endTime = DateTime.now().add(Duration(minutes: minutes));
    _startTicking();
  }

  /// 指定した時刻までカウントダウン
  void setTargetTime(TimeOfDay time) {
    _isTimeSet = true;
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    _endTime = target;
    _startTicking();
  }

  void _startTicking() {
    _updateTime();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    if (!_isTimeSet) return;
    final now = DateTime.now();
    final difference = _endTime.difference(now);

    if (difference.isNegative) {
      _remainingTime = Duration.zero;
      _timer?.cancel();
      if (!_isAlerting) _startAlerting();
    } else {
      _remainingTime = difference;
    }
    // リスナー（画面など）に変更を通知
    notifyListeners();
  }

  /// タイムアップ後に繰り返しバイブを開始する
  void _startAlerting() {
    _isAlerting = true;
    // 即時1回バイブ
    HapticFeedback.vibrate();
    // 以降1秒ごとに繰り返す
    _alertTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      HapticFeedback.vibrate();
    });
    notifyListeners();
  }

  /// 「出発した」ボタンを押したときにアラートを停止する
  void stopAlert() {
    _alertTimer?.cancel();
    _alertTimer = null;
    _isAlerting = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _alertTimer?.cancel();
    super.dispose();
  }
}
