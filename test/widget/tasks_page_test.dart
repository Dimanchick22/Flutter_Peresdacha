import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/presentation/pages/tasks_page.dart';
import 'package:planner_plus/features/tasks/presentation/providers/connectivity_provider.dart';
import 'package:planner_plus/features/tasks/presentation/providers/tasks_provider.dart';

void main() {
  group('TasksPage Widget Tests', () {
    testWidgets('should display app title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tasksStreamProvider.overrideWith(
              (ref) => Stream.value([]),
            ),
            connectivityStatusProvider.overrideWith(
              (ref) => Stream.value(true),
            ),
          ],
          child: const MaterialApp(
            home: TasksPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Planner+'), findsOneWidget);
    });

    testWidgets('should display empty state when no tasks', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tasksStreamProvider.overrideWith(
              (ref) => Stream.value([]),
            ),
            connectivityStatusProvider.overrideWith(
              (ref) => Stream.value(true),
            ),
          ],
          child: const MaterialApp(
            home: TasksPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No tasks found'), findsOneWidget);
      expect(
        find.text('Create your first task to get started'),
        findsOneWidget,
      );
    });

    testWidgets('should display tasks when available', (tester) async {
      final now = DateTime.now();
      final tasks = [
        Task(
          id: '1',
          title: 'Task 1',
          createdAt: now,
          updatedAt: now,
        ),
        Task(
          id: '2',
          title: 'Task 2',
          description: 'Description 2',
          createdAt: now,
          updatedAt: now,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tasksStreamProvider.overrideWith(
              (ref) => Stream.value(tasks),
            ),
            connectivityStatusProvider.overrideWith(
              (ref) => Stream.value(true),
            ),
          ],
          child: const MaterialApp(
            home: TasksPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });

    testWidgets('should display FAB for adding tasks', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tasksStreamProvider.overrideWith(
              (ref) => Stream.value([]),
            ),
            connectivityStatusProvider.overrideWith(
              (ref) => Stream.value(true),
            ),
          ],
          child: const MaterialApp(
            home: TasksPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Add Task'), findsOneWidget);
    });
  });
}