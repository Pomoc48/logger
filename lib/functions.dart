import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

String dateTitle(DateTime date) {
  return DateFormat('d MMMM yyyy').format(date);
}

String dateSubtitle(DateTime date) {
  return DateFormat('EEEE, HH:mm').format(date);
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

enum RequestType {post, get, delete}

Future<dynamic> makeRequest({
  required String url,
  required Map<String, String> headers,
  required RequestType type,
}) async {
  Response response;

  switch (type) {
    case RequestType.post:
      response = await post(Uri.parse(url), headers: headers);
      break;
    case RequestType.get:
      return await get(Uri.parse(url), headers: headers);
    case RequestType.delete:
      response = await delete(Uri.parse(url), headers: headers);
      break;
  }

  Map map = jsonDecode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    return {"success": true, "message": map["message"]};
  }

  if (response.statusCode == 403) {
    return await makeRequest(
      url: url,
      headers: {"Token": await renewToken(headers)},
      type: type,
    );
  }

  return {"success": false, "message": map["message"]};
}

Future<String> renewToken(Map<String, String> headers) async {
  Response response = await post(
    Uri.parse("https://loggerapp.lukawski.xyz/renew/"),
    headers: headers,
  );

  return jsonDecode(utf8.decode(response.bodyBytes))["token"];
}

