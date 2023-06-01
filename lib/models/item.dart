import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ListItem extends Equatable {
  final Key id;
  final DateTime date;

  const ListItem({
    required this.id,
    required this.date,
  });

  factory ListItem.fromMap(dynamic map) {
    return ListItem(
      id: Key(map["id"]),
      date: DateTime.fromMillisecondsSinceEpoch(map["date"]),
    );
  }

  Map toMap() {
    return {
      "id": id.toString(),
      "date": date.millisecondsSinceEpoch,
    };
  }

  @override
  List<Object> get props => [id, date];
}
