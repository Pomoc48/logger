part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}

class ListLoaded extends ListState {
  final List<double> chartData;
  final List<RowItem> rowList;
  final String title;
  final String token;

  const ListLoaded({
    required this.rowList,
    required this.title,
    required this.chartData,
    required this.token,
  });

  @override
  List<Object> get props => [rowList, title, chartData, token];
}

class ListError extends ListState {}
