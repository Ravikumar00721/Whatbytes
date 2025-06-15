import '../entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> getTasks(String userId);
  Future<void> addTask(Task task, String userId);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
