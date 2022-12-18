import 'dart:convert';

import 'package:http/http.dart';
import 'package:log_app/functions.dart';
import 'package:log_app/models/row.dart';

Future<List<TableRow>> getTableRows(List serverConfig, String name) async {
  Response response = await get(
    Uri.parse("https://lukawski.xyz/logs/rows/?table_name=$name"),
    headers: getHeaders(serverConfig),
  );

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));

  if (decoded == null) return [];

  List<TableRow> rows = [];

  for (Map element in decoded) {
    rows.add(TableRow.fromMap(element));
  }

  return rows;
}

Future<void> removeRow(String tableName, int rowId, List serverConfig) async {
  await delete(
    Uri.parse("https://lukawski.xyz/logs/rows/?row_id=$rowId&table_name=$tableName"),
    headers: getHeaders(serverConfig),
  );
}
