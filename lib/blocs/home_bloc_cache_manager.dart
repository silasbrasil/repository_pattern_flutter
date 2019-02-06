import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:repositories_management/blocs/home_state.dart';
import 'package:repositories_management/exceptions/api_exception.dart';
import 'package:repositories_management/services/user_service_cache_manager.dart';

class HomeBlocCacheManager {
  final _networkErrorText = 'Sem conexão com a internet!';

  final _userService = UserServiceCacheManager();
  final _userState = BehaviorSubject<UserState>(seedValue: UserStateLoading())
    ..delay(Duration(milliseconds: 300));

  BuildContext context;

  HomeBlocCacheManager() {
    _loadUser();
  }

  Stream<UserState> get user => _userState.stream;

  void _loadUser() async {
    try {
      final user = await _userService.get();
      if (user == null && _userState.stream.value == UserStateLoading()) {
        final userUpdated = await _userService.update();
        _userState.sink.add(UserStatePopulated(userUpdated));
      }
      _userState.sink.add(UserStatePopulated(user));
    } on SocketException catch(_) {
      _userState.sink.add(UserStateError(0, _networkErrorText));
    } on ApiException catch(ex) {
      _userState.sink.add(UserStateError(ex.code, ex.message));
    }
  }

  Future<void> update() async {
    try {
      final user = await _userService.update();
      _userState.sink.add(UserStatePopulated(user));
    } on SocketException catch(_) {
      _userState.sink.add(UserStateError(0, _networkErrorText));
    } on ApiException catch(ex) {
      _userState.sink.add(UserStateError(ex.code, ex.message));
    }
  }

  void dispose() {
    _userState.close();
  }
}
