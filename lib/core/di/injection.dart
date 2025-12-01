import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:planner_plus/core/network/api_client.dart';
import 'package:planner_plus/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:planner_plus/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:planner_plus/features/tasks/data/models/task_model.dart';
import 'package:planner_plus/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:planner_plus/features/tasks/domain/repositories/task_repository.dart';
import 'package:planner_plus/features/tasks/domain/usecases/create_task.dart';
import 'package:planner_plus/features/tasks/domain/usecases/delete_task.dart';
import 'package:planner_plus/features/tasks/domain/usecases/get_tasks.dart';
import 'package:planner_plus/features/tasks/domain/usecases/search_tasks.dart';
import 'package:planner_plus/features/tasks/domain/usecases/sync_tasks.dart';
import 'package:planner_plus/features/tasks/domain/usecases/update_task.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  );
});

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  final box = Hive.box<TaskModel>(TaskLocalDataSourceImpl.boxName);
  return TaskLocalDataSourceImpl(box);
});

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TaskRemoteDataSourceImpl(apiClient);
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    localDataSource: ref.watch(taskLocalDataSourceProvider),
    remoteDataSource: ref.watch(taskRemoteDataSourceProvider),
    connectivity: ref.watch(connectivityProvider),
  );
});

final getTasksUseCaseProvider = Provider<GetTasks>((ref) {
  return GetTasks(ref.watch(taskRepositoryProvider));
});

final createTaskUseCaseProvider = Provider<CreateTask>((ref) {
  return CreateTask(ref.watch(taskRepositoryProvider));
});

final updateTaskUseCaseProvider = Provider<UpdateTask>((ref) {
  return UpdateTask(ref.watch(taskRepositoryProvider));
});

final deleteTaskUseCaseProvider = Provider<DeleteTask>((ref) {
  return DeleteTask(ref.watch(taskRepositoryProvider));
});

final searchTasksUseCaseProvider = Provider<SearchTasks>((ref) {
  return SearchTasks(ref.watch(taskRepositoryProvider));
});

final syncTasksUseCaseProvider = Provider<SyncTasks>((ref) {
  return SyncTasks(ref.watch(taskRepositoryProvider));
});
