import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/list.dart';

Future<Map> getToken() async {
  String? refreshToken = GetStorage().read("refreshToken");
  if (refreshToken == null) {
    return {"success": false};
  }

  Response response = await post(
    Uri.parse("https://loggerapp.lukawski.xyz/refresh/"),
    headers: {"Rtoken": refreshToken},
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

  return await loginResult(response: response, save: true);
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

  List<ListOfItems> lists = [];
  for (Map element in decoded) {
    lists.add(ListOfItems.fromMap(element));
  }

  return {"data": lists, "token": token};
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
  bool save = false,
}) async {
  Map map = jsonDecode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    if (save) await GetStorage().write("refreshToken", map["refresh_token"]);
    return {"success": true, "token": map["token"]};
  }

  return {"success": false, "message": map["message"]};
}

Future<void> forgetSavedToken() async {
  await GetStorage().remove("refreshToken");
}

enum SortingType { count, date, name }

void sortList(List<ListOfItems> list) {
  SortingType type = getSortType();

  switch (type) {
    case SortingType.count:
      list.sort((a, b) => b.count.compareTo(a.count));
      break;
    case SortingType.name:
      list.sort((a, b) => a.name.compareTo(b.name));
      break;
    case SortingType.date:
      list.sort((a, b) {
        int bTime = b.timestamp.millisecondsSinceEpoch;
        int aTime = a.timestamp.millisecondsSinceEpoch;
        return bTime.compareTo(aTime);
      });
      break;
  }
}

SortingType getSortType() {
  String? sortType = GetStorage().read("sortType");

  if (sortType == SortingType.date.name) {
    return SortingType.date;
  }

  if (sortType == SortingType.count.name) {
    return SortingType.count;
  }

  return SortingType.name;
}

Future<Map> checkPairingCode({
  required String code,
  required String token,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/connect/?pin=$code",
    headers: {"Token": token},
    type: RequestType.post,
  );
}
