import 'dart:convert';

import 'package:http/http.dart';
import 'package:log_app/models/table.dart';


Future<List<TableItem>> getTables(List serverConfig) async {
  Response response = await get(
    Uri.parse("https://lukawski.xyz/logs/tables/"),
    headers: getHeaders(serverConfig),
  );

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));

  if (decoded == null) return [];

  List<TableItem> tables = [];

  for (Map element in decoded) {
    tables.add(TableItem.fromMap(element));
  }

  return tables;
}

Future<void> addTable(String name, List serverConfig) async {
  await post(
    Uri.parse("https://lukawski.xyz/logs/tables/?table_name=$name"),
    headers: getHeaders(serverConfig),
  );
}

Future<void> removeTable(String name, List serverConfig) async {
  await delete(
    Uri.parse("https://lukawski.xyz/logs/tables/?table_name=$name"),
    headers: getHeaders(serverConfig),
  );
}

Map<String, String> getHeaders(List serverConfig) {
  return {
    "Hostname": serverConfig[0],
    "Username": serverConfig[1],
    "Password": serverConfig[2],
    "Database": serverConfig[3],
  };
}
