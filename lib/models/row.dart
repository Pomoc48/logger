import 'package:equatable/equatable.dart';

class RowItem extends Equatable {
  final int number;
  final int id;
  final DateTime date;

  const RowItem({
    required this.number,
    required this.id,
    required this.date,
  });

  factory RowItem.fromMap(dynamic map) {
    return RowItem(
      number: map["number"],
      id: map["id"],
      date: DateTime.parse(map["date"]),
    );
  }

  @override
  List<Object> get props => [id, date, number];
}
