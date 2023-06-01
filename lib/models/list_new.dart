import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logger_app/models/item_new.dart';

class ListOfItems extends Equatable {
  final Key id;
  final String name;
  final bool favorite;
  final DateTime creationDate;
  final List<ListItemNew> dates;

  const ListOfItems({
    required this.id,
    required this.name,
    required this.favorite,
    required this.creationDate,
    required this.dates,
  });

  factory ListOfItems.fromMap(dynamic map) {
    return ListOfItems(
      id: Key(map["id"]),
      name: map["name"],
      favorite: map["favorite"],
      creationDate: DateTime.fromMillisecondsSinceEpoch(map["timestamp"]),
      dates: List<ListItemNew>.from(
        map['dates'].map((m) => ListItemNew.fromMap(m)),
      ),
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

  @override
  List<Object> get props => [id, name, favorite, creationDate];
}
