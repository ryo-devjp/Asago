import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/home/widgets/bounce_emoji.dart';
import 'package:asago/home/widgets/count_down.dart';
import 'package:asago/home/widgets/departure_status.dart';
import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/task_service.dart';

/// 出発時間から逆算した余裕度を顔文字 + メッセージで表示するカード。
///
/// タイマー未設定時は何も描画しない。
class StatusEmojiCard extends StatelessWidget {
  const StatusEmojiCard({super.key, required this.timerController});

  final CountDownTimer timerController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AnimatedBuilder(
      animation: timerController,
      builder: (context, _) {
        if (!timerController.isTimeSet) return const SizedBox.shrink();

        return ValueListenableBuilder(
          valueListenable: Hive.box<Task>('tasks').listenable(),
          builder: (context, Box<Task> box, _) {
            final status = DepartureStatus.evaluate(
              remainingTime: timerController.remainingTime,
              isAlerting: timerController.isAlerting,
              tasks: box.values.toList(),
            );

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ── ヘッダ行 ──
                    Row(
                      children: [
                        Icon(Icons.mood, size: 20, color: cs.primary),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.statusCardTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── 顔文字（バウンスアニメーション付き）──
                    BounceEmoji(
                      child: Text(
                        status.emoji,
                        style: const TextStyle(fontSize: 56),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── メッセージ ──
                    Text(
                      status.message,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
