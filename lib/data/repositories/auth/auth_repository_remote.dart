import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:logging/logging.dart';
import 'package:tasks_app_arq/data/repositories/auth/auth_repository.dart';
import 'package:tasks_app_arq/data/services/firebase/user/user_firebase_client.dart';
import 'package:tasks_app_arq/data/services/shared_preferences_service.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/jwt_secret.dart';
import 'package:tasks_app_arq/utils/result.dart';

class AuthRepositoryRemote extends AuthRepository {
  final UserFirebaseClient _userFirebaseClient;
  final SharedPreferencesService _sharedPreferencesService;

  AuthRepositoryRemote({
    required UserFirebaseClient userFirebaseClient,
    required SharedPreferencesService sharedPreferencesService,
  })  : _userFirebaseClient = userFirebaseClient,
        _sharedPreferencesService = sharedPreferencesService;

  bool? _isAuthenticated;
  final _log = Logger('AuthRepositoryRemote');

  User? _userLogged;

  @override
  User? get userLogged => _userLogged;

  /// Fetch token from shared preferences
  Future<void> _fetch() async {
    final result = await _sharedPreferencesService.fetchToken();

    switch (result) {
      case Ok<String?>():
        if (result.value != null && _userLogged == null) {
          final jwt = JWT.verify(result.value!, SecretKey(jwtTokenKey));
          _userLogged = User(
            id: jwt.payload['id'] as String,
            email: jwt.payload['email'] as String,
            name: jwt.payload['name'] as String,
            password: jwt.payload['password'] as String,
          );
        }
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _log.warning(
          'Failed to fech Token from SharedPreferences',
          result.error,
        );
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    await _fetch();
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _userFirebaseClient.loginUser(email, password);

      switch (result) {
        case Ok<String>():
          _log.info('User logged int');
          _isAuthenticated = true;
          final jwt = JWT.verify(result.value, SecretKey(jwtTokenKey));
          _userLogged = User(
            id: jwt.payload['id'] as String,
            email: jwt.payload['email'] as String,
            name: jwt.payload['name'] as String,
            password: jwt.payload['password'] as String,
          );
          return await _sharedPreferencesService.saveToken(result.value);
        case Error<String>():
          _log.warning('Error logging in: ${result.error}');
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    _log.info('User logged out');
    try {
      // Passar um valor nulo faz com que o token seja eliminado
      final result = await _sharedPreferencesService.saveToken(null);
      if (result is Error<void>) {
        _log.warning('Failed to clear stored auth token');
      }
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }
}
