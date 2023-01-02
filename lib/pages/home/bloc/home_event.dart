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

  const UpdateHome({required this.lists, required this.token});

  @override
  List<Object> get props => [lists, token];
}

class InsertHome extends HomeEvent {
  final String name;
  final String token;

  const InsertHome({required this.name, required this.token});

  @override
  List<Object> get props => [name, token];
}

class QuickInsertHome extends HomeEvent {
  final ListOfItems list;
  final int timestamp;
  final String token;

  const QuickInsertHome({
    required this.list,
    required this.token,
    required this.timestamp,
  });

  @override
  List<Object> get props => [list, token, timestamp];
}

class RemoveFromHome extends HomeEvent {
  final List<ListOfItems> lists;
  final int id;
  final String token;

  const RemoveFromHome({
    required this.id,
    required this.lists,
    required this.token,
  });

  @override
  List<Object> get props => [id, lists, token];
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
