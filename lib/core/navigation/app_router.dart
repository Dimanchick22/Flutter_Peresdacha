import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_plus/features/tasks/presentation/pages/settings_page.dart';
import 'package:planner_plus/features/tasks/presentation/pages/task_details_page.dart';
import 'package:planner_plus/features/tasks/presentation/pages/task_form_page.dart';
import 'package:planner_plus/features/tasks/presentation/pages/tasks_page.dart';

class AppRouter {
  const AppRouter._();

  static const String tasks = '/';
  static const String taskDetails = '/task/:id';
  static const String createTask = '/task/create';
  static const String editTask = '/task/:id/edit';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: tasks,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: tasks,
        name: 'tasks',
        builder: (context, state) => const TasksPage(),
      ),
      GoRoute(
        path: taskDetails,
        name: 'taskDetails',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskDetailsPage(taskId: id);
        },
      ),
      GoRoute(
        path: createTask,
        name: 'createTask',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const TaskFormPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: editTask,
        name: 'editTask',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: TaskFormPage(taskId: id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
