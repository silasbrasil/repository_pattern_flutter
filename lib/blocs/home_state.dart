import 'package:repositories_management/models/user.dart';

class UserState {}

class UserStateLoading extends UserState {}

class UserStateEmpty extends UserState {}

class UserStatePopulated extends UserState {
  final User data;
  UserStatePopulated(this.data);
}

class UserStateError extends UserState {
  final int code;
  final String message;
  UserStateError(this.code, this.message);
}