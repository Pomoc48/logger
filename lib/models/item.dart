import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ListItem extends Equatable {
  final Key id;
  final DateTime date;

  const ListItem({
    required this.id,
    required this.date,
  });

  factory ListItem.fromMap(int timestamp) {
    return ListItem(
      id: UniqueKey(),
      date: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  int toTimestamp() {
    return date.millisecondsSinceEpoch;
  }

  @override
  List<Object> get props => [id, date];
}
