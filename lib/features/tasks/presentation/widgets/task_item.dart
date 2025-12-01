import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:planner_plus/core/constants/app_constants.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    required this.task,
    required this.onTap,
    required this.onToggle,
    super.key,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd');

    return Semantics(
      label: _buildSemanticLabel(dateFormat),
      button: true,
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: task.isCompleted
                      ? 'Mark task as incomplete'
                      : 'Mark task as complete',
                  button: true,
                  child: ExcludeSemantics(
                    child: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => onToggle(),
                      shape: const CircleBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: AppConstants.smallPadding),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExcludeSemantics(
                        child: Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? theme.colorScheme.onSurface.withOpacity(0.6)
                                : null,
                          ),
                        ),
                      ),

                      if (task.description != null) ...[
                        const SizedBox(height: AppConstants.smallPadding / 2),
                        ExcludeSemantics(
                          child: Text(
                            task.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],

                      const SizedBox(height: AppConstants.smallPadding),

                      ExcludeSemantics(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.smallPadding,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(task.priority)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                task.priority.displayName,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _getPriorityColor(task.priority),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            if (task.dueDate != null) ...[
                              const SizedBox(width: AppConstants.smallPadding),
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: _isOverdue(task)
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dateFormat.format(task.dueDate!),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _isOverdue(task)
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                ),
                              ),
                            ],

                            if (!task.isSynced) ...[
                              const SizedBox(width: AppConstants.smallPadding),
                              Tooltip(
                                message: 'Not synced',
                                child: Icon(
                                  Icons.cloud_off,
                                  size: 14,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.4),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      if (task.tags.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.smallPadding),
                        ExcludeSemantics(
                          child: Wrap(
                            spacing: AppConstants.smallPadding / 2,
                            runSpacing: AppConstants.smallPadding / 2,
                            children: task.tags.take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.smallPadding,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: theme.textTheme.labelSmall,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: AppConstants.shortAnimationDuration)
          .slideY(
            begin: 0.1,
            end: 0,
            duration: AppConstants.shortAnimationDuration,
          ),
    );
  }

  String _buildSemanticLabel(DateFormat dateFormat) {
    final buffer = StringBuffer();

    buffer.write('Task: ${task.title}. ');
    buffer.write(task.isCompleted ? 'Completed. ' : 'Not completed. ');

    if (task.description != null && task.description!.isNotEmpty) {
      buffer.write('Description: ${task.description}. ');
    }

    buffer.write('${task.priority.displayName} priority. ');

    if (task.dueDate != null) {
      if (_isOverdue(task)) {
        buffer.write('Overdue. ');
      }
      buffer.write('Due ${dateFormat.format(task.dueDate!)}. ');
    }

    if (task.tags.isNotEmpty) {
      buffer.write('Tags: ${task.tags.join(", ")}. ');
    }

    if (!task.isSynced) {
      buffer.write('Not synchronized. ');
    }

    buffer.write('Double tap to view details.');

    return buffer.toString();
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

  bool _isOverdue(Task task) {
    if (task.dueDate == null || task.isCompleted) return false;
    return task.dueDate!.isBefore(DateTime.now());
  }
}