import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:planner_plus/core/constants/app_constants.dart';
import 'package:planner_plus/core/navigation/app_router.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/presentation/providers/task_controller.dart';
import 'package:planner_plus/features/tasks/presentation/providers/tasks_provider.dart';

class TaskDetailsPage extends ConsumerWidget {
  const TaskDetailsPage({
    required this.taskId,
    super.key,
  });

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskByIdProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push(
                AppRouter.editTask.replaceFirst(':id', taskId),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await _showDeleteConfirmation(context);
              if (confirmed == true && context.mounted) {
                await ref
                    .read(taskControllerProvider.notifier)
                    .deleteTask(taskId);
                if (context.mounted) {
                  context.pop();
                }
              }
            },
          ),
        ],
      ),
      body: taskAsync.when(
        data: (task) {
          if (task == null) {
            return const Center(
              child: Text('Task not found'),
            );
          }
          return _TaskDetailsContent(task: task);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _TaskDetailsContent extends ConsumerWidget {
  const _TaskDetailsContent({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          Row(
            children: [
              Chip(
                label: Text(task.isCompleted ? 'Completed' : 'Pending'),
                backgroundColor: task.isCompleted
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Chip(
                label: Text(task.priority.displayName),
                backgroundColor: _getPriorityColor(task.priority)
                    .withOpacity(0.2),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.largePadding),

          if (task.description != null) ...[
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              task.description!,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],

          if (task.dueDate != null) ...[
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Due Date',
              value: dateFormat.format(task.dueDate!),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
          ],

          if (task.tags.isNotEmpty) ...[
            Text(
              'Tags',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Wrap(
              spacing: AppConstants.smallPadding,
              runSpacing: AppConstants.smallPadding,
              children: task.tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],

          _DetailRow(
            icon: Icons.access_time,
            label: 'Created',
            value: dateFormat.format(task.createdAt),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _DetailRow(
            icon: Icons.update,
            label: 'Last Updated',
            value: dateFormat.format(task.updatedAt),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _DetailRow(
            icon: task.isSynced ? Icons.cloud_done : Icons.cloud_off,
            label: 'Sync Status',
            value: task.isSynced ? 'Synced' : 'Not synced',
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppConstants.smallPadding),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
