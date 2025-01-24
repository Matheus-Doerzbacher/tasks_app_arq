import 'package:tasks_app_arq/domain/models/task/task.dart';
import 'package:tasks_app_arq/utils/result.dart';

abstract class TaskRepository {
  Future<Result<Task>> addTask(Task task);
  Future<Result<List<Task>>> getTasks(String userId);
  Future<Result<Task>> updateTask(Task task);
  Future<Result<void>> deleteTask(String taskId);
}
