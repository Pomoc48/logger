import 'package:equatable/equatable.dart';

class ListItem extends Equatable {
  final int id;
  final int number;
  final DateTime date;

  const ListItem({
    required this.number,
    required this.id,
    required this.date,
  });

  factory ListItem.fromMap(dynamic map) {
    return ListItem(
      number: map["number"],
      id: map["id"],
      date: DateTime.fromMillisecondsSinceEpoch(map["timestamp"] * 1000),
    );
  }

  @override
  List<Object> get props => [id, date, number];
}
