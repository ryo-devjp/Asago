import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/item_service.dart';

/// 設定画面で登録済みの持ち物を一覧表示し、削除できるウィジェット。
class SettingItemList extends StatelessWidget {
  const SettingItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ValueListenableBuilder(
      valueListenable: Hive.box<Item>('items').listenable(),
      builder: (context, Box<Item> box, _) {
        final items = box.values.toList();

        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                AppStrings.noItemsRegistered,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withAlpha(130),
                ),
              ),
            ),
          );
        }

        return Column(
          children: items.map((item) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                item.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: item.isCompleted ? Colors.green : cs.primary,
                size: 22,
              ),
              title: Text(
                item.item,
                style: TextStyle(
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  color: item.isCompleted ? cs.onSurface.withAlpha(100) : null,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: cs.onSurface.withAlpha(100),
                ),
                onPressed: () async {
                  await box.delete(item.id);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
