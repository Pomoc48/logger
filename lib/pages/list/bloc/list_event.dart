part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class LoadList extends ListEvent {
  final ListOfItems list;
  final String token;

  const LoadList({required this.list, required this.token});

  @override
  List<Object> get props => [list, token];
}

class UpdateList extends ListEvent {
  final List<ListItem> itemList;
  final List<double> chartData;
  final ListOfItems list;
  final String token;

  const UpdateList({
    required this.itemList,
    required this.chartData,
    required this.list,
    required this.token,
  });

  @override
  List<Object> get props => [itemList, list, chartData, token];
}

class RemoveFromList extends ListEvent {
  final ListItem item;
  final ListOfItems list;
  final String token;

  const RemoveFromList({
    required this.item,
    required this.list,
    required this.token,
  });

  @override
  List<Object> get props => [item, list, token];
}

class ReportListError extends ListEvent {}

class InsertList extends ListEvent {
  final int timestamp;
  final ListOfItems list;
  final String token;

  const InsertList({
    required this.timestamp,
    required this.list,
    required this.token,
  });

  @override
  List<Object> get props => [timestamp, list, token];
}
