import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/utils/result.dart';

abstract class UserRepository {
  Future<Result<User>> addUser(User user);
  Future<Result<User>> updateUser(User user);
  Future<Result<void>> deleteUser(String userId);
}
