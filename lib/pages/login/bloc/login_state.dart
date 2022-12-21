part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginRequired extends LoginState {}

class LoginAccepted extends LoginState {
  final String token;

  const LoginAccepted(this.token);

  @override
  List<Object> get props => [token];
}

class LoginMessage extends LoginState {
  final String message;

  const LoginMessage(this.message);

  @override
  List<Object> get props => [message];
}
