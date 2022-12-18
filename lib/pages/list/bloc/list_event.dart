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

class RemoveFromList extends ListEvent {
  final TableRow row;
  final String title;

  const RemoveFromList({
    required this.row,
    required this.title,
  });

  @override
  List<Object> get props => [row, title];
}

class ReportListError extends ListEvent {}

class InsertList extends ListEvent {
  final String timestamp;
  final String name;

  const InsertList({
    required this.timestamp,
    required this.name,
  });

  @override
  List<Object> get props => [timestamp, name];
}
