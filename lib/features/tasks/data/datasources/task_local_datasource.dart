import 'package:hive/hive.dart';
import 'package:planner_plus/features/tasks/data/models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();

  Future<TaskModel?> getTaskById(String id);

  Future<void> saveTask(TaskModel task);

  Future<void> deleteTask(String id);

  Future<List<TaskModel>> getUnsyncedTasks();

  Future<void> clearAllTasks();

  Stream<List<TaskModel>> watchTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  TaskLocalDataSourceImpl(this._box);

  final Box<TaskModel> _box;

  static const String boxName = 'tasks';

  @override
  Future<List<TaskModel>> getTasks() async {
    return _box.values.toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<TaskModel>> getUnsyncedTasks() async {
    return _box.values.where((task) => !task.isSynced).toList();
  }

  @override
  Future<void> clearAllTasks() async {
    await _box.clear();
  }

  @override
  Stream<List<TaskModel>> watchTasks() async* {
    yield _box.values.toList();

    await for (final _ in _box.watch()) {
      yield _box.values.toList();
    }
  }
}
