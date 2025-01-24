import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/data/repositories/user/user_repository.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/utils/command.dart';
import 'package:tasks_app_arq/utils/result.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginViewModel({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository {
    login = Command1<void, (String email, String password)>(_login);
    createUser = Command1<User, User>(_createUser);
  }

  final _log = Logger('LoginViewModel');

  late Command1 login;
  late Command1 createUser;

  Future<Result<void>> _login((String, String) credentials) async {
    final (email, password) = credentials;
    final result =
        await _authRepository.login(email: email, password: password);

    if (result is Error<void>) {
      _log.warning('Login failed', result.error);
    }

    return result;
  }

  Future<Result<User>> _createUser(User user) async {
    final result = await _userRepository.addUser(user);

    if (result is Error<User>) {
      _log.warning('Create user failed', result.error);
    }

    return result;
  }
}
