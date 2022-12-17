part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHome extends HomeEvent {}

class UpdateHome extends HomeEvent {
  final List<String> tableList;

  const UpdateHome(this.tableList);

  @override
  List<Object> get props => [tableList];
}

class InsertHome extends HomeEvent {
  final List<String> tableList;
  final String newTable;

  const InsertHome(this.tableList, this.newTable);

  @override
  List<Object> get props => [tableList, newTable];
}
