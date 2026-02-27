import 'package:flutter/material.dart';

import 'package:asago/shared/app_strings.dart';

class CompleteTaskList extends StatelessWidget {
  const CompleteTaskList({
    super.key,
    required this.title,
    required this.onRestore,
  });

  final String title;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
          color: cs.onSurface.withAlpha(100),
        ),
      ),
      leading: const Icon(Icons.check_circle, color: Colors.green),
      trailing: SizedBox(
        height: 32,
        child: OutlinedButton.icon(
          onPressed: onRestore,
          icon: const Icon(Icons.undo, size: 16),
          label: const Text(
            AppStrings.restoreButton,
            style: TextStyle(fontSize: 12),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.onSurface.withAlpha(150),
            side: BorderSide(color: cs.onSurface.withAlpha(60)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
