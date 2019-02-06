import 'dart:async';

import 'package:repositories_management/utils/database.dart';

class UserSqlRepository {
  final _table = 'user';

  Future<bool> save(int id, String json) async {
    final db = await DbHelper.db;
    final userData = CacheData(id, json: json);
    await db.insert(_table, userData.toMap());

    print('Usuário salvo com sucesso!');
    print('Expira em: ${userData.expiresAt}');

    return true;
  }

  Future<CacheData> get() async {
    final db = await DbHelper.db;
    final result = await db.rawQuery('SELECT * FROM $_table');
    if (result.length > 0) {
      final first = result.first;

      print('Usuário já em cache:');
      print('Expira em: ${result.first['expires_at']}');

      return CacheData(
        first['id'] as int,
        expiresAt: DateTime.parse(first['expires_at'] as String),
        json: first['json'] as String,
      );
    }

    return null;
  }

  Future<bool> update(int id, String json) async {
    final db = await DbHelper.db;
    final userData = CacheData(id, json: json);

    await db.update(
      _table,
      userData.toMap(),
      where: '$id = ?',
      whereArgs: [id],
    );

    print('Usuário atualizado com sucesso!');
    print('Expira em: ${userData.expiresAt}');

    return true;
  }
}

class CacheData {
  final int id;
  final DateTime expiresAt;
  final String result;

  CacheData(
    int id, {
    DateTime expiresAt,
    String json,
  })  : id = id ?? 1,
        expiresAt = expiresAt ?? DateTime.now().add(Duration(minutes: 5)),
        result = json;

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'expires_at': this.expiresAt.toString(),
      'json': this.result,
    };
  }

  bool get isValid => DateTime.now().isBefore(this.expiresAt);
}
