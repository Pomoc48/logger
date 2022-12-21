import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

Future<Map> autoLoginResult() async {
  String? username = GetStorage().read("username");
  String? password = GetStorage().read("password");

  if (username == null && password == null) {
    return {"success": false};
  }

  Response response = await post(
    Uri.parse("http://loggerapp.lukawski.xyz/login/"),
    headers: {
      "Username": username!,
      "Password": password!,
    },
  );

  if (response.statusCode == 200) {
    return {
      "success": true,
      "token": jsonDecode(utf8.decode(response.bodyBytes))["token"],
    };
  }

  return {"success": false};
}