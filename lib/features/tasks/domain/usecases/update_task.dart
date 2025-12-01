import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';

class UpdateTask {
  const UpdateTask(this._repository);

  final TaskRepository _repository;

  Future<Task> call(Task task) async {
    final updatedTask = task.copyWith(
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    return _repository.updateTask(updatedTask);
  }
}
