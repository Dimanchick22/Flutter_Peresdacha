import 'package:flutter_test/flutter_test.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';

void main() {
  group('Task', () {
    test('should create a task with required fields', () {
      final now = DateTime.now();
      const id = 'test-id';
      const title = 'Test Task';

      final task = Task(
        id: id,
        title: title,
        createdAt: now,
        updatedAt: now,
      );

      expect(task.id, id);
      expect(task.title, title);
      expect(task.createdAt, now);
      expect(task.updatedAt, now);
      expect(task.description, null);
      expect(task.dueDate, null);
      expect(task.priority, TaskPriority.medium);
      expect(task.tags, isEmpty);
      expect(task.isCompleted, false);
      expect(task.isSynced, false);
    });

    test('should create a task with all fields', () {
      final now = DateTime.now();
      final dueDate = now.add(const Duration(days: 1));

      final task = Task(
        id: 'test-id',
        title: 'Test Task',
        description: 'Test Description',
        dueDate: dueDate,
        priority: TaskPriority.high,
        tags: const ['work', 'urgent'],
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
        isSynced: true,
      );

      expect(task.description, 'Test Description');
      expect(task.dueDate, dueDate);
      expect(task.priority, TaskPriority.high);
      expect(task.tags, ['work', 'urgent']);
      expect(task.isCompleted, true);
      expect(task.isSynced, true);
    });

    test('should create a copy with updated fields', () {
      final now = DateTime.now();
      final task = Task(
        id: 'test-id',
        title: 'Original Title',
        createdAt: now,
        updatedAt: now,
      );

      final updatedTask = task.copyWith(
        title: 'Updated Title',
        isCompleted: true,
      );

      expect(updatedTask.id, task.id);
      expect(updatedTask.title, 'Updated Title');
      expect(updatedTask.isCompleted, true);
      expect(updatedTask.createdAt, task.createdAt);
    });

    test('should be equal when all properties match', () {
      final now = DateTime.now();
      final task1 = Task(
        id: 'test-id',
        title: 'Test Task',
        createdAt: now,
        updatedAt: now,
      );
      final task2 = Task(
        id: 'test-id',
        title: 'Test Task',
        createdAt: now,
        updatedAt: now,
      );

      expect(task1, equals(task2));
    });

    test('should not be equal when properties differ', () {
      final now = DateTime.now();
      final task1 = Task(
        id: 'test-id-1',
        title: 'Test Task 1',
        createdAt: now,
        updatedAt: now,
      );
      final task2 = Task(
        id: 'test-id-2',
        title: 'Test Task 2',
        createdAt: now,
        updatedAt: now,
      );

      expect(task1, isNot(equals(task2)));
    });
  });

  group('TaskPriority', () {
    test('should have correct display names', () {
      expect(TaskPriority.low.displayName, 'Low');
      expect(TaskPriority.medium.displayName, 'Medium');
      expect(TaskPriority.high.displayName, 'High');
    });
  });
}
