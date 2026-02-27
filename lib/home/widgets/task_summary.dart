import 'package:flutter/material.dart';

import 'package:asago/home/widgets/info_row.dart';
import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/task_service.dart';

/// タスクの全体・完了・残り件数を [InfoRow] で縦に並べるサマリウィジェット。
class TaskSummary extends StatelessWidget {
  const TaskSummary({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = tasks.length;
    final done = tasks.where((t) => t.isCompleted).length;
    final remaining = total - done;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(
          icon: Icons.flag_outlined,
          iconColor: cs.primary,
          label: AppStrings.taskSummaryTotal,
          value: '$total',
        ),
        const SizedBox(height: 12),
        InfoRow(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          label: AppStrings.taskSummaryDone,
          value: '$done',
        ),
        const SizedBox(height: 12),
        InfoRow(
          icon: Icons.radio_button_unchecked,
          iconColor: Colors.orange,
          label: AppStrings.taskSummaryRemaining,
          value: '$remaining',
        ),
      ],
    );
  }
}
