import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

Map<String, String> getHeaders() {
  List serverConfig = GetStorage().read('serverConfig');
  
  return {
    "Hostname": serverConfig[0],
    "Username": serverConfig[1],
    "Password": serverConfig[2],
    "Database": serverConfig[3],
  };
}

String dateTitle(DateTime date) {
  return DateFormat('d MMMM yyyy').format(date);
}

String dateSubtitle(DateTime date) {
  return DateFormat('EEEE, HH:mm').format(date);
}
