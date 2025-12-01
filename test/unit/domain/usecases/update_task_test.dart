import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';
import 'package:planner_plus/features/tasks/domain/usecases/update_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late UpdateTask useCase;
  late MockTaskRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(
      Task(
        id: 'test',
        title: 'Test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = UpdateTask(mockRepository);
  });

  group('UpdateTask', () {
    test('should update task and set isSynced to false', () async {
      final now = DateTime.now();
      final task = Task(
        id: '1',
        title: 'Original Title',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        isSynced: true,
      );

      when(() => mockRepository.updateTask(any())).thenAnswer(
        (invocation) async {
          final updatedTask = invocation.positionalArguments[0] as Task;
          return updatedTask;
        },
      );

      final result = await useCase(task);

      expect(result.id, task.id);
      expect(result.isSynced, false);
      expect(
        result.updatedAt.isAfter(task.updatedAt),
        true,
      );

      verify(() => mockRepository.updateTask(any())).called(1);
    });

    test('should preserve all task fields during update', () async {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: TaskPriority.high,
        tags: const ['work'],
        isCompleted: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(() => mockRepository.updateTask(any())).thenAnswer(
        (invocation) async {
          final updatedTask = invocation.positionalArguments[0] as Task;
          return updatedTask;
        },
      );

      final result = await useCase(task);

      expect(result.title, task.title);
      expect(result.description, task.description);
      expect(result.dueDate, task.dueDate);
      expect(result.priority, task.priority);
      expect(result.tags, task.tags);
      expect(result.isCompleted, task.isCompleted);
    });
  });
}
