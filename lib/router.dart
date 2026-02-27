import 'package:asago/home/page/home_screen.dart';
import 'package:asago/home/widgets/count_down.dart';
import 'package:asago/setting/page/setting_screen.dart';
import 'package:asago/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 共有タイマーインスタンス
final sharedTimer = CountDownTimer(minutes: 0);

final goRouter = GoRouter(
  // アプリが起動した時
  initialLocation: '/',
  // パスと画面の組み合わせ
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNav(navigationShell: navigationShell);
      },
      branches: [
        // ホームタブのブランチ
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: Homescreen(timerController: sharedTimer),
                );
              },
            ),
          ],
        ),
        // 設定タブのブランチ
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: Settingscreen(
                    onTimeSelected: (time) => sharedTimer.setTargetTime(time),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
  // 遷移ページがないなどのエラーが発生した時に、このページに行く
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(body: Center(child: Text(state.error.toString()))),
  ),
);
