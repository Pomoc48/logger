import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/list.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<Map> getToken() async {
  String? refreshToken = GetStorage().read("refreshToken");
  if (refreshToken == null) {
    return {"success": false};
  }

  Response response = await post(
    Uri.parse("https://logger.mlukawski.com/refresh/"),
    headers: {"Rtoken": refreshToken},
  );

  return loginResult(response: response);
}

Future<Map> checkUpdate() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;

  Response response = await get(
    Uri.parse("https://logger.mlukawski.com/version/?v=$version"),
  );

  if (response.statusCode == 400) {
    Map map = jsonDecode(utf8.decode(response.bodyBytes));

    return {
      "success": false,
      "message": map["message"],
      "link": map["link"],
    };
  } else {
    return {"success": true};
  }
}

Future<Map> manualLoginResult({
  required String username,
  required String password,
}) async {
  Response response = await post(
    Uri.parse("https://logger.mlukawski.com/login/"),
    headers: {"Username": username, "Password": password},
  );

  return await loginResult(response: response, save: true);
}

Future<Map> registerResult({
  required String username,
  required String password,
}) async {
  return await makeRequest(
    url: "https://logger.mlukawski.com/register/",
    headers: {"Username": username, "Password": password},
    type: RequestType.post,
  );
}

Future<Map> getLists({required String token}) async {
  Response response = await makeRequest(
    url: "https://logger.mlukawski.com/lists/",
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
    url: "https://logger.mlukawski.com/lists/?list_name=$name",
    headers: {"Token": token},
    type: RequestType.post,
  );
}

Future<Map> removeList({
  required int id,
  required String token,
}) async {
  return await makeRequest(
    url: "https://logger.mlukawski.com/lists/?list_id=$id",
    headers: {"Token": token},
    type: RequestType.delete,
  );
}

Future<Map> updateListName({
  required int id,
  required String name,
  required String token,
}) async {
  return await makeRequest(
    url: "https://logger.mlukawski.com/lists/?list_name=$name&list_id=$id",
    headers: {"Token": token},
    type: RequestType.patch,
  );
}

Future<Map> updateListFav({
  required int id,
  required bool favourite,
  required String token,
}) async {
  int fav = favourite ? 1 : 0;

  return await makeRequest(
    url: "https://logger.mlukawski.com/lists/?favourite=$fav&list_id=$id",
    headers: {"Token": token},
    type: RequestType.patch,
  );
}

Future<Map> updatePhoto({
  required String url,
  required String token,
}) async {
  String urlEscaped = url.replaceAll("&", "%26");

  return await makeRequest(
    url: "https://logger.mlukawski.com/photo/?url=$urlEscaped",
    headers: {"Token": token},
    type: RequestType.post,
  );
}

Future<Map> loginResult({
  required Response response,
  bool save = false,
}) async {
  Map map = jsonDecode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    if (save) await GetStorage().write("refreshToken", map["refresh_token"]);
    return {
      "success": true,
      "token": map["token"],
      "username": map["username"],
      "profile_url": map["profile_url"],
    };
  }

  return {"success": false, "message": map["message"]};
}

Future<void> forgetSavedToken() async {
  await GetStorage().remove("refreshToken");
}

enum SortingType { countASC, countDESC, dateASC, dateDESC, name }

void sortList(List<ListOfItems> list) {
  String? sortType = GetStorage().read("sortType");
  sortType ??= SortingType.name.name;

  if (sortType == SortingType.countASC.name) {
    list.sort((a, b) => b.count.compareTo(a.count));
    return;
  }

  if (sortType == SortingType.countDESC.name) {
    list.sort((a, b) => a.count.compareTo(b.count));
    return;
  }

  if (sortType == SortingType.dateASC.name) {
    list.sort((a, b) {
      int bTime = b.creationDate.millisecondsSinceEpoch;
      int aTime = a.creationDate.millisecondsSinceEpoch;
      return bTime.compareTo(aTime);
    });
    return;
  }

  if (sortType == SortingType.dateDESC.name) {
    list.sort((a, b) {
      int bTime = b.creationDate.millisecondsSinceEpoch;
      int aTime = a.creationDate.millisecondsSinceEpoch;
      return aTime.compareTo(bTime);
    });
    return;
  }

  list.sort((a, b) => a.name.compareTo(b.name));
}
