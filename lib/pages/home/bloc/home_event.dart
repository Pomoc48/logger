part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHome extends HomeEvent {}

class UpdateHome extends HomeEvent {
  final List<Table> tables;

  const UpdateHome(this.tables);

  @override
  List<Object> get props => [tables];
}

class InsertHome extends HomeEvent {
  final String newTable;

  const InsertHome(this.newTable);

  @override
  List<Object> get props => [newTable];
}

class RemoveFromHome extends HomeEvent {
  final List<Table> tableList;
  final Table table;

  const RemoveFromHome(this.table, this.tableList);

  @override
  List<Object> get props => [table, tableList];
}

class ReportHomeError extends HomeEvent {}
