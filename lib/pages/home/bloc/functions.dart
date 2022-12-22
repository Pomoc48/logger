import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger_app/models/table.dart';

Future<List<TableItem>> getTables(String token) async {
  Response response = await get(
    Uri.parse("http://loggerapp.lukawski.xyz/tables/"),
    headers: {"Token": token},
  );

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));

  if (decoded == null) return [];

  List<TableItem> tables = [];

  for (Map element in decoded) {
    tables.add(TableItem.fromMap(element));
  }

  return tables;
}

Future<void> addTable(String table) async {
  await post(
    Uri.parse("https://lukawski.xyz/logs/tables/?table_name=$table"),
    // headers: getHeaders(), //TODO: add this
  );
}

Future<void> removeTable(String table) async {
  await delete(
    Uri.parse("https://lukawski.xyz/logs/tables/?table_name=$table"),
    // headers: getHeaders()/, //TODO: add this
  );
}
