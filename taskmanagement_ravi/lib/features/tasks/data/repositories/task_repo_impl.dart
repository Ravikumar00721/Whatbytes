import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repo.dart';
import '../datasources/task_remote_data_s.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
      remoteDataSource: ref.watch(taskRemoteDataSourceProvider));
});

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Task>> getTasks(String userId) {
    return remoteDataSource.getTasks(userId);
  }

  @override
  Future<void> addTask(Task task, String userId) {
    return remoteDataSource.addTask(task, userId);
  }

  @override
  Future<void> updateTask(Task task) {
    return remoteDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) {
    return remoteDataSource.deleteTask(taskId);
  }
}
