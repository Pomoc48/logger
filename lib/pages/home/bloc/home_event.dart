part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class AutoLogin extends HomeEvent {}

class RequestLogin extends HomeEvent {
  final String username;
  final String password;

  const RequestLogin({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class RequestRegister extends HomeEvent {
  final String username;
  final String password;

  const RequestRegister({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}

class UpdateHome extends HomeEvent {
  final List<ListOfItems> lists;
  final String token;
  final String username;
  final String profileUrl;

  const UpdateHome({
    required this.lists,
    required this.token,
    required this.username,
    required this.profileUrl,
  });

  @override
  List<Object> get props => [lists, token, username];
}

class InsertHome extends HomeEvent {
  final String name;
  final HomeLoaded state;

  const InsertHome({required this.name, required this.state});

  @override
  List<Object> get props => [name, state];
}

class QuickInsertHome extends HomeEvent {
  final ListOfItems list;
  final int timestamp;
  final HomeLoaded state;

  const QuickInsertHome({
    required this.list,
    required this.state,
    required this.timestamp,
  });

  @override
  List<Object> get props => [list, state, timestamp];
}

class RemoveFromHome extends HomeEvent {
  final int id;
  final HomeLoaded state;

  const RemoveFromHome({required this.id, required this.state});

  @override
  List<Object> get props => [id, state];
}

class ReportHomeError extends HomeEvent {
  final String token;

  const ReportHomeError(this.token);

  @override
  List<Object> get props => [token];
}

class ReportLogout extends HomeEvent {}

class ChangeSort extends HomeEvent {
  final HomeLoaded state;

  const ChangeSort({required this.state});

  @override
  List<Object> get props => [state];
}

class CheckPairingCode extends HomeEvent {
  final String code;
  final String token;

  const CheckPairingCode({required this.code, required this.token});

  @override
  List<Object> get props => [code, token];
}

class UpdatePhoto extends HomeEvent {
  final String url;
  final HomeLoaded state;

  const UpdatePhoto({required this.url, required this.state});

  @override
  List<Object> get props => [url, state];
}
