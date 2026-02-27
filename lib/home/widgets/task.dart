import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.title, required this.onDismissed});

  final String title;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Dismissible(
        key: key!,
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade600],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 24,
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.green.shade600, Colors.green.shade400],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 24,
          ),
        ),
        onDismissed: (direction) {
          onDismissed();
        },
        child: Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            leading: Icon(Icons.flag_outlined, color: cs.primary),
            trailing: Icon(
              Icons.chevron_left,
              color: cs.onSurface.withAlpha(80),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
