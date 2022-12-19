part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {
  final String title;
  const ListInitial(this.title);

  @override
  List<Object> get props => [title];
}

class ListLoaded extends ListState {
  final List<double> chartData;
  final List<RowItem> rowList;
  final String title;

  const ListLoaded({
    required this.rowList,
    required this.title,
    required this.chartData,
  });

  @override
  List<Object> get props => [rowList, title, chartData];
}

class ListError extends ListState {}
