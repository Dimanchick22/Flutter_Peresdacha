import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:planner_plus/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:planner_plus/features/tasks/data/models/task_model.dart';

class HiveStorage {
  const HiveStorage._();

  static Future<void> init() async {
    await Hive.initFlutter();

    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskPriorityModelAdapter());
    }

    await Hive.openBox<TaskModel>(TaskLocalDataSourceImpl.boxName);
    await Hive.openBox<String>('settings');
  }

  static Future<void> close() async {
    await Hive.close();
  }

  static Future<void> clearAll() async {
    await Hive.box<TaskModel>(TaskLocalDataSourceImpl.boxName).clear();
    await Hive.box<String>('settings').clear();
  }
}
