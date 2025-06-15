// In your task provider file
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/provider/auth_provider.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_task.dart';

class TaskFilter {
  final String? priority;
  final bool? isCompleted;

  TaskFilter({this.priority, this.isCompleted});

  TaskFilter copyWith({
    String? priority,
    bool? isCompleted,
  }) {
    return TaskFilter(
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredTasksProvider = Provider.autoDispose<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? [];
  final filter = ref.watch(taskFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return tasks.where((task) {
    final priorityMatch =
        filter.priority == null || task.priority == filter.priority;
    final statusMatch =
        filter.isCompleted == null || task.isCompleted == filter.isCompleted;
    final searchMatch = searchQuery.isEmpty ||
        task.title.toLowerCase().contains(searchQuery) ||
        task.description.toLowerCase().contains(searchQuery);

    return priorityMatch && statusMatch && searchMatch;
  }).toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
});

final tasksProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();

  final getTasks = ref.watch(getTasksProvider);
  return getTasks(user.uid);
});

final taskFilterProvider = StateProvider<TaskFilter>((ref) {
  return TaskFilter();
});

final showAllTasksProvider = StateProvider<bool>((ref) => false);
