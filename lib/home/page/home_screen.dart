import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:asago/home/widgets/count_down.dart';
import 'package:asago/home/widgets/countdown_card.dart';
import 'package:asago/home/widgets/item_section.dart';
import 'package:asago/home/widgets/task_section.dart';
import 'package:asago/shared/app_strings.dart';

/// ホーム画面。
///
/// カウントダウンリングカードとタスクリストを縦に並べる。
/// 各セクションは専用ウィジェットに委譲し、このクラスは
/// レイアウトの組み立てのみを担当する。
class Homescreen extends StatelessWidget {
  const Homescreen({super.key, required this.timerController});

  final CountDownTimer timerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Today ラベル
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Text(
                  AppStrings.homeHeader,
                  style: GoogleFonts.bizUDGothic(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // カウントダウン リングカード
            SliverToBoxAdapter(
              child: CountdownCard(timerController: timerController),
            ),

            // タスクセクション
            const TaskSectionHeader(),
            const TaskSectionList(),

            // 持ち物セクション
            const ItemSectionHeader(),
            const ItemSectionList(),
          ],
        ),
      ),
    );
  }
}
