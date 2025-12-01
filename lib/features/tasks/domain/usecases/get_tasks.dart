import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';

class GetTasks {
  const GetTasks(this._repository);

  final TaskRepository _repository;

  Future<List<Task>> call() async {
    return _repository.getTasks();
  }

  Stream<List<Task>> watch() {
    return _repository.watchTasks();
  }
}
