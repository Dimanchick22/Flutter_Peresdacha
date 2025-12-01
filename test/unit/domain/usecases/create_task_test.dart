import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';
import 'package:planner_plus/features/tasks/domain/usecases/create_task.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class FakeTask extends Fake implements Task {}

void main() {
  late CreateTask useCase;
  late MockTaskRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeTask());
  });

  setUp(() {
    mockRepository = MockTaskRepository();
    useCase = CreateTask(mockRepository);
  });

  group('CreateTask', () {
    test('should create a task with generated ID and timestamps', () async {
      const title = 'Test Task';
      const description = 'Test Description';
      final dueDate = DateTime.now().add(const Duration(days: 1));
      const priority = TaskPriority.high;
      const tags = ['work', 'urgent'];

      when(() => mockRepository.createTask(any())).thenAnswer(
        (invocation) async {
          final task = invocation.positionalArguments[0] as Task;
          return task;
        },
      );

      final result = await useCase(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        tags: tags,
      );

      expect(result.id, isNotEmpty);
      expect(result.title, title);
      expect(result.description, description);
      expect(result.dueDate, dueDate);
      expect(result.priority, priority);
      expect(result.tags, tags);
      expect(result.isCompleted, false);
      expect(result.isSynced, false);
      expect(result.createdAt, isNotNull);
      expect(result.updatedAt, isNotNull);

      verify(() => mockRepository.createTask(any())).called(1);
    });

    test('should create a task with minimum required fields', () async {
      const title = 'Minimal Task';

      when(() => mockRepository.createTask(any())).thenAnswer(
        (invocation) async {
          final task = invocation.positionalArguments[0] as Task;
          return task;
        },
      );

      final result = await useCase(title: title);

      expect(result.title, title);
      expect(result.description, null);
      expect(result.dueDate, null);
      expect(result.priority, TaskPriority.medium);
      expect(result.tags, isEmpty);

      verify(() => mockRepository.createTask(any())).called(1);
    });
  });
}