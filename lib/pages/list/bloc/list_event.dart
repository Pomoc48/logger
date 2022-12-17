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
