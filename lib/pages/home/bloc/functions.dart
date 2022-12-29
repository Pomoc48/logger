import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/list.dart';

Future<Map> autoLoginResult() async {
  String? username = GetStorage().read("username");
  String? password = GetStorage().read("password");

  if (username == null && password == null) {
    return {"success": false};
  }

  Response response = await post(
    Uri.parse("https://loggerapp.lukawski.xyz/login/"),
    headers: {"Username": username!, "Password": password!},
  );

  return loginResult(response: response);
}

Future<Map> manualLoginResult({
  required String username,
  required String password,
}) async {
  Response response = await post(
    Uri.parse("https://loggerapp.lukawski.xyz/login/"),
    headers: {"Username": username, "Password": password},
  );

  return await loginResult(
    response: response,
    save: () async {
      await GetStorage().write("username", username);
      await GetStorage().write("password", password);
    },
  );
}

Future<Map> registerResult({
  required String username,
  required String password,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/register/",
    headers: {"Username": username, "Password": password},
    type: RequestType.post,
  );
}

Future<Map> getLists({required String token}) async {
  Response response = await makeRequest(
    url: "https://loggerapp.lukawski.xyz/lists/",
    headers: {"Token": token},
    type: RequestType.get,
  );

  if (response.statusCode == 403) {
    return await getLists(token: await renewToken());
  }

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
  if (decoded == null) return {"data": [], "token": token};

  List<ListOfItems> tables = [];
  for (Map element in decoded) {
    tables.add(ListOfItems.fromMap(element));
  }

  return {"data": tables, "token": token};
}

Future<Map> addList({
  required String name,
  required String token,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/lists/?list_name=$name",
    headers: {"Token": token},
    type: RequestType.post,
  );
}

Future<Map> removeList({
  required int id,
  required String token,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/lists/?list_id=$id",
    headers: {"Token": token},
    type: RequestType.delete,
  );
}

Future<Map> loginResult({
  required Response response,
  Future<void> Function()? save,
}) async {
  Map map = jsonDecode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    if (save != null) await save();
    return {"success": true, "token": map["token"]};
  }

  return {"success": false, "message": map["message"]};
}

Future<void> forgetLoginCredentials() async {
  await GetStorage().remove("username");
  await GetStorage().remove("password");
}
