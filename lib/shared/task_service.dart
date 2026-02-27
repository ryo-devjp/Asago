import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'task_service.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String task;

  @HiveField(2)
  final int duration;

  @HiveField(3)
  bool isCompleted;

  Task({
    required this.id,
    required this.task,
    required this.duration,
    this.isCompleted = false,
  });
}

List<Task> getTasks() {
  final box = Hive.box<Task>('tasks');
  return box.values.toList();
}

Future<void> addTask(String task, int duration) async {
  final box = Hive.box<Task>('tasks');
  final id = const Uuid().v4();
  final newTask = Task(id: id, task: task, duration: duration);
  await box.put(id, newTask);
}

Future<void> completeTask(String id) async {
  final box = Hive.box<Task>('tasks');
  final task = box.get(id);
  if (task == null) return;
  task.isCompleted = true;
  await task.save();
}

Future<void> restoreTask(String id) async {
  final box = Hive.box<Task>('tasks');
  final task = box.get(id);
  if (task == null) return;
  task.isCompleted = false;
  await task.save();
}
