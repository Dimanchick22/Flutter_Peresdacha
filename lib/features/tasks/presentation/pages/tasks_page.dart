import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_plus/core/constants/app_constants.dart';
import 'package:planner_plus/core/navigation/app_router.dart';
import 'package:planner_plus/features/tasks/presentation/providers/connectivity_provider.dart';
import 'package:planner_plus/features/tasks/presentation/providers/task_controller.dart';
import 'package:planner_plus/features/tasks/presentation/providers/task_grouping.dart';
import 'package:planner_plus/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:planner_plus/features/tasks/presentation/widgets/connectivity_banner.dart';
import 'package:planner_plus/features/tasks/presentation/widgets/empty_tasks_state.dart';
import 'package:planner_plus/features/tasks/presentation/widgets/grouped_task_list.dart';
import 'package:planner_plus/features/tasks/presentation/widgets/task_search_bar.dart';
import 'package:planner_plus/features/tasks/presentation/widgets/task_stats_card.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(filteredTasksProvider);
    final stats = ref.watch(taskStatsProvider);
    final connectivityStatus = ref.watch(connectivityStatusProvider);
    final currentGrouping = ref.watch(taskGroupingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner+'),
        actions: [
          PopupMenuButton<TaskGrouping>(
            icon: const Icon(Icons.group_work),
            tooltip: 'Group by',
            onSelected: (grouping) {
              ref.read(taskGroupingProvider.notifier).state = grouping;
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: TaskGrouping.none,
                child: Row(
                  children: [
                    Icon(
                      Icons.list,
                      color: currentGrouping == TaskGrouping.none
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'No grouping',
                      style: TextStyle(
                        fontWeight: currentGrouping == TaskGrouping.none
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskGrouping.date,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: currentGrouping == TaskGrouping.date
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Group by date',
                      style: TextStyle(
                        fontWeight: currentGrouping == TaskGrouping.date
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskGrouping.priority,
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: currentGrouping == TaskGrouping.priority
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Group by priority',
                      style: TextStyle(
                        fontWeight: currentGrouping == TaskGrouping.priority
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskGrouping.tags,
                child: Row(
                  children: [
                    Icon(
                      Icons.label,
                      color: currentGrouping == TaskGrouping.tags
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Group by tags',
                      style: TextStyle(
                        fontWeight: currentGrouping == TaskGrouping.tags
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskGrouping.status,
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: currentGrouping == TaskGrouping.status
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Group by status',
                      style: TextStyle(
                        fontWeight: currentGrouping == TaskGrouping.status
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await ref.read(taskControllerProvider.notifier).syncTasks();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tasks synced successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          connectivityStatus.when(
            data: (isOnline) => ConnectivityBanner(isOnline: isOnline),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TaskStatsCard(stats: stats),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            child: TaskSearchBar(),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          Expanded(
            child: tasks.isEmpty
                ? const EmptyTasksState()
                : const GroupedTaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.createTask),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}