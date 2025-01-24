import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:tasks_app_arq/domain/models/user/user.dart';
import 'package:tasks_app_arq/utils/result.dart';

final userCollection = 'users';

class UserFirebaseClient {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<User>> addUser(User user) async {
    try {
      final userId = _firestore.collection(userCollection).doc().id;
      final passwordHash = await _hashPassword(user.password);
      final userWithId = user.copyWith(id: userId, password: passwordHash);
      await _firestore
          .collection(userCollection)
          .doc(userId)
          .set(userWithId.toJson());
      return Result.ok(userWithId);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<User>> updateUser(User user) async {
    try {
      await _firestore
          .collection(userCollection)
          .doc(user.id)
          .update(user.toJson());
      return Result.ok(user);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<Result<void>> deleteUser(String userId) async {
    try {
      await _firestore.collection(userCollection).doc(userId).delete();
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  Future<String> _hashPassword(String password) async {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
