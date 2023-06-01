part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHome extends HomeEvent {}

class InsertHome extends HomeEvent {
  final String name;

  const InsertHome({required this.name});

  @override
  List<Object> get props => [name];
}

class QuickInsertHome extends HomeEvent {
  final Key listId;
  final DateTime date;

  const QuickInsertHome({
    required this.listId,
    required this.date,
  });

  @override
  List<Object> get props => [listId, date];
}

class RemoveFromHome extends HomeEvent {
  final Key id;

  const RemoveFromHome({required this.id});

  @override
  List<Object> get props => [id];
}

class ChangeSort extends HomeEvent {
  final SortingType sortingType;

  const ChangeSort({required this.sortingType});

  @override
  List<Object> get props => [sortingType];
}

class InsertListItem extends HomeEvent {
  final Key listId;
  final DateTime date;

  const InsertListItem({
    required this.listId,
    required this.date,
  });

  @override
  List<Object> get props => [listId, date];
}

class RemoveListItem extends HomeEvent {
  final Key listId;
  final Key itemId;

  const RemoveListItem({
    required this.listId,
    required this.itemId,
  });

  @override
  List<Object> get props => [listId, itemId];
}
