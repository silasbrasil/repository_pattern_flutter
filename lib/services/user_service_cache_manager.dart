import 'dart:async';
import 'dart:convert';

import 'package:repositories_management/models/user.dart';
import 'package:repositories_management/repositories/user_sql_repository.dart';
import 'package:repositories_management/repositories/user_api_repository.dart';

class UserServiceCacheManager {
  final _userSqlRepo = UserSqlRepository();
  final _userApiRepo = UserApiRepository();

  Future<User> get() async {
    final cacheData = await _userSqlRepo.get();

    if (cacheData != null && cacheData.isValid)
      return User.fromJson(jsonDecode(cacheData.result)[0]);

    return update();
  }

  Future<User> update() async {
    final result = await _userApiRepo.get();
    final user = User.fromJson(jsonDecode(result)[0]);
    await _userSqlRepo.update(user.id, result);

    return user;
  }
}