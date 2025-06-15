import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/update_task.dart';
import '../provider/task_provider.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearAllFilters() {
    ref.read(taskFilterProvider.notifier).state = TaskFilter();
    ref.read(searchQueryProvider.notifier).state = '';
    _searchController.clear();
    ref.read(showAllTasksProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(filteredTasksProvider);
    final filter = ref.watch(taskFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go("/login"),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.filter_alt_off),
                      onPressed: _clearAllFilters,
                      tooltip: 'Clear all filters',
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Priority Filter
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: filter.priority,
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Priorities'),
                      ),
                      ...['high', 'medium', 'low'].map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(
                            priority.toUpperCase(),
                            style: TextStyle(
                              color: _getPriorityColor(priority),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      ref.read(taskFilterProvider.notifier).update(
                            (state) => state.copyWith(priority: value),
                          );
                    },
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: DropdownButtonFormField<bool?>(
                    value: filter.isCompleted,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Statuses'),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text(
                          'Pending',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      ref.read(taskFilterProvider.notifier).update(
                            (state) => state.copyWith(isCompleted: value),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (filter.priority != null ||
              filter.isCompleted != null ||
              _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _clearAllFilters,
                  icon: const Icon(Icons.filter_alt_off, size: 16),
                  label: const Text('Clear all filters'),
                ),
              ),
            ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No tasks found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        onToggleStatus: () => _toggleStatus(ref, task),
                        onEdit: () => _editTask(context, task),
                        onDelete: () => _deleteTask(ref, task),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTaskScreen()),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _toggleStatus(WidgetRef ref, Task task) {
    ref
        .read(updateTaskProvider)
        .call(task.copyWith(isCompleted: !task.isCompleted));
  }

  void _editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(task: task),
      ),
    );
  }

  void _deleteTask(WidgetRef ref, Task task) {
    ref.read(deleteTaskProvider).call(task.id);
  }
}
