import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_app/enums/list_sorting.dart';
import 'package:logger_app/models/item.dart';
import 'package:logger_app/models/list.dart';
import 'package:logger_app/strings.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<LoadHome>((event, emit) async {
      GetStorage gs = GetStorage();

      String? sortType = gs.read(DataKeys.sorting);
      sortType ??= SortingType.name.name;

      List<ListOfItems> list = [];

      List? serialized = gs.read(DataKeys.data);

      if (serialized != null) {
        list = List<ListOfItems>.from(
          serialized.map((e) => ListOfItems.fromMap(e)),
        );
      }

      List<ListOfItems> sorted = _sortList(
        list: list,
        sortTypeName: sortType,
      );

      emit(ListLoaded(lists: sorted));
    });

    on<InsertList>((event, emit) async {
      ListOfItems listOfItems = ListOfItems(
        id: UniqueKey(),
        name: event.name,
        favorite: false,
        creationDate: DateTime.now(),
        dates: const [],
      );

      List<ListOfItems> newState = _getNewInstance(state);
      newState.add(listOfItems);
      newState = _sortList(list: newState);

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.listAdded));
    });

    on<RemoveList>((event, emit) async {
      List<ListOfItems> newState = _getNewInstance(state);
      newState.removeWhere((element) => element.id == event.id);
      newState = _sortList(list: newState);

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.listRemoved));
    });

    on<ChangeSort>((event, emit) async {
      List<ListOfItems> newState = _getNewInstance(state);
      List<ListOfItems> sorted = _sortList(
        list: newState,
        sortTypeName: event.sortingType.name,
      );

      await GetStorage().write(DataKeys.sorting, event.sortingType.name);
      emit(ListLoaded(lists: sorted));
    });

    on<InsertListItem>((event, emit) async {
      List<ListOfItems> newState = _getNewInstance(state);

      int index = newState.indexWhere(
        (element) => element.id == event.listId,
      );

      List<ListItem> newDates = [...newState[index].dates];
      newDates.add(ListItem(id: UniqueKey(), date: event.date));

      ListOfItems newList = ListOfItems(
        id: event.listId,
        name: newState[index].name,
        favorite: newState[index].favorite,
        creationDate: newState[index].creationDate,
        dates: newDates,
      );

      newState[index] = newList;
      newState = _sortList(list: newState);

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.itemAdded));
    });

    on<RemoveListItem>((event, emit) async {
      List<ListOfItems> newState = _getNewInstance(state);

      int index = newState.indexWhere(
        (element) => element.id == event.listId,
      );

      List<ListItem> newDates = [...newState[index].dates];
      newDates.removeWhere((element) => element.id == event.itemId);

      ListOfItems newList = ListOfItems(
        id: event.listId,
        name: newState[index].name,
        favorite: newState[index].favorite,
        creationDate: newState[index].creationDate,
        dates: newDates,
      );

      newState[index] = newList;
      newState = _sortList(list: newState);

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.itemRemoved));
    });

    on<ToggleListFavorite>((event, emit) async {
      List<ListOfItems> newState = _getNewInstance(state);

      int index = newState.indexWhere(
        (element) => element.id == event.id,
      );

      ListOfItems newList = ListOfItems(
        id: event.id,
        name: newState[index].name,
        favorite: !newState[index].favorite,
        creationDate: newState[index].creationDate,
        dates: newState[index].dates,
      );

      newState[index] = newList;
      newState = _sortList(list: newState);

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.listFavToggle));
    });

    on<RenameList>((event, emit) async {
      List<ListOfItems> newState = _getNewInstance(state);

      int index = newState.indexWhere(
        (element) => element.id == event.listId,
      );

      ListOfItems newList = ListOfItems(
        id: event.listId,
        name: event.newName,
        favorite: newState[index].favorite,
        creationDate: newState[index].creationDate,
        dates: newState[index].dates,
      );

      newState[index] = newList;
      newState = _sortList(list: newState);

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.listRenamed));
    });
  }
}

List<ListOfItems> _getNewInstance(ListState state) {
  return List.from((state as ListLoaded).lists);
}

Future<void> _saveLocally(List<ListOfItems> lists) async {
  List data = lists.map((e) => e.toMap()).toList();
  await GetStorage().write(DataKeys.data, data);
}

List<ListOfItems> _sortList({
  required List<ListOfItems> list,
  String? sortTypeName,
}) {
  List<ListOfItems> favorites = [];
  List<ListOfItems> normal = [];

  if (sortTypeName == null) {
    sortTypeName = GetStorage().read(DataKeys.sorting);
    sortTypeName ??= SortingType.name.name;
  }

  for (ListOfItems element in list) {
    if (element.favorite) {
      favorites.add(element);
    } else {
      normal.add(element);
    }
  }

  if (sortTypeName == SortingType.countASC.name) {
    favorites.sort((a, b) => b.dates.length.compareTo(a.dates.length));
    normal.sort((a, b) => b.dates.length.compareTo(a.dates.length));
  }

  if (sortTypeName == SortingType.countDESC.name) {
    favorites.sort((a, b) => a.dates.length.compareTo(b.dates.length));
    normal.sort((a, b) => a.dates.length.compareTo(b.dates.length));
  }

  if (sortTypeName == SortingType.dateASC.name) {
    favorites.sort((a, b) {
      int bTime = b.creationDate.millisecondsSinceEpoch;
      int aTime = a.creationDate.millisecondsSinceEpoch;

      return bTime.compareTo(aTime);
    });

    normal.sort((a, b) {
      int bTime = b.creationDate.millisecondsSinceEpoch;
      int aTime = a.creationDate.millisecondsSinceEpoch;

      return bTime.compareTo(aTime);
    });
  }

  if (sortTypeName == SortingType.dateDESC.name) {
    favorites.sort((a, b) {
      int bTime = b.creationDate.millisecondsSinceEpoch;
      int aTime = a.creationDate.millisecondsSinceEpoch;

      return aTime.compareTo(bTime);
    });

    normal.sort((a, b) {
      int bTime = b.creationDate.millisecondsSinceEpoch;
      int aTime = a.creationDate.millisecondsSinceEpoch;

      return aTime.compareTo(bTime);
    });
  }

  if (sortTypeName == SortingType.name.name) {
    favorites.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    normal.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
  }

  return [...favorites, ...normal];
}
