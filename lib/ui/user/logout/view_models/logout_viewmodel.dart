import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/utils/command.dart';
import 'package:tasks_app_arq/utils/result.dart';

class LogoutViewModel {
  final AuthRepository _authRepository;

  LogoutViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    logout = Command0(_logout);
  }

  late Command0 logout;

  String? errorMsg;

  Future<Result> _logout() async {
    errorMsg = null;
    final result = await _authRepository.logout();
    if (result is Error) {
      errorMsg = result.error.toString();
    }
    return result;
  }
}
