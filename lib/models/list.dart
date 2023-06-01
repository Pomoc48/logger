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

  List<int> getChartData() {
    return [0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2];
  }

  List<double> getLongChartData() {
    return [0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2];
  }

  @override
  List<Object> get props => [id, name, favorite, creationDate, dates];
}
