import 'package:intl/intl.dart';

String dateTitle(DateTime date) {
  return DateFormat('d MMMM yyyy').format(date);
}

String dateSubtitle(DateTime date) {
  return DateFormat('EEEE, HH:mm').format(date);
}
