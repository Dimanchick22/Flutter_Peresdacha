import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:planner_plus/core/constants/app_constants.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/presentation/providers/task_controller.dart';
import 'package:planner_plus/features/tasks/presentation/providers/tasks_provider.dart';

class TaskFormPage extends ConsumerStatefulWidget {
  const TaskFormPage({this.taskId, super.key});

  final String? taskId;

  @override
  ConsumerState<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends ConsumerState<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  Task? _currentTask;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadTask();
      });
    }
  }

  void _loadTask() {
    final taskAsync = ref.read(taskByIdProvider(widget.taskId!));
    taskAsync.whenData((task) {
      if (task != null) {
        setState(() {
          _currentTask = task;
          _titleController.text = task.title;
          _descriptionController.text = task.description ?? '';
          _dueDate = task.dueDate;
          _priority = task.priority;
          _tagsController.text = task.tags.join(', ');
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.taskId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'Enter task title',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter task description',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textInputAction: TextInputAction.newline,
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            InkWell(
              onTap: () => _selectDueDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                child: Text(
                  _dueDate != null
                      ? DateFormat('MMM dd, yyyy').format(_dueDate!)
                      : 'Select date',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                prefixIcon: Icon(Icons.flag),
              ),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'Enter tags separated by commas',
                prefixIcon: Icon(Icons.label),
                helperText: 'Separate tags with commas (e.g., work, urgent)',
              ),
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: AppConstants.largePadding),

            FilledButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Update Task' : 'Create Task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final tagsText = _tagsController.text.trim();
    final tags = tagsText.isEmpty
        ? <String>[]
        : tagsText.split(',').map((tag) => tag.trim()).toList();

    final controller = ref.read(taskControllerProvider.notifier);

    if (_currentTask != null) {
      final updatedTask = _currentTask!.copyWith(
        title: title,
        description: description.isEmpty ? null : description,
        dueDate: _dueDate,
        priority: _priority,
        tags: tags,
      );
      await controller.updateTask(updatedTask);
    } else {
      await controller.createTask(
        title: title,
        description: description.isEmpty ? null : description,
        dueDate: _dueDate,
        priority: _priority,
        tags: tags,
      );
    }

    if (mounted) {
      context.pop();
    }
  }
}
