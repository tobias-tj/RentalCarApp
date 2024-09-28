part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticacionUserChanged extends AuthenticationEvent {
  final MyUser? user;

  const AuthenticacionUserChanged(this.user);
}
