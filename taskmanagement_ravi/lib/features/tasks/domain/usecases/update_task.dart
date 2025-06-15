import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/task_repo_impl.dart';
import '../entities/task.dart';
import '../repositories/task_repo.dart';

final updateTaskProvider = Provider<UpdateTask>((ref) {
  return UpdateTask(repository: ref.watch(taskRepositoryProvider));
});

class UpdateTask {
  final TaskRepository repository;

  UpdateTask({required this.repository});

  Future<void> call(Task task) {
    return repository.updateTask(task);
  }
}
