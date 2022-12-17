import 'package:equatable/equatable.dart';

class TableItem extends Equatable {
  final String name;
  final int rows;
  final List<int> chartData;

  const TableItem({
    required this.name,
    required this.rows,
    required this.chartData,
  });

  factory TableItem.fromMap(dynamic map) {
    return TableItem(
      name: map["name"],
      rows: map["rows"],
      chartData: List<int>.from(map["chart_data"]),
    );
  }

  @override
  List<Object> get props => [name, rows, chartData];
}
