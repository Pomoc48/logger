part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class LoadHome extends ListEvent {}

class InsertList extends ListEvent {
  final String name;

  const InsertList({required this.name});

  @override
  List<Object> get props => [name];
}

class RemoveList extends ListEvent {
  final Key id;

  const RemoveList({required this.id});

  @override
  List<Object> get props => [id];
}

class ChangeSort extends ListEvent {
  final SortingType sortingType;

  const ChangeSort({required this.sortingType});

  @override
  List<Object> get props => [sortingType];
}

class InsertListItem extends ListEvent {
  final Key listId;
  final DateTime date;

  const InsertListItem({
    required this.listId,
    required this.date,
  });

  @override
  List<Object> get props => [listId, date];
}

class RemoveListItem extends ListEvent {
  final Key listId;
  final Key itemId;

  const RemoveListItem({
    required this.listId,
    required this.itemId,
  });

  @override
  List<Object> get props => [listId, itemId];
}

class ToggleListFavorite extends ListEvent {
  final Key id;

  const ToggleListFavorite({required this.id});

  @override
  List<Object> get props => [id];
}
