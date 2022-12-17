import 'package:equatable/equatable.dart';

class TableItem extends Equatable {
  final String name;
  final int rows;

  const TableItem({required this.name, required this.rows});

  factory TableItem.fromMap(dynamic map) {
    return TableItem(
      name: map["name"],
      rows: map["rows"],
    );
  }

  @override
  List<Object> get props => [name, rows];
}
