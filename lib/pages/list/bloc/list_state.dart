part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}

class ListLoaded extends ListState {
  final List<double> chartData;
  final List<ListItem> itemList;
  final ListOfItems list;
  final String token;

  const ListLoaded({
    required this.itemList,
    required this.list,
    required this.chartData,
    required this.token,
  });

  @override
  List<Object> get props => [itemList, list, chartData, token];
}

class ListError extends ListState {}

class ListMessage extends ListState {
  final String message;

  const ListMessage(this.message);

  @override
  List<Object> get props => [message];
}
