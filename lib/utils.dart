
import 'package:intl/intl.dart';

class Utils {
  static String dateTime2Str(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  }
}
