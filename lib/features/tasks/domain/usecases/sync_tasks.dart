import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';

class SyncTasks {
  const SyncTasks(this._repository);

  final TaskRepository _repository;

  Future<void> call() async {
    return _repository.syncTasks();
  }
}
