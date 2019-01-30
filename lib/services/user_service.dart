import 'dart:convert';

import 'package:repositories_management/models/user.dart';
import 'package:repositories_management/repositories/user_api_repository.dart';
import 'package:repositories_management/repositories/user_local_repository.dart';

class UserService {
  final userLocalRepository = UserLocalRepository();
  final userApiRepository = UserApiRepository();

  Future<List<User>> getAll() async {
    final userLocalList = await userLocalRepository.get();
    if (userLocalList != null) return parseJson(userLocalList);

    final userApiList = await userApiRepository.get();
    await userLocalRepository.save(userApiList);
    return parseJson(userApiList);
  }

  Future<List<User>> update() async {
    final userApiList = await userApiRepository.get();
    await userLocalRepository.save(userApiList);
    return parseJson(userApiList);
  }

  List<User> parseJson(String jsonString) {
    final List<dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap.map((it) => User.fromJson(it)).toList();
  }
}
