import 'dart:convert';

import 'package:http/http.dart';

Future<List<String>> getTables() async {
  Response response = await get(
    Uri.parse("https://lukawski.xyz/logs/tables/"),
  );

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));

  if (decoded == null) return [];

  return decoded.cast<String>();
}

Future<void> addTable(String name) async {
  Response response = await post(
    Uri.parse("https://lukawski.xyz/logs/tables/?table_name=$name"),
  );

  if (response.statusCode == 200) {
    return;
  }
}
