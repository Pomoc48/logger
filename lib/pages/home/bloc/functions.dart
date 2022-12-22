import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger_app/models/table.dart';

Future<List<TableItem>> getTables({required String token}) async {
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

Future<void> addTable({
  required String table,
  required String token,
}) async {
  await post(
    Uri.parse("http://loggerapp.lukawski.xyz/tables/?table_name=$table"),
    headers: {"Token": token},
  );
}

Future<void> removeTable({
  required String table,
  required String token,
}) async {
  await delete(
    Uri.parse("http://loggerapp.lukawski.xyz/tables/?table_name=$table"),
    headers: {"Token": token},
  );
}
