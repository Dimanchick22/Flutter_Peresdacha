import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planner_plus/core/constants/app_constants.dart';
import 'package:planner_plus/core/navigation/app_router.dart';
import 'package:planner_plus/features/tasks/presentation/providers/task_controller.dart';
import 'package:planner_plus/features/tasks/presentation/providers/task_grouping.dart';
import 'package:planner_plus/features/tasks/presentation/widgets/task_item.dart';

class GroupedTaskList extends ConsumerWidget {
  const GroupedTaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupedTasksProvider);
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: AppConstants.smallPadding,
                bottom: AppConstants.smallPadding,
                top: index == 0 ? 0 : AppConstants.defaultPadding,
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(
                    group.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.smallPadding,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${group.tasks.length}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ...group.tasks.map(
              (task) => TaskItem(
                key: ValueKey(task.id),
                task: task,
                onTap: () => context.push(
                  AppRouter.taskDetails.replaceFirst(':id', task.id),
                ),
                onToggle: () {
                  ref
                      .read(taskControllerProvider.notifier)
                      .toggleTaskCompletion(task);
                },
              ),
            ),

            const SizedBox(height: AppConstants.smallPadding),
          ],
        );
      },
    );
  }
}