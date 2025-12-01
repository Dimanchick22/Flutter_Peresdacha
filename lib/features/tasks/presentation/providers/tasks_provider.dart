import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_plus/core/di/injection.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';

final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final getTasks = ref.watch(getTasksUseCaseProvider);
  return getTasks.watch();
});

final taskByIdProvider =
    StreamProvider.family<Task?, String>((ref, id) async* {
  final repository = ref.watch(taskRepositoryProvider);
  yield* repository.watchTaskById(id);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final taskFilterProvider = StateProvider<TaskFilter>((ref) {
  return const TaskFilter();
});

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasksAsync = ref.watch(tasksStreamProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final filter = ref.watch(taskFilterProvider);

  return tasksAsync.when(
    data: (tasks) {
      var filtered = tasks;

      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        filtered = filtered.where((task) {
          final titleMatch = task.title.toLowerCase().contains(query);
          final descriptionMatch =
              task.description?.toLowerCase().contains(query) ?? false;
          final tagsMatch =
              task.tags.any((tag) => tag.toLowerCase().contains(query));
          return titleMatch || descriptionMatch || tagsMatch;
        }).toList();
      }

      if (filter.isCompleted != null) {
        filtered = filtered
            .where((task) => task.isCompleted == filter.isCompleted)
            .toList();
      }

      if (filter.priority != null) {
        filtered = filtered
            .where((task) => task.priority == filter.priority)
            .toList();
      }

      if (filter.tags != null && filter.tags!.isNotEmpty) {
        filtered = filtered.where((task) {
          return task.tags.any((tag) => filter.tags!.contains(tag));
        }).toList();
      }

      switch (filter.sortBy) {
        case TaskSortBy.createdDate:
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        case TaskSortBy.dueDate:
          filtered.sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) return 0;
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          });
        case TaskSortBy.priority:
          filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        case TaskSortBy.title:
          filtered.sort((a, b) => a.title.compareTo(b.title));
      }

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasksAsync = ref.watch(tasksStreamProvider);

  return tasksAsync.when(
    data: (tasks) {
      final completed = tasks.where((task) => task.isCompleted).length;
      final pending = tasks.length - completed;
      final highPriority =
          tasks.where((task) => task.priority == TaskPriority.high).length;
      final overdue = tasks.where((task) {
        if (task.dueDate == null || task.isCompleted) return false;
        return task.dueDate!.isBefore(DateTime.now());
      }).length;

      return TaskStats(
        total: tasks.length,
        completed: completed,
        pending: pending,
        highPriority: highPriority,
        overdue: overdue,
      );
    },
    loading: () => const TaskStats(),
    error: (_, __) => const TaskStats(),
  );
});

class TaskFilter {
  const TaskFilter({
    this.isCompleted,
    this.priority,
    this.tags,
    this.sortBy = TaskSortBy.createdDate,
  });

  final bool? isCompleted;
  final TaskPriority? priority;
  final List<String>? tags;
  final TaskSortBy sortBy;

  TaskFilter copyWith({
    bool? isCompleted,
    TaskPriority? priority,
    List<String>? tags,
    TaskSortBy? sortBy,
  }) {
    return TaskFilter(
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

enum TaskSortBy {
  createdDate,
  dueDate,
  priority,
  title,
}

class TaskStats {
  const TaskStats({
    this.total = 0,
    this.completed = 0,
    this.pending = 0,
    this.highPriority = 0,
    this.overdue = 0,
  });

  final int total;
  final int completed;
  final int pending;
  final int highPriority;
  final int overdue;
}
