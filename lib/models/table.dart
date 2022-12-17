import 'package:equatable/equatable.dart';

class Table extends Equatable {
  final String name;
  final int rows;

  const Table({required this.name, required this.rows});

  factory Table.fromMap(dynamic map) {
    return Table(
      name: map["name"],
      rows: map["rows"],
    );
  }

  @override
  List<Object> get props => [name, rows];
}
