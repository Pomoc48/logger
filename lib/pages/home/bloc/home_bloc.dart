import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger_app/enums/list_sorting.dart';
import 'package:logger_app/models/item.dart';
import 'package:logger_app/models/list.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHome>((event, emit) async {
      GetStorage gs = GetStorage();

      String? sortType = gs.read("sortType");
      sortType ??= SortingType.name.name;

      List<ListOfItems> list = [];

      List? serialized = gs.read("listData");

      if (serialized != null) {
        list = List<ListOfItems>.from(
            serialized.map((e) => ListOfItems.fromMap(e)));
      }

      List<ListOfItems> sorted = _sortList(list, sortType);

      emit(HomeLoaded(lists: sorted));
    });

    on<InsertHome>((event, emit) {
      ListOfItems listOfItems = ListOfItems(
        id: UniqueKey(),
        name: event.name,
        favorite: false,
        itemCount: 0,
        creationDate: DateTime.now(),
        dates: const [],
      );

      List<ListOfItems> newState = List.from((state as HomeLoaded).lists);
      newState.add(listOfItems);

      emit(HomeLoaded(lists: newState));
    });

    on<QuickInsertHome>((event, emit) async {
      //TODO: do some loading
    });

    on<RemoveFromHome>((event, emit) async {
      List<ListOfItems> list = (state as HomeLoaded).lists;
      list.removeWhere((element) => element.id == event.id);

      emit(HomeLoaded(lists: list));
    });

    on<ChangeSort>((event, emit) {
      List<ListOfItems> sorted = _sortList(
        (state as HomeLoaded).lists,
        event.sortingType.name,
      );

      emit(HomeLoaded(lists: sorted));

      GetStorage().write("sortType", event.sortingType.name);
    });
  }
}

List<ListOfItems> _sortList(
  List<ListOfItems> list,
  String sortTypeName,
) {
  if (sortTypeName == SortingType.countASC.name) {
    list.sort((a, b) => b.itemCount.compareTo(a.itemCount));
  }

  if (sortTypeName == SortingType.countDESC.name) {
    list.sort((a, b) => a.itemCount.compareTo(b.itemCount));
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
