import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/task.dart';
import '../models/task_model.dart';

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSourceImpl(firestore: FirebaseFirestore.instance);
});

abstract class TaskRemoteDataSource {
  Stream<List<Task>> getTasks(String userId);
  Future<void> addTask(Task task, String userId);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<Task>> getTasks(String userId) {
    return firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> addTask(Task task, String userId) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      priority: task.priority,
      isCompleted: task.isCompleted,
    );

    await firestore.collection('tasks').add({
      ...taskModel.toMap(),
      'userId': userId,
    });
  }

  @override
  Future<void> updateTask(Task task) async {
    await firestore.collection('tasks').doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'dueDate': Timestamp.fromDate(task.dueDate),
      'priority': task.priority,
      'isCompleted': task.isCompleted,
    });
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await firestore.collection('tasks').doc(taskId).delete();
  }
}
