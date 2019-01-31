import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

import 'package:repositories_management/models/user.dart';
import 'package:repositories_management/exceptions/api_exception.dart';
import 'package:repositories_management/services/user_service_instagram_mode.dart';

class HomeBlocInstagram {
  BuildContext _currentContext;

  final _userService = UserServiceInstagramMode();
  final _usersState = BehaviorSubject<UserState>(seedValue: UserStateLoading())
    ..delay(Duration(milliseconds: 300));

  HomeBlocInstagram() {
    _userService.getFromCache().then((cachedUserList) {
      if (cachedUserList.isNotEmpty)
        _emitUserState(UserStateCached(cachedUserList));

      return _userService.getFromApi();
    }).then((updatedUserList) {
      if (updatedUserList.isEmpty)
        _emitUserState(UserStateEmpty());
      else
        _emitUserState(UserStateUpdate(updatedUserList));
    }).catchError(_handlerError);
  }

  Stream<UserState> get users => _usersState.stream;

  set currentContext (BuildContext context) => _currentContext = context;

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
      _emitUserState(UserStateError(0, 'Sem conexão com a internet!'));
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
      showSnackBar();
    }
  }

  void showSnackBar() {
    final snackBar = SnackBar(content: Text('Não foi possível atualizar os dados!'));
    Scaffold.of(_currentContext).showSnackBar(snackBar);
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
