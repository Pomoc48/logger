part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListInitial extends ListState {}

class ListLoaded extends ListState {
  final List<ListOfItems> lists;
  final String? message;

  const ListLoaded({
    required this.lists,
    this.message,
  });

  @override
  List<Object> get props => [lists];
}
