import 'package:asago/setting/widgets/register_items.dart';
import 'package:asago/setting/widgets/item_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:asago/setting/widgets/time_picker.dart';
import 'package:asago/setting/widgets/register_task.dart';
import 'package:asago/setting/widgets/task_list.dart';
import 'package:asago/shared/app_strings.dart';

/// 設定画面。
///
/// 出発時刻の設定とタスク管理のカードを縦に並べる。
/// 各カードの中身は専用ウィジェットに委譲する。
class Settingscreen extends StatelessWidget {
  const Settingscreen({super.key, this.onTimeSelected});

  final void Function(TimeOfDay)? onTimeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── ヘッダー ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Text(
                  AppStrings.settingsHeader,
                  style: GoogleFonts.bizUDGothic(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ── 出発時刻カード ──
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Timepicker(onTimeSelected: onTimeSelected),
                ),
              ),
            ),

            // ── タスク管理カード ──
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            size: 20,
                            color: cs.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.settingsRegisteredTasks,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const SettingTaskList(),
                      const SizedBox(height: 8),
                      const RegisterTask(),
                    ],
                  ),
                ),
              ),
            ),

            // ---持ち物管理カード---
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            size: 20,
                            color: cs.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.settingsRegisteredItems,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const SettingItemList(),
                      const SizedBox(height: 8),
                      const RegisterItems(),
                    ],
                  ),
                ),
              ),
            ),
            // 下部余白
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
