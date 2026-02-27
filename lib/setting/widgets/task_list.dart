import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/task_service.dart';

/// 設定画面で登録済みタスクを一覧表示し、削除できるウィジェット。
class SettingTaskList extends StatelessWidget {
  const SettingTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ValueListenableBuilder(
      valueListenable: Hive.box<Task>('tasks').listenable(),
      builder: (context, Box<Task> box, _) {
        final tasks = box.values.toList();

        if (tasks.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                AppStrings.noTasksRegistered,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(130),
                ),
              ),
            ),
          );
        }

        return Column(
          children: tasks.map((task) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: task.isCompleted ? Colors.green : cs.primary,
                size: 22,
              ),
              title: Text(
                task.task,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  color: task.isCompleted ? cs.onSurface.withAlpha(100) : null,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: cs.onSurface.withAlpha(100),
                ),
                onPressed: () async {
                  await box.delete(task.id);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
