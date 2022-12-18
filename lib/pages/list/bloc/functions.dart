import 'dart:convert';

import 'package:http/http.dart';
import 'package:log_app/functions.dart';
import 'package:log_app/models/row.dart';

Future<List<RowItem>> getTableRows(List serverConfig, String name) async {
  Response response = await get(
    Uri.parse("https://lukawski.xyz/logs/rows/?table_name=$name"),
    headers: getHeaders(serverConfig),
  );

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));

  if (decoded == null) return [];

  List<RowItem> rows = [];

  for (Map element in decoded) {
    rows.add(RowItem.fromMap(element));
  }

  return rows;
}

Future<void> removeRow(String table, int rowId, List serverConfig) async {
  await delete(
    Uri.parse("https://lukawski.xyz/logs/rows/?row_id=$rowId&table_name=$table"),
    headers: getHeaders(serverConfig),
  );
}

Future<void> addRow(String table, String timestamp, List serverConfig) async {
  await post(
    Uri.parse("https://lukawski.xyz/logs/rows/?timestamp=$timestamp&table_name=$table"),
    headers: getHeaders(serverConfig),
  );
}

List<double> getChartData(List<RowItem> rows) {
  int rowCount = rows.length;
  List<double> doubleList = [];

  for (int a = 0; a < 30; a++) {
    DateTime now = DateTime.now().subtract(Duration(days: a));
    doubleList.add(rowCount.toDouble());

    if (rows.any((item) => _matchDates(item.date, now))) {
      rowCount -= _countItemsInOneDay(now, rows);
    }
  }

  return List.from(doubleList.reversed);
}

int _countItemsInOneDay(DateTime date, List<RowItem> rows) {
  int count = 0;

  for (RowItem element in rows) {
    if (_matchDates(element.date, date)) count++;
  }

  return count;
}

bool _matchDates(DateTime d1, DateTime d2) {
  if (d1.day != d2.day) return false;
  if (d1.month != d2.month) return false;
  if (d1.year != d2.year) return false;
  return true;
}
