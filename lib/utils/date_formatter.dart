import 'package:intl/intl.dart';

formatDate(String date) {
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  final String formatted = formatter.format(DateTime.parse(date));

  return formatted;
}
