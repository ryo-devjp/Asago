import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// アイコン + ラベル + 値 の1行サマリウィジェット。
///
/// カウントダウンカード内でタスク集計を表示するために使用する。
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.bizUDGothic(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
