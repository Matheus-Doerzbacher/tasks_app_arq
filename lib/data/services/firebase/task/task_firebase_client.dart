import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_app_arq/domain/models/task/task.dart';
import 'package:tasks_app_arq/utils/result.dart';

final taskCollection = 'tasks';

class TaskFirebaseClient {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<Task>> addTask(Task task) async {
    try {
      final taskId = _firestore.collection(taskCollection).doc().id;
      final taskWithId = task.copyWith(id: taskId);
      await _firestore
          .collection(taskCollection)
          .doc(taskId)
          .set(taskWithId.toJson());
      return Result.ok(taskWithId);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<List<Task>>> getTasks() async {
    try {
      final tasks = await _firestore.collection(taskCollection).get();
      return Result.ok(
        tasks.docs.map((doc) => Task.fromJson(doc.data())).toList(),
      );
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<Task>> updateTask(Task task) async {
    try {
      await _firestore
          .collection(taskCollection)
          .doc(task.id)
          .update(task.toJson());
      return Result.ok(task);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<void>> deleteTask(String taskId) async {
    try {
      await _firestore.collection(taskCollection).doc(taskId).delete();
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
