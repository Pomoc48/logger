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
  final List<ListOfItems> tables;
  final String token;

  const UpdateHome({required this.tables, required this.token});

  @override
  List<Object> get props => [tables, token];
}

class InsertHome extends HomeEvent {
  final String name;
  final String token;

  const InsertHome({required this.name, required this.token});

  @override
  List<Object> get props => [name, token];
}

class RemoveFromHome extends HomeEvent {
  final List<ListOfItems> tableList;
  final ListOfItems list;
  final String token;

  const RemoveFromHome({
    required this.list,
    required this.tableList,
    required this.token,
  });

  @override
  List<Object> get props => [list, tableList, token];
}

class ReportHomeError extends HomeEvent {
  final String token;

  const ReportHomeError(this.token);

  @override
  List<Object> get props => [token];
}

class ReportLogout extends HomeEvent {}
