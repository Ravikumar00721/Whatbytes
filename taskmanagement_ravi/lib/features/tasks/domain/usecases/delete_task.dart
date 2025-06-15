import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/task_repo_impl.dart';
import '../repositories/task_repo.dart';

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  return DeleteTask(repository: ref.watch(taskRepositoryProvider));
});

class DeleteTask {
  final TaskRepository repository;

  DeleteTask({required this.repository});

  Future<void> call(String taskId) {
    return repository.deleteTask(taskId);
  }
}
