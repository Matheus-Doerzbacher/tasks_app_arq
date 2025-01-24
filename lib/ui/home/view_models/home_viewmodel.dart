import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/utils/command.dart';

class HomeViewModel {
  final AuthRepository _authRepository;

  HomeViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    _user = _authRepository.userLogged;
  }

  late Command0 fetchUser;

  User? _user;
  User? get user => _user;
}
