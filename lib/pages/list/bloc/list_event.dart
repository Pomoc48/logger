part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class LoadList extends ListEvent {
  final ListOfItems table;
  final String token;

  const LoadList({required this.table, required this.token});

  @override
  List<Object> get props => [table, token];
}

class UpdateList extends ListEvent {
  final List<RowItem> rowList;
  final List<double> chartData;
  final String title;
  final String token;

  const UpdateList({
    required this.rowList,
    required this.chartData,
    required this.title,
    required this.token,
  });

  @override
  List<Object> get props => [rowList, title, chartData, token];
}

class RemoveFromList extends ListEvent {
  final RowItem row;
  final String title;
  final String token;

  const RemoveFromList({
    required this.row,
    required this.title,
    required this.token,
  });

  @override
  List<Object> get props => [row, title, token];
}

class ReportListError extends ListEvent {}

class InsertList extends ListEvent {
  final String timestamp;
  final String name;
  final String token;

  const InsertList({
    required this.timestamp,
    required this.name,
    required this.token,
  });

  @override
  List<Object> get props => [timestamp, name, token];
}
