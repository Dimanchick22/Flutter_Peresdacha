import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

class CreateTask {
  const CreateTask(this._repository);

  final TaskRepository _repository;

  Future<Task> call({
    required String title,
    String? description,
    DateTime? dueDate,
    TaskPriority priority = TaskPriority.medium,
    List<String> tags = const [],
  }) async {
    final now = DateTime.now();
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      tags: tags,
      createdAt: now,
      updatedAt: now,
      isCompleted: false,
      isSynced: false,
    );

    return _repository.createTask(task);
  }
}
