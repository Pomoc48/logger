import 'package:equatable/equatable.dart';

class TableRow extends Equatable {
  final int id;
  final DateTime date;

  const TableRow({
    required this.id,
    required this.date,
  });

  factory TableRow.fromMap(dynamic map) {
    return TableRow(
      id: map["id"],
      date: DateTime.parse(map["date"]),
    );
  }

  @override
  List<Object> get props => [id, date];
}
