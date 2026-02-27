import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/home/widgets/count_down.dart';
import 'package:asago/home/widgets/task_summary.dart';
import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/task_service.dart';

/// カウントダウン + タスクサマリを1枚のカードに配置するウィジェット。
class CountdownCard extends StatelessWidget {
  const CountdownCard({super.key, required this.timerController});

  final CountDownTimer timerController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedBuilder(
          animation: timerController,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── ヘッダ行: タイトル + コンパクト時刻 ──
                Row(
                  children: [
                    Icon(Icons.schedule, size: 20, color: cs.primary),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.countdownCardTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── 大きなカウントダウン表示 ──
                Center(
                  child: Text(
                    timerController.isTimeSet
                        ? timerController.compactTime
                        : '--:--',
                    style: GoogleFonts.bizUDGothic(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: timerController.isAlerting ? cs.error : cs.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── タスクサマリ ──
                ValueListenableBuilder(
                  valueListenable: Hive.box<Task>('tasks').listenable(),
                  builder: (context, Box<Task> box, _) {
                    return TaskSummary(tasks: box.values.toList());
                  },
                ),

                // タイムアップ後: 「出発した！」ボタンでバイブを停止
                if (timerController.isAlerting) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: timerController.stopAlert,
                      icon: const Icon(Icons.directions_run),
                      label: const Text(AppStrings.departedButton),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
