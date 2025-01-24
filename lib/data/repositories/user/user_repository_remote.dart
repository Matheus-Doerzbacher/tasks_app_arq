import 'package:logging/logging.dart';
import 'package:tasks_app_arq/data/repositories/user/user_repository.dart';
import 'package:tasks_app_arq/data/services/firebase/user/user_firebase_client.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/utils/result.dart';

class UserRepositoryRemote implements UserRepository {
  final UserFirebaseClient _userFirebaseClient;

  UserRepositoryRemote({
    required UserFirebaseClient userFirebaseClient,
  }) : _userFirebaseClient = userFirebaseClient;

  final _log = Logger('UserRepositoryRemote');

  @override
  Future<Result<User>> addUser(User user) async {
    try {
      final result = await _userFirebaseClient.addUser(user);
      switch (result) {
        case Ok<User>():
          _log.info('User added successfully');
          return Result.ok(result.value);
        case Error<User>():
          _log.severe('Failed to add user', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.warning('Failed to add user', e);
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<User>> updateUser(User user) async {
    try {
      final result = await _userFirebaseClient.updateUser(user);
      switch (result) {
        case Ok<User>():
          _log.info('User updated successfully');
          return Result.ok(result.value);
        case Error<User>():
          _log.severe('Failed to update user', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.warning('Failed to update user', e);
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> deleteUser(String userId) async {
    try {
      final result = await _userFirebaseClient.deleteUser(userId);
      switch (result) {
        case Ok<void>():
          _log.info('User deleted successfully');
          return Result.ok(null);
        case Error<void>():
          _log.severe('Failed to delete user', result.error);
          return Result.error(result.error);
      }
    } catch (e) {
      _log.warning('Failed to delete user', e);
      return Result.error(Exception(e));
    }
  }
}
