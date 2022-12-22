part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHome extends HomeEvent {
  final String token;

  const LoadHome(this.token);

  @override
  List<Object> get props => [token];
}

class UpdateHome extends HomeEvent {
  final List<TableItem> tables;
  final String token;

  const UpdateHome({required this.tables, required this.token});

  @override
  List<Object> get props => [tables, token];
}

class InsertHome extends HomeEvent {
  final String newTable;
  final String token;

  const InsertHome({required this.newTable, required this.token});

  @override
  List<Object> get props => [newTable, token];
}

class RemoveFromHome extends HomeEvent {
  final List<TableItem> tableList;
  final TableItem table;
  final String token;

  const RemoveFromHome({
    required this.table,
    required this.tableList,
    required this.token,
  });

  @override
  List<Object> get props => [table, tableList, token];
}

class ReportHomeError extends HomeEvent {
  final String token;

  const ReportHomeError(this.token);

  @override
  List<Object> get props => [token];
}

class ReportLogout extends HomeEvent {}
