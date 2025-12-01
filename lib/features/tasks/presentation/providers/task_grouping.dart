import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/presentation/providers/tasks_provider.dart';

enum TaskGrouping {
  none,
  date,
  priority,
  tags,
  status,
}

final taskGroupingProvider = StateProvider<TaskGrouping>((ref) {
  return TaskGrouping.none;
});

class TaskGroup {
  const TaskGroup({
    required this.title,
    required this.tasks,
  });

  final String title;
  final List<Task> tasks;
}

final groupedTasksProvider = Provider<List<TaskGroup>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final grouping = ref.watch(taskGroupingProvider);

  switch (grouping) {
    case TaskGrouping.date:
      return _groupByDate(tasks);
    case TaskGrouping.priority:
      return _groupByPriority(tasks);
    case TaskGrouping.tags:
      return _groupByTags(tasks);
    case TaskGrouping.status:
      return _groupByStatus(tasks);
    case TaskGrouping.none:
      return [TaskGroup(title: 'All Tasks', tasks: tasks)];
  }
});

List<TaskGroup> _groupByDate(List<Task> tasks) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final weekEnd = today.add(const Duration(days: 7));

  final groups = [
    TaskGroup(
      title: 'Overdue',
      tasks: tasks
          .where((t) =>
              t.dueDate != null &&
              t.dueDate!.isBefore(today) &&
              !t.isCompleted)
          .toList(),
    ),
    TaskGroup(
      title: 'Today',
      tasks: tasks
          .where((t) => t.dueDate != null && _isSameDay(t.dueDate!, today))
          .toList(),
    ),
    TaskGroup(
      title: 'Tomorrow',
      tasks: tasks
          .where((t) => t.dueDate != null && _isSameDay(t.dueDate!, tomorrow))
          .toList(),
    ),
    TaskGroup(
      title: 'This Week',
      tasks: tasks
          .where((t) =>
              t.dueDate != null &&
              t.dueDate!.isAfter(tomorrow) &&
              t.dueDate!.isBefore(weekEnd))
          .toList(),
    ),
    TaskGroup(
      title: 'Later',
      tasks: tasks
          .where(
              (t) => t.dueDate != null && t.dueDate!.isAfter(weekEnd))
          .toList(),
    ),
    TaskGroup(
      title: 'No Date',
      tasks: tasks.where((t) => t.dueDate == null).toList(),
    ),
  ];

  return groups.where((group) => group.tasks.isNotEmpty).toList();
}

List<TaskGroup> _groupByPriority(List<Task> tasks) {
  final groups = [
    TaskGroup(
      title: 'High Priority',
      tasks: tasks.where((t) => t.priority == TaskPriority.high).toList(),
    ),
    TaskGroup(
      title: 'Medium Priority',
      tasks: tasks.where((t) => t.priority == TaskPriority.medium).toList(),
    ),
    TaskGroup(
      title: 'Low Priority',
      tasks: tasks.where((t) => t.priority == TaskPriority.low).toList(),
    ),
  ];

  return groups.where((group) => group.tasks.isNotEmpty).toList();
}

List<TaskGroup> _groupByTags(List<Task> tasks) {
  final tagGroups = <String, List<Task>>{};

  for (final task in tasks) {
    if (task.tags.isEmpty) {
      tagGroups.putIfAbsent('No Tags', () => []).add(task);
    } else {
      for (final tag in task.tags) {
        tagGroups.putIfAbsent(tag, () => []).add(task);
      }
    }
  }

  return tagGroups.entries
      .map((entry) => TaskGroup(
            title: entry.key,
            tasks: entry.value,
          ))
      .toList();
}

List<TaskGroup> _groupByStatus(List<Task> tasks) {
  final groups = [
    TaskGroup(
      title: 'Active',
      tasks: tasks.where((t) => !t.isCompleted).toList(),
    ),
    TaskGroup(
      title: 'Completed',
      tasks: tasks.where((t) => t.isCompleted).toList(),
    ),
  ];

  return groups.where((group) => group.tasks.isNotEmpty).toList();
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}