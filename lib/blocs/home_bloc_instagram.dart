import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:repositories_management/models/user.dart';
import 'package:repositories_management/exceptions/api_exception.dart';
import 'package:repositories_management/services/user_service_instagram_mode.dart';

class HomeBlocInstagram {
  final _userService = UserServiceInstagramMode();
  final _usersState = BehaviorSubject<UserState>(seedValue: UserStateLoading())
    ..delay(Duration(milliseconds: 300));

  Function snackBarCallback;
  Function popUpCallback;
  BuildContext context;

  HomeBlocInstagram() {
    _loadUsers();
  }

  Stream<UserState> get users => _usersState.stream;

  void _loadUsers() async {
    final cachedUserList = await _userService.getFromCache();
      if (cachedUserList.isNotEmpty)
        _emitUserState(UserStateCached(cachedUserList));

    try {
      final updatedUserList = await _userService.getFromApi();
      if (updatedUserList.isEmpty)
        _emitUserState(UserStateEmpty());
      else
        _emitUserState(UserStateUpdate(updatedUserList));
    } catch(error) {
      _handlerError(error);
    }
  }

  Future<void> updateUsers() async {
    try {
      final userList = await _userService.getFromApi();
      if (userList.isEmpty)
        _emitUserState(UserStateEmpty());

      _emitUserState(UserStateUpdate(userList));
    } catch(error) {
      _handlerError(error);
    }
  }

  void _emitUserState(UserState state) {
    _usersState.sink.add(state);
  }

  void _emitErrorState(Object error) {
    if (error is SocketException) {
      _emitUserState(UserStateError(0, 'Sem conexão!'));
    } else if (error is ApiException) {
      _emitUserState(UserStateError(error.code, error.message));
    }
  }

  void _handlerError(Object error) {
    final lastState = _usersState.stream.value;
    if (lastState is UserStateLoading ||
        lastState is UserStateEmpty ||
        lastState is UserStateError) {
      _emitErrorState(error);
    } else {
      if (error is SocketException) {
        popUpCallback('Sem conexão!', context);
      } else if (error is ApiException) {
        popUpCallback(error.message, context);
      }
    }
  }

  void dispose() {
    _usersState.close();
  }
}

class UserState {}

class UserStateLoading extends UserState {}

class UserStateEmpty extends UserState {}

class UserStateCached extends UserState {
  final List<User> data;
  UserStateCached(this.data);
}

class UserStateUpdate extends UserState {
  final List<User> data;
  UserStateUpdate(this.data);
}

class UserStateError extends UserState {
  final int code;
  final String message;
  UserStateError(this.code, this.message);
}
