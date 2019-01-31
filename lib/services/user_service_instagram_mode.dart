import 'dart:convert';

import 'package:repositories_management/models/user.dart';
import 'package:repositories_management/repositories/user_local_repository.dart';
import 'package:repositories_management/repositories/user_api_repository.dart';

class UserServiceInstagramMode {
  final localRepository = UserLocalRepository();
  final apiRepository = UserApiRepository();

  Future<List<User>> getFromCache() async {
    final userList = await localRepository.get();
    if (userList != null)
      return parseJson(userList);

    return [];
  }

  Future<List<User>> getFromApi() async {
    final userList = await apiRepository.get();
    await localRepository.save(userList);

    return parseJson(userList);
  }

  List<User> parseJson(String jsonString) {
    final List<dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap.map((it) => User.fromJson(it)).toList();
  }
}
