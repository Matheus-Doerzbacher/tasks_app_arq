import 'package:tasks_app_arq/data/repositories/task/task_repository.dart';
import 'package:tasks_app_arq/data/services/firebase/task/task_firebase_client.dart';
import 'package:tasks_app_arq/domain/models/task/task.dart';
import 'package:tasks_app_arq/utils/result.dart';

class TaskRepositoryRemote extends TaskRepository {
  final TaskFirebaseClient _taskFirebaseClient;

  TaskRepositoryRemote({
    required TaskFirebaseClient taskFirebaseClient,
  }) : _taskFirebaseClient = taskFirebaseClient;

  @override
  Future<Result<Task>> addTask(Task task) async {
    try {
      return await _taskFirebaseClient.addTask(task);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> deleteTask(String taskId) async {
    try {
      return await _taskFirebaseClient.deleteTask(taskId);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<List<Task>>> getTasks(String userId) async {
    try {
      return await _taskFirebaseClient.getTasks(userId);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<Task>> updateTask(Task task) async {
    try {
      return await _taskFirebaseClient.updateTask(task);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
