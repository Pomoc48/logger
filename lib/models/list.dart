import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logger_app/models/item.dart';

class ListOfItems extends Equatable {
  final Key id;
  final String name;
  final bool favorite;
  final DateTime creationDate;
  final List<ListItem> dates;

  const ListOfItems({
    required this.id,
    required this.name,
    required this.favorite,
    required this.creationDate,
    required this.dates,
  });

  factory ListOfItems.fromMap(dynamic map) {
    List<ListItem> dates = List<ListItem>.from(
      map['dates'].map((m) => ListItem.fromMap(m)),
    );

    return ListOfItems(
      id: Key(map["id"]),
      name: map["name"],
      favorite: map["favorite"],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map["creationDate"]),
      dates: dates,
    );
  }

  Map toMap() {
    return {
      "id": id.toString(),
      "name": name,
      "favorite": favorite,
      "creationDate": creationDate.millisecondsSinceEpoch,
      "dates": dates.map((e) => e.toMap()).toList(),
    };
  }

  bool _matchDates(DateTime d1, DateTime d2) {
    if (d1.day != d2.day) return false;
    if (d1.month != d2.month) return false;
    if (d1.year != d2.year) return false;
    return true;
  }

  int _countItemsInOneDay(DateTime date, List<ListItem> items) {
    int count = 0;

    for (ListItem element in items) {
      if (_matchDates(element.date, date)) count++;
    }

    return count;
  }

  List<int> getChartData() {
    List<int> intList = [];

    for (int a = 0; a < 30; a++) {
      DateTime now = DateTime.now().subtract(Duration(days: a));

      if (dates.any((item) => _matchDates(item.date, now))) {
        intList.add(_countItemsInOneDay(now, dates));
      } else {
        intList.add(0);
      }
    }

    return List.from(intList.reversed);
  }

  List<double> getLongChartData() {
    int itemCount = dates.length;
    List<double> doubleList = [];

    for (int a = 0; a < 30; a++) {
      DateTime now = DateTime.now().subtract(Duration(days: a));
      doubleList.add(itemCount.toDouble());

      if (dates.any((item) => _matchDates(item.date, now))) {
        itemCount -= _countItemsInOneDay(now, dates);
      }
    }

    return List.from(doubleList.reversed);
  }

  @override
  List<Object> get props => [id, name, favorite, creationDate, dates];
}
