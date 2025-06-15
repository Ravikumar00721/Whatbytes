import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/task_repo_impl.dart';
import '../entities/task.dart';
import '../repositories/task_repo.dart';

final addTaskProvider = Provider<AddTask>((ref) {
  return AddTask(repository: ref.watch(taskRepositoryProvider));
});

class AddTask {
  final TaskRepository repository;

  AddTask({required this.repository});

  Future<void> call(Task task, String userId) {
    return repository.addTask(task, userId);
  }
}
