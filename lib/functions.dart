import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger_app/strings.dart';

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

String getFavButtonString({required bool favorite}) {
  if (favorite) {
    return Strings.remFav;
  }

  return Strings.addFav;
}

Color favColor({
  required bool favorite,
  required BuildContext context,
  bool containerColor = false,
}) {
  if (favorite) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    if (isDarkMode) {
      ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
      );

      if (containerColor) return colorScheme.primaryContainer;
      return colorScheme.primary;
    }

    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.light,
    );

    if (containerColor) return colorScheme.primaryContainer;
    return colorScheme.primary;
  }

  if (containerColor) return Theme.of(context).colorScheme.primaryContainer;
  return Theme.of(context).colorScheme.primary;
}
