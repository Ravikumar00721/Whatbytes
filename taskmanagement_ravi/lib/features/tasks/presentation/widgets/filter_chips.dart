import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/task_provider.dart';

class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(taskFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildPriorityFilter(context, ref, filter, 'high'),
          _buildPriorityFilter(context, ref, filter, 'medium'),
          _buildPriorityFilter(context, ref, filter, 'low'),
          _buildStatusFilter(context, ref, filter, true, 'Completed'),
          _buildStatusFilter(context, ref, filter, false, 'Pending'),
        ],
      ),
    );
  }

  Widget _buildPriorityFilter(
      BuildContext context, WidgetRef ref, TaskFilter filter, String priority) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(priority.toUpperCase()),
        selected: filter.priority == priority,
        onSelected: (selected) {
          ref.read(taskFilterProvider.notifier).update(
              (state) => state.copyWith(priority: selected ? priority : null));
        },
        backgroundColor: Colors.grey[200],
        selectedColor: _getPriorityColor(priority).withOpacity(0.2),
        labelStyle: TextStyle(
          color: filter.priority == priority
              ? _getPriorityColor(priority)
              : Colors.black,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _getPriorityColor(priority)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildStatusFilter(BuildContext context, WidgetRef ref,
      TaskFilter filter, bool status, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: filter.isCompleted == status,
        onSelected: (selected) {
          ref.read(taskFilterProvider.notifier).update(
              (state) => state.copyWith(isCompleted: selected ? status : null));
        },
        backgroundColor: Colors.grey[200],
        selectedColor: status
            ? Colors.green.withOpacity(0.2)
            : Colors.orange.withOpacity(0.2),
        labelStyle: TextStyle(
          color: filter.isCompleted == status
              ? status
                  ? Colors.green
                  : Colors.orange
              : Colors.black,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: status ? Colors.green : Colors.orange),
          borderRadius: BorderRadius.circular(20),
        ),
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
}
