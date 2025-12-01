import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:planner_plus/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:planner_plus/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:planner_plus/features/tasks/data/models/task_model.dart';
import 'package:planner_plus/features/tasks/domain/entities/task.dart';
import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required TaskLocalDataSource localDataSource,
    required TaskRemoteDataSource remoteDataSource,
    required Connectivity connectivity,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _connectivity = connectivity;

  final TaskLocalDataSource _localDataSource;
  final TaskRemoteDataSource _remoteDataSource;
  final Connectivity _connectivity;

  @override
  Future<List<Task>> getTasks() async {
    final models = await _localDataSource.getTasks();
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    final model = await _localDataSource.getTaskById(id);
    return model?.toDomain();
  }

  @override
  Future<Task> createTask(Task task) async {
    final model = TaskModel.fromDomain(task);
    await _localDataSource.saveTask(model);

    if (await _isOnline()) {
      try {
        final syncedModel = await _remoteDataSource.uploadTask(model);
        final updatedModel = syncedModel..isSynced = true;
        await _localDataSource.saveTask(updatedModel);
        return updatedModel.toDomain();
      } catch (e) {
      }
    }

    return model.toDomain();
  }

  @override
  Future<Task> updateTask(Task task) async {
    final model = TaskModel.fromDomain(task);
    await _localDataSource.saveTask(model);

    if (await _isOnline()) {
      try {
        final syncedModel = await _remoteDataSource.updateTask(model);
        final updatedModel = syncedModel..isSynced = true;
        await _localDataSource.saveTask(updatedModel);
        return updatedModel.toDomain();
      } catch (e) {
      }
    }

    return model.toDomain();
  }

  @override
  Future<void> deleteTask(String id) async {
    await _localDataSource.deleteTask(id);

    if (await _isOnline()) {
      try {
        await _remoteDataSource.deleteTask(id);
      } catch (e) {
      }
    }
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    final tasks = await getTasks();
    final lowercaseQuery = query.toLowerCase();

    return tasks.where((task) {
      final titleMatch = task.title.toLowerCase().contains(lowercaseQuery);
      final descriptionMatch =
          task.description?.toLowerCase().contains(lowercaseQuery) ?? false;
      final tagsMatch =
          task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));

      return titleMatch || descriptionMatch || tagsMatch;
    }).toList();
  }

  @override
  Future<List<Task>> filterTasks({
    bool? isCompleted,
    TaskPriority? priority,
    List<String>? tags,
  }) async {
    final tasks = await getTasks();

    return tasks.where((task) {
      if (isCompleted != null && task.isCompleted != isCompleted) {
        return false;
      }

      if (priority != null && task.priority != priority) {
        return false;
      }

      if (tags != null && tags.isNotEmpty) {
        final hasMatchingTag = task.tags.any((tag) => tags.contains(tag));
        if (!hasMatchingTag) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Future<void> syncTasks() async {
    if (!await _isOnline()) {
      throw Exception('Cannot sync while offline');
    }

    try {
      final localModels = await _localDataSource.getTasks();

      final syncedModels = await _remoteDataSource.syncTasks(localModels);

      final mergedModels = _mergeConflicts(localModels, syncedModels);

      await _localDataSource.clearAllTasks();
      for (final model in mergedModels) {
        model.isSynced = true;
        await _localDataSource.saveTask(model);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Task>> getUnsyncedTasks() async {
    final models = await _localDataSource.getUnsyncedTasks();
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Stream<List<Task>> watchTasks() {
    return _localDataSource
        .watchTasks()
        .map((models) => models.map((model) => model.toDomain()).toList());
  }

  @override
  Stream<Task?> watchTaskById(String id) async* {
    await for (final tasks in watchTasks()) {
      yield tasks.cast<Task?>().firstWhere(
            (task) => task?.id == id,
            orElse: () => null,
          );
    }
  }

  Future<bool> _isOnline() async {
    final ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet;
  }

  List<TaskModel> _mergeConflicts(
    List<TaskModel> localTasks,
    List<TaskModel> remoteTasks,
  ) {
    final merged = <String, TaskModel>{};

    for (final remoteTask in remoteTasks) {
      merged[remoteTask.id] = remoteTask;
    }

    for (final localTask in localTasks) {
      final remoteTask = merged[localTask.id];

      if (remoteTask == null) {
        merged[localTask.id] = localTask;
      } else {
        if (localTask.updatedAt.isAfter(remoteTask.updatedAt)) {
          merged[localTask.id] = localTask;
        }
      }
    }

    return merged.values.toList();
  }
}