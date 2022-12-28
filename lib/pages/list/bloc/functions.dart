import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/row.dart';

Future<Map> getTableRows({
  required String table,
  required String token,
}) async {
  Response response = await makeRequest(
    url: "https://loggerapp.lukawski.xyz/rows/?table_name=$table",
    headers: {"Token": token},
    type: RequestType.get,
  );

  if (response.statusCode == 403) {
    return await getTableRows(
      table: table,
      token: await renewToken(),
    );
  }

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
  if (decoded == null) return {"data": [], "token": token};

  List<RowItem> rows = [];
  for (Map element in decoded) {
    rows.add(RowItem.fromMap(element));
  }

  return {"data": rows, "token": token};
}

Future<Map> removeRow({
  required String table,
  required int rowId,
  required String token,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/rows/?row_id=$rowId&table_name=$table",
    headers: {"Token": token},
    type: RequestType.delete,
  );
}

Future<Map> addRow({
  required String table,
  required String timestamp,
  required String token,
}) async {
  return await makeRequest(
    url:
        "https://loggerapp.lukawski.xyz/rows/?timestamp=$timestamp&table_name=$table",
    headers: {"Token": token},
    type: RequestType.post,
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
