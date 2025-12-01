import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';

class SearchTasks {
  const SearchTasks(this._repository);

  final TaskRepository _repository;

  Future<List<Task>> call(String query) async {
    if (query.trim().isEmpty) {
      return _repository.getTasks();
    }
    return _repository.searchTasks(query);
  }
}
