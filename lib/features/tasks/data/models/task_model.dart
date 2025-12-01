import 'package:hive/hive.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
enum TaskPriorityModel {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high;

  TaskPriority toDomain() {
    switch (this) {
      case TaskPriorityModel.low:
        return TaskPriority.low;
      case TaskPriorityModel.medium:
        return TaskPriority.medium;
      case TaskPriorityModel.high:
        return TaskPriority.high;
    }
  }

  static TaskPriorityModel fromDomain(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return TaskPriorityModel.low;
      case TaskPriority.medium:
        return TaskPriorityModel.medium;
      case TaskPriority.high:
        return TaskPriorityModel.high;
    }
  }
}

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  TaskModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.dueDate,
    this.priority = TaskPriorityModel.medium,
    this.tags = const [],
    this.isCompleted = false,
    this.isSynced = false,
  });

  factory TaskModel.fromDomain(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      priority: TaskPriorityModel.fromDomain(task.priority),
      tags: task.tags,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      isSynced: task.isSynced,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: TaskPriorityModel.values
          .byName(json['priority'] as String? ?? 'medium'),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  TaskPriorityModel priority;

  @HiveField(5)
  List<String> tags;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  @HiveField(9)
  bool isSynced;

  Task toDomain() {
    return Task(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority.toDomain(),
      tags: tags,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'tags': tags,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }
}
