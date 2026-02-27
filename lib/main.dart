import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/router.dart';
import 'package:asago/shared/app_strings.dart';
import 'package:asago/shared/item_service.dart';
import 'package:asago/shared/task_service.dart';
import 'package:asago/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox('settings');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Item>('items');
  _loadSavedTime();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
    );
  }
}

/// Hive に保存された出発時刻を読み込みタイマーにセットする。
void _loadSavedTime() {
  final box = Hive.box('settings');
  final hour = box.get('departureHour');
  final minute = box.get('departureMinute');
  if (hour != null && minute != null) {
    sharedTimer.setTargetTime(TimeOfDay(hour: hour, minute: minute));
  }
}
