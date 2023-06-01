import 'package:equatable/equatable.dart';

class ListOfItems extends Equatable {
  final int id;
  final String name;
  final bool favorite;
  final int count;
  final DateTime creationDate;
  final List<int> chartData;

  const ListOfItems({
    required this.id,
    required this.name,
    required this.favorite,
    required this.count,
    required this.creationDate,
    required this.chartData,
  });

  factory ListOfItems.fromMap(dynamic map) {
    return ListOfItems(
      id: map["id"],
      name: map["name"],
      favorite: map["favourite"] == 1 ? true : false,
      count: map["count"],
      creationDate:
          DateTime.fromMillisecondsSinceEpoch(map["timestamp"] * 1000),
      chartData: List<int>.from(map["chart_data"]),
    );
  }

  @override
  List<Object> get props =>
      [id, name, favorite, count, creationDate, chartData];
}
