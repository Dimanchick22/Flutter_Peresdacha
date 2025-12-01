import 'package:flutter/material.dart';
import 'package:planner_plus/core/constants/app_constants.dart';
import 'package:planner_plus/features/tasks/presentation/providers/tasks_provider.dart';

class TaskStatsCard extends StatelessWidget {
  const TaskStatsCard({
    required this.stats,
    super.key,
  });

  final TaskStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              icon: Icons.list,
              label: 'Total',
              value: '${stats.total}',
              color: theme.colorScheme.primary,
            ),
            _StatItem(
              icon: Icons.check_circle,
              label: 'Completed',
              value: '${stats.completed}',
              color: Colors.green,
            ),
            _StatItem(
              icon: Icons.pending,
              label: 'Pending',
              value: '${stats.pending}',
              color: Colors.orange,
            ),
            if (stats.overdue > 0)
              _StatItem(
                icon: Icons.warning,
                label: 'Overdue',
                value: '${stats.overdue}',
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
