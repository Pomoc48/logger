part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class LoadList extends ListEvent {
  final TableItem table;

  const LoadList(this.table);

  @override
  List<Object> get props => [table];
}

class UpdateList extends ListEvent {
  final List<TableRow> rowList;
  final String title;

  const UpdateList({required this.rowList, required this.title});

  @override
  List<Object> get props => [rowList, title];
}

class ReportListError extends ListEvent {}
