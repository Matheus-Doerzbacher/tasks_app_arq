import 'package:flutter/foundation.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  User? get userLogged;

  // Perform login
  Future<Result<void>> login({
    required String email,
    required String password,
  });

  /// Perform logout
  Future<Result<void>> logout();
}
