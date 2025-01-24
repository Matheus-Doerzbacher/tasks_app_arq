import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/utils/result.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:tasks_app_arq/jwt_secret.dart';

final userCollection = 'users';

class AuthFirebaseClient {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<String>> loginUser(String email, String password) async {
    try {
      final result = await _getUserByEmail(email);
      switch (result) {
        case Ok<User>():
          final passwordHash = await _hashPassword(password);
          if (result.value.password != passwordHash) {
            return Result.error(Exception('Invalid password'));
          }
          final jwt = JWT(result.value);
          return Result.ok(jwt.sign(SecretKey(jwtTokenKey)));
        case Error<User>():
          return Result.error(result.error);
      }
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<User>> _getUserByEmail(String email) async {
    try {
      final user = await _firestore
          .collection(userCollection)
          .where('email', isEqualTo: email)
          .get();

      if (user.docs.isEmpty) {
        return Result.error(Exception('User not found'));
      }

      final userData = user.docs.first.data();
      return Result.ok(User.fromJson(userData));
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<String> _hashPassword(String password) async {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
