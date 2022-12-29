import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger_app/functions.dart';
import 'package:logger_app/models/item.dart';

Future<Map> getItems({
  required int listId,
  required String token,
}) async {
  Response response = await makeRequest(
    url: "https://loggerapp.lukawski.xyz/items/?list_id=$listId",
    headers: {"Token": token},
    type: RequestType.get,
  );

  if (response.statusCode == 403) {
    return await getItems(listId: listId, token: await renewToken());
  }

  dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
  if (decoded == null) return {"data": [], "token": token};

  List<ListItem> items = [];
  for (Map element in decoded) {
    items.add(ListItem.fromMap(element));
  }

  return {"data": items, "token": token};
}

Future<Map> removeItem({
  required int itemId,
  required String token,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/items/?item_id=$itemId",
    headers: {"Token": token},
    type: RequestType.delete,
  );
}

Future<Map> addItem({
  required int listId,
  required int timestamp,
  required String token,
}) async {
  return await makeRequest(
    url: "https://loggerapp.lukawski.xyz/items/?timestamp=$timestamp&list_id=$listId",
    headers: {"Token": token},
    type: RequestType.post,
  );
}

List<double> getChartData(List<ListItem> items) {
  int itemCount = items.length;
  List<double> doubleList = [];

  for (int a = 0; a < 30; a++) {
    DateTime now = DateTime.now().subtract(Duration(days: a));
    doubleList.add(itemCount.toDouble());

    if (items.any((item) => _matchDates(item.timestamp, now))) {
      itemCount -= _countItemsInOneDay(now, items);
    }
  }

  return List.from(doubleList.reversed);
}

int _countItemsInOneDay(DateTime date, List<ListItem> items) {
  int count = 0;

  for (ListItem element in items) {
    if (_matchDates(element.timestamp, date)) count++;
  }

  return count;
}

bool _matchDates(DateTime d1, DateTime d2) {
  if (d1.day != d2.day) return false;
  if (d1.month != d2.month) return false;
  if (d1.year != d2.year) return false;
  return true;
}
