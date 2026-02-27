import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'item_service.g.dart';

@HiveType(typeId: 1)
class Item extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String item;

  @HiveField(2)
  bool isCompleted;

  Item({required this.id, required this.item, this.isCompleted = false});
}

List<Item> getItems() {
  final box = Hive.box<Item>('items');
  return box.values.toList();
}

Future<void> addItem(String item) async {
  final box = Hive.box<Item>('items');
  final id = const Uuid().v4();
  final newItem = Item(id: id, item: item);
  await box.put(id, newItem);
}

Future<void> completeItem(String id) async {
  final box = Hive.box<Item>('items');
  final item = box.get(id);
  if (item == null) return;
  item.isCompleted = true;
  await item.save();
}

Future<void> restoreItem(String id) async {
  final box = Hive.box<Item>('items');
  final item = box.get(id);
  if (item == null) return;
  item.isCompleted = false;
  await item.save();
}
