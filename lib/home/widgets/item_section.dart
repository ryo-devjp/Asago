import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/home/widgets/task.dart';
import 'package:asago/home/widgets/complete_task_list.dart';
import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/item_service.dart';

/// ホーム画面のタスクセクション（セクションヘッダー + リスト）を
/// [Sliver] として提供するウィジェット群。
///
/// [ItemSectionHeader] と [ItemSectionList] を組み合わせて使用する。

// ── セクションヘッダー ──────────────────────────────────

/// 「持ち物」のセクション見出し。
class ItemSectionHeader extends StatelessWidget {
  const ItemSectionHeader({super.key});

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
              AppStrings.itemSectionTitle,
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

// ── 持ち物リスト本体 ────────────────────────────────────

/// 未完了持ち物 + 完了済み持ち物折りたたみを Sliver で表示する。
///
/// Hive の items ボックスを監視し、変更時に自動で再描画する。
class ItemSectionList extends StatelessWidget {
  const ItemSectionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Item>('items').listenable(),
      builder: (context, Box<Item> box, _) {
        final todoList = box.values.where((t) => !t.isCompleted).toList();
        final completedList = box.values.where((t) => t.isCompleted).toList();

        return SliverList(
          delegate: SliverChildListDelegate([
            if (todoList.isEmpty)
              _EmptyItemPlaceholder()
            else
              ...todoList.map(
                (item) => TaskTile(
                  key: ValueKey(item.id),
                  title: item.item,
                  onDismissed: () => completeItem(item.id),
                ),
              ),
            if (completedList.isNotEmpty)
              _CompletedItemSection(completedList: completedList),
            const SizedBox(height: 24),
          ]),
        );
      },
    );
  }
}

// ── プライベートヘルパー ────────────────────────────────

class _EmptyItemPlaceholder extends StatelessWidget {
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
              AppStrings.itemAllCompleted,
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

class _CompletedItemSection extends StatelessWidget {
  const _CompletedItemSection({required this.completedList});

  final List<Item> completedList;

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
            AppStrings.completedItemSection(completedList.length),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withAlpha(150),
            ),
          ),
          children: completedList
              .map(
                (item) => CompleteTaskList(
                  title: item.item,
                  onRestore: () => restoreItem(item.id),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
