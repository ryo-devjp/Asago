import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/home/widgets/task.dart';
import 'package:asago/home/widgets/complete_task_list.dart';
import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/task_service.dart';

/// ホーム画面のタスクセクション（セクションヘッダー + リスト）を
/// [Sliver] として提供するウィジェット群。
///
/// [TaskSectionHeader] と [TaskSectionList] を組み合わせて使用する。

// ── セクションヘッダー ──────────────────────────────────

/// 「タスク」のセクション見出し。
class TaskSectionHeader extends StatelessWidget {
  const TaskSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 4),
        child: Row(
          children: [
            Icon(Icons.task_alt, size: 20, color: cs.primary),
            const SizedBox(width: 8),
            Text(
              AppStrings.taskSectionTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── タスクリスト本体 ────────────────────────────────────

/// 未完了タスク + 完了済みタスク折りたたみを Sliver で表示する。
///
/// Hive の tasks ボックスを監視し、変更時に自動で再描画する。
class TaskSectionList extends StatelessWidget {
  const TaskSectionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Task>('tasks').listenable(),
      builder: (context, Box<Task> box, _) {
        final todoList = box.values.where((t) => !t.isCompleted).toList();
        final completedList = box.values.where((t) => t.isCompleted).toList();

        return SliverList(
          delegate: SliverChildListDelegate([
            if (todoList.isEmpty)
              _EmptyTaskPlaceholder()
            else
              ...todoList.map(
                (task) => TaskTile(
                  key: ValueKey(task.id),
                  title: task.task,
                  onDismissed: () => completeTask(task.id),
                ),
              ),
            if (completedList.isNotEmpty)
              _CompletedTaskSection(completedList: completedList),
            const SizedBox(height: 24),
          ]),
        );
      },
    );
  }
}

// ── プライベートヘルパー ────────────────────────────────

class _EmptyTaskPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.lightbulb_outline_sharp,
              size: 48,
              color: cs.onSurface.withAlpha(80),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.taskAllCompleted,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withAlpha(130),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedTaskSection extends StatelessWidget {
  const _CompletedTaskSection({required this.completedList});

  final List<Task> completedList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Theme(
      data: theme.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            AppStrings.completedTaskSection(completedList.length),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withAlpha(150),
            ),
          ),
          children: completedList
              .map(
                (task) => CompleteTaskList(
                  title: task.task,
                  onRestore: () => restoreTask(task.id),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
