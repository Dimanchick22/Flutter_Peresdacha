import 'package:planner_plus/core/errors/failures.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';


abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<Task?> getTaskById(String id);

  Future<Task> createTask(Task task);

  Future<Task> updateTask(Task task);

  Future<void> deleteTask(String id);

  Future<List<Task>> searchTasks(String query);

  Future<List<Task>> filterTasks({
    bool? isCompleted,
    TaskPriority? priority,
    List<String>? tags,
  });

  Future<void> syncTasks();

  Future<List<Task>> getUnsyncedTasks();

  Stream<List<Task>> watchTasks();

  Stream<Task?> watchTaskById(String id);
}
