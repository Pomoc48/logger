import 'dart:convert';

import 'package:http/http.dart';
import 'package:log_app/models/table.dart';


Future<List<TableItem>> getTables() async {
  Response response = await get(
    Uri.parse("https://lukawski.xyz/logs/tables/"),
  );

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));

  if (decoded == null) return [];

  List<TableItem> tables = [];

  for (Map element in decoded) {
    tables.add(TableItem.fromMap(element));
  }

  return tables;
}

Future<void> addTable(String name) async {
  Response response = await post(
    Uri.parse("https://lukawski.xyz/logs/tables/?table_name=$name"),
  );

  // TODO: do something
  if (response.statusCode == 200) {
    return;
  }
}

Future<void> removeTable(String name) async {
  Response response = await delete(
    Uri.parse("https://lukawski.xyz/logs/tables/?table_name=$name"),
  );

  if (response.statusCode == 200) {
    return;
  }
}
