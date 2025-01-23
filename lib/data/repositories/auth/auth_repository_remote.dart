import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/data/services/firebase/user/user_firebase_client.dart';
import 'package:tasks_app_arq/utils/result.dart';

class AuthRepositoryRemote extends AuthRepository {
  final UserFirebaseClient _userFirebaseClient;
  final SharedPreferencesService _sharedPreferencesService;

  AuthRepositoryRemote({
    required UserFirebaseClient userFirebaseClient,
    required SharedPreferencesService sharedPreferencesService,
  })  : _userFirebaseClient = userFirebaseClient,
        _sharedPreferencesService = sharedPreferencesService;

  @override
  // TODO: implement isAuthenticated
  Future<bool> get isAuthenticated => throw UnimplementedError();

  @override
  Future<Result<void>> login(
      {required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
