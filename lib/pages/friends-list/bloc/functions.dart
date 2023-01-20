import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/friend.dart';

Future<Map> getFriends({required String token}) async {
  Response response = await makeRequest(
    url: "https://loggerapp.lukawski.xyz/friends/",
    headers: {"Token": token},
    type: RequestType.get,
  );

  if (response.statusCode == 403) {
    return await getFriends(token: await renewToken());
  }

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
  if (decoded == null) return {"data": [], "token": token};

  List<Friend> list = [];
  for (Map element in decoded) {
    list.add(Friend.fromMap(element));
  }

  return {"data": list, "token": token};
}

Future<Map> addFriend({
  required String token,
  required String username,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/friends/?username=$username",
    headers: {"Token": token},
    type: RequestType.post,
  );
}

Future<Map> acceptFriend({
  required String token,
  required int id,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/friends/?id=$id",
    headers: {"Token": token},
    type: RequestType.patch,
  );
}

Future<Map> removeFriend({
  required String token,
  required int id,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/friends/?id=$id",
    headers: {"Token": token},
    type: RequestType.delete,
  );
}
