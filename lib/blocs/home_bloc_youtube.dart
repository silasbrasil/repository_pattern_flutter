import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:repositories_management/exceptions/api_exception.dart';
import 'package:repositories_management/models/user.dart';
import 'package:repositories_management/services/user_service_youtube_mode.dart';

/// Essa HomeBloc funciona semelhante o [youtube] mas com cache local
/// para caso de ausência de internet quando app abre.
class HomeBlocYoutube {
  final userService = UserServiceYoutubeMode();

  final _networkErrorText = 'Sem conexão com a internet!';
  final _usersState = PublishSubject<UserState>()
    ..startWith(UserLoadingState());

  HomeBlocYoutube() {
    userService.getAll().then((userList) {
      if (userList.isEmpty) {
        _usersState.sink.add(UserEmptyState());
      } else {
        _usersState.sink.add(UserListState(userList));
      }
    }).catchError((error) {
      if (error is SocketException) {
        _usersState.sink.add(UserErrorState(_networkErrorText));
      } else if (error is ApiException) {
        _usersState.sink.add(UserErrorState(error.message));
      }
    });
  }

  Stream<UserState> get users => _usersState.stream;

  Future<void> updateUsers() async {
    try {
      final userList = await userService.update();
      if (userList.isEmpty)
        _usersState.sink.add(UserEmptyState());
      else
        _usersState.sink.add(UserListState(userList));
    } on SocketException catch (_) {
      _usersState.sink.add(UserErrorState(_networkErrorText));
    } on ApiException catch (ex) {
      _usersState.sink.add(UserErrorState(ex.message));
    }
  }

  void dispose() {
    _usersState.close();
  }
}

class UserState {}

class UserListState extends UserState {
  final List<User> list;

  UserListState(this.list);
}

class UserLoadingState extends UserState {}

class UserEmptyState extends UserState {}

class UserErrorState extends UserState {
  final String message;
  UserErrorState(this.message);
}
