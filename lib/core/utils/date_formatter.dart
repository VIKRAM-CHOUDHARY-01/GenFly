import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String toDisplayDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);
  static String toDisplayTime(DateTime date) => DateFormat('hh:mm a').format(date);
  static String toDisplayDateTime(DateTime date) => DateFormat('dd MMM yyyy, hh:mm a').format(date);
  static String toDayMonth(DateTime date) => DateFormat('dd MMM').format(date);
  static String toDayOfWeek(DateTime date) => DateFormat('EEE').format(date);
  static String toApiDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  static String flightDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m}m';
  }
}
