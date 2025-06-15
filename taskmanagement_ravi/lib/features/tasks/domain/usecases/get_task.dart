import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/task_repo_impl.dart';
import '../entities/task.dart';
import '../repositories/task_repo.dart';

final getTasksProvider = Provider<GetTasks>((ref) {
  return GetTasks(repository: ref.watch(taskRepositoryProvider));
});

class GetTasks {
  final TaskRepository repository;

  GetTasks({required this.repository});

  Stream<List<Task>> call(String userId) {
    return repository.getTasks(userId);
  }
}
