import 'package:dio/dio.dart';
import 'package:planner_plus/core/network/api_client.dart';
import 'package:planner_plus/features/tasks/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> fetchTasks();

  Future<TaskModel> uploadTask(TaskModel task);

  Future<TaskModel> updateTask(TaskModel task);

  Future<void> deleteTask(String id);

  Future<List<TaskModel>> syncTasks(List<TaskModel> localTasks);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  static const String _tasksEndpoint = '/tasks';

  @override
  Future<List<TaskModel>> fetchTasks() async {
    try {
      final response = await _apiClient.get(_tasksEndpoint);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TaskModel> uploadTask(TaskModel task) async {
    try {
      final response = await _apiClient.post(
        _tasksEndpoint,
        data: task.toJson(),
      );
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await _apiClient.put(
        '$_tasksEndpoint/${task.id}',
        data: task.toJson(),
      );
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _apiClient.delete('$_tasksEndpoint/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<TaskModel>> syncTasks(List<TaskModel> localTasks) async {
    try {
      final response = await _apiClient.post(
        '$_tasksEndpoint/sync',
        data: {
          'tasks': localTasks.map((task) => task.toJson()).toList(),
        },
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        return Exception(
          'Server error: ${error.response?.statusCode ?? "Unknown"}',
        );
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      case DioExceptionType.badCertificate:
        return Exception('SSL certificate error');
      case DioExceptionType.unknown:
      default:
        return Exception('An unexpected error occurred');
    }
  }
}
