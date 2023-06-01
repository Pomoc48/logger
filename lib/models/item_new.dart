import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ListItemNew extends Equatable {
  final Key id;
  final DateTime date;

  const ListItemNew({
    required this.id,
    required this.date,
  });

  factory ListItemNew.fromMap(dynamic map) {
    return ListItemNew(
      id: Key(map["id"]),
      date: DateTime.fromMillisecondsSinceEpoch(map["date"]),
    );
  }

  Map toMap() {
    return {
      "id": id,
      "date": date.millisecondsSinceEpoch,
    };
  }

  @override
  List<Object> get props => [id, date];
}
