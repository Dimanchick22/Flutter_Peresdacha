import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  const DeleteTask(this._repository);

  final TaskRepository _repository;

  Future<void> call(String taskId) async {
    return _repository.deleteTask(taskId);
  }
}
