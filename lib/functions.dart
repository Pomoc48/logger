import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logger_app/pages/home/bloc/functions.dart';
import 'package:logger_app/strings.dart';
import 'package:url_launcher/url_launcher.dart';

String dateTitle(DateTime date) {
  return DateFormat('d MMMM yyyy').format(date);
}

String dateSubtitle(DateTime date) {
  return DateFormat('EEEE, HH:mm').format(date);
}

void showSnack(BuildContext context, String message, bool mobile) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: mobile ? null : 500,
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSnackLink({
  required BuildContext context,
  required String message,
  required bool mobile,
  required String link,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: mobile ? null : 500,
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        textColor: Theme.of(context).colorScheme.inversePrimary,
        label: "Open",
        onPressed: () async => await launchUrl(
          Uri.parse(link),
          mode: LaunchMode.externalApplication,
        ),
      ),
    ),
  );
}

enum RequestType { post, get, delete, patch }

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
    case RequestType.patch:
      response = await patch(Uri.parse(url), headers: headers);
      break;
  }

  Map map = jsonDecode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    return {
      "success": true,
      "message": map["message"],
      "token": headers["Token"],
    };
  }

  if (response.statusCode == 403) {
    return await makeRequest(
      url: url,
      headers: {"Token": await renewToken()},
      type: type,
    );
  }

  return {
    "success": false,
    "message": map["message"],
    "token": headers["Token"],
  };
}

Future<String> renewToken() async {
  Map response = await getToken();
  return response["token"];
}

int dateToTimestamp(DateTime date, [TimeOfDay? time]) {
  if (time != null) {
    DateTime d = date.add(Duration(hours: time.hour, minutes: time.minute));
    return d.millisecondsSinceEpoch ~/ 1000;
  }
  return date.millisecondsSinceEpoch ~/ 1000;
}

String getFavButtonString({required bool favourite}) {
  if (favourite) {
    return Strings.remFav;
  }

  return Strings.addFav;
}

Color favColor({required bool favourite, required BuildContext context}) {
  if (favourite) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    if (isDarkMode) {
      return ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ).primary;
    }

    return ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    ).primary;
  }

  return Theme.of(context).colorScheme.primary;
}
