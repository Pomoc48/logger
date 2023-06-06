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

      List<ListOfItems> sorted = _sortList(list, sortType);

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

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.listAdded));
    });

    on<RemoveList>((event, emit) async {
      List<ListOfItems> newState = _getNewInstance(state);
      newState.removeWhere((element) => element.id == event.id);

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.listRemoved));
    });

    on<ChangeSort>((event, emit) async {
      List<ListOfItems> newState = _getNewInstance(state);
      List<ListOfItems> sorted = _sortList(newState, event.sortingType.name);

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

      await _saveLocally(newState);
      emit(ListLoaded(lists: newState, message: Strings.listFavToggle));
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

List<ListOfItems> _sortList(
  List<ListOfItems> list,
  String sortTypeName,
) {
  if (sortTypeName == SortingType.countASC.name) {
    list.sort((a, b) => b.dates.length.compareTo(a.dates.length));
  }

  if (sortTypeName == SortingType.countDESC.name) {
    list.sort((a, b) => a.dates.length.compareTo(b.dates.length));
  }

  if (sortTypeName == SortingType.dateASC.name) {
    list.sort((a, b) {
      int bTime = b.creationDate.millisecondsSinceEpoch;
      int aTime = a.creationDate.millisecondsSinceEpoch;

      return bTime.compareTo(aTime);
    });
  }

  if (sortTypeName == SortingType.dateDESC.name) {
    list.sort((a, b) {
      int bTime = b.creationDate.millisecondsSinceEpoch;
      int aTime = a.creationDate.millisecondsSinceEpoch;

      return aTime.compareTo(bTime);
    });
  }

  if (sortTypeName == SortingType.name.name) {
    list.sort((a, b) => a.name.compareTo(b.name));
  }

  return list;
}

List<double> _getChartData(List<ListItem> items) {
  int itemCount = items.length;
  List<double> doubleList = [];

  for (int a = 0; a < 30; a++) {
    DateTime now = DateTime.now().subtract(Duration(days: a));
    doubleList.add(itemCount.toDouble());

    if (items.any((item) => _matchDates(item.date, now))) {
      itemCount -= _countItemsInOneDay(now, items);
    }
  }

  return List.from(doubleList.reversed);
}

int _countItemsInOneDay(DateTime date, List<ListItem> items) {
  int count = 0;

  for (ListItem element in items) {
    if (_matchDates(element.date, date)) count++;
  }

  return count;
}

bool _matchDates(DateTime d1, DateTime d2) {
  if (d1.day != d2.day) return false;
  if (d1.month != d2.month) return false;
  if (d1.year != d2.year) return false;
  return true;
}
