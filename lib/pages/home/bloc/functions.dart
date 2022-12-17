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