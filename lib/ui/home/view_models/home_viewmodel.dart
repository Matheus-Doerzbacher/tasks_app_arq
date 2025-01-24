import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/data/repositories/task/task_repository.dart';
import 'package:tasks_app_arq/domain/models/task/task.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/utils/command.dart';
import 'package:tasks_app_arq/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final TaskRepository _taskRepository;

  HomeViewModel({
    required AuthRepository authRepository,
    required TaskRepository taskRepository,
  })  : _authRepository = authRepository,
        _taskRepository = taskRepository {
    _user = _authRepository.userLogged;
    load = Command0(_load)..execute();
    addTask = Command1(_addTask);
    deleteTask = Command1(_deleteTask);
    finishTask = Command1(_finishTask);
  }

  late Command0 load;
  late Command1<void, Task> addTask;
  late Command1<void, String> deleteTask;
  late Command1<void, Task> finishTask;
  User? _user;
  User? get user => _user;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final _log = Logger('HomeViewModel');

  Future<Result<List<Task>>> _load() async {
    try {
      final result = await _taskRepository.getTasks(_user?.id ?? '');
      switch (result) {
        case Ok<List<Task>>():
          _tasks = result.value;
          _tasks.sort((a, b) => a.createdDate.compareTo(b.createdDate));
          _log.info('Tasks loaded');
        case Error<List<Task>>():
          _log.severe('Error loading tasks', result.error);
      }
      return result;
    } catch (e) {
      return Result.error(Exception(e));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _addTask(Task task) async {
    try {
      _tasks.add(task);
      _tasks.sort((a, b) => a.createdDate.compareTo(b.createdDate));
      notifyListeners();

      final result = await _taskRepository.addTask(task);
      switch (result) {
        case Ok<Task>():
          _log.info('Task added');
          await _load();
        case Error<Task>():
          _log.warning('Error adding task', result.error);
          _tasks.remove(task);
          notifyListeners();
      }
      return result;
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<void>> _deleteTask(String taskId) async {
    try {
      final result = await _taskRepository.deleteTask(taskId);
      switch (result) {
        case Ok<void>():
          _log.info('Task deleted');
          await _load();
        case Error<void>():
          _log.warning('Error deleting task', result.error);
      }
      return result;
    } catch (e) {
      return Result.error(Exception(e));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _finishTask(Task task) async {
    try {
      final tasksCopy = _tasks;
      final index = _tasks.indexOf(task);
      final taskFinished = task.copyWith(isFinish: !task.isFinish);
      _tasks[index] = taskFinished;
      notifyListeners();

      final result = await _taskRepository.updateTask(taskFinished);
      switch (result) {
        case Ok<Task>():
          _log.info('Task finished');
        case Error<Task>():
          _log.warning('Error finishing task', result.error);
          _tasks = tasksCopy;
          notifyListeners();
      }
      return result;
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
