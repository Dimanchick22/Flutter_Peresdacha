import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_plus/core/di/injection.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';

class TaskController extends StateNotifier<AsyncValue<void>> {
  TaskController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    TaskPriority priority = TaskPriority.medium,
    List<String> tags = const [],
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final createTask = _ref.read(createTaskUseCaseProvider);
      await createTask(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        tags: tags,
      );
    });
  }

  Future<void> updateTask(Task task) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final updateTask = _ref.read(updateTaskUseCaseProvider);
      await updateTask(task);
    });
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final deleteTask = _ref.read(deleteTaskUseCaseProvider);
      await deleteTask(taskId);
    });
  }

  Future<void> syncTasks() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final syncTasks = _ref.read(syncTasksUseCaseProvider);
      await syncTasks();
    });
  }
}

final taskControllerProvider =
    StateNotifierProvider<TaskController, AsyncValue<void>>((ref) {
  return TaskController(ref);
});
